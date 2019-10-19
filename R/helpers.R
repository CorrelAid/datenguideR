#' vector_collapse()
#'
#' @param vector Vector to collapse

vector_collapse <- function(vector) {
  vector %>%
    paste0(collapse = ", ") %>%
    paste0("[", ., "]")
}

#' paste_nv()
#'
#' @param field description

paste_nv <- function(field) {
  if (!is.null(field$value)) {
    if (field$type == "String") {
      value <- glue::glue('"<<field$value>>"', .sep = " ", .open = "<<", .close = ">>")
      nv <- glue::glue('<<field[["name"]]>> : <<value>>', .sep = " ", .open = "<<", .close = ">>")
    } else {
      nv <- glue::glue('<<field[["name"]]>> : <<field[["value"]]>>', .sep = " ", .open = "<<", .close = ">>")
    }
  } else {
    nv <- NULL
  }
  return(nv)
}

#' insert_regname()
#' 
#' Insert 'id, name,' after region to ensure that region id and name are always returned.
#'
#' @param field description

insert_regname <- function(field) {
  if (field$type == "Region") {
    b <- glue::glue("id, name,", .sep = " ", .open = "<<", .close = ">>")
  } else {
    b <- ""
  }
  return(b)
}

#' insert_page_nr()
#' 
#' Insert 'page, total, itemsPerPage,' after allRegions by default.
#'
#' @param field description

insert_page_nr <- function(field) {
  if (field$type == "RegionsResult") {
    b <- glue::glue("page, total, itemsPerPage,", .sep = " ", .open = "<<", .close = ">>")
  } else {
    b <- ""
  }
  return(b)
}

#' clean_region()
#' 
#' Clean retrieved data (if region id provided).
#'
#' @param .data description
#' 
#' @return Tidy data frame containing the retrieved results from the API call

clean_region <- function(.data) {

  raw <- .data %>%
    purrr::flatten() %>%
    purrr::flatten() %>%
    purrr::flatten() %>%
    tibble::as_tibble()
  
  tidy_dat <- raw %>% 
    purrr::discard(is.list) %>%
    ##TODO: Rename name in source sub dataset because there is already a "name" variable in main
    ##NOTE Lisa: Those two vars should not be overall source, but rather source for e.g. different params in TIERA8!
    dplyr::bind_cols(raw$source) %>%
    dplyr::rename_all(dplyr::recode, title_de = "GENESIS_source", name1 = "GENESIS_source_nr")
    
  return(tidy_dat)
}


#' clean_all_regions()
#' 
#' Clean retrieved data (if AllRegions endpoint is being called).
#'
#' @param raw description
#' @param region_id description
#' @param stat_name description
#' @param year description
#' @param substat_name description
#' @param parameter description
#' @param page_nr description
#' @param ipp description
#' @param nuts_nr description
#' @param lau_nr description
#' @param parent_chr description
#' @param all_regions description
#' 
#' @return Tidy data frame containing the retrieved results from the API call

clean_all_regions <- function(raw, 
                              year, 
                              stat_name, 
                              substat_name, 
                              parameter, 
                              region_id,
                              page_nr,
                              ipp, 
                              nuts_nr,
                              lau_nr, 
                              parent_chr,
                              all_regions) {
  
  # raw <- api_results
  
  current_page <- raw[["data"]][["allRegions"]][["page"]]
  total_items <- raw[["data"]][["allRegions"]][["total"]]
  items_per_page <- raw[["data"]][["allRegions"]][["itemsPerPage"]]
  
  # total_items <- 14
  # items_per_page <- 7
  
  if (length(raw[["data"]][["allRegions"]][["regions"]])==0) {
    stop("No data available for this variable! Try another one or a different nuts_nr/lau_nr.")
  }
  
  if (items_per_page >= total_items) {
    
    ## you are good
    final <- raw %>% 
      clean_ar()
    # print("you are good")
  } else {
    
    if (total_items %% items_per_page != 0) {
      n_pages <- floor(total_items/items_per_page)
      # print(n_pages)
    } else {
      n_pages <- floor(total_items/items_per_page) - 1
      # print(n_pages)
    }
    
    final <- current_page:n_pages %>% 
      purrr::map(~define_fields(
        ## region provided
        year, stat_name, substat_name, parameter, region_id, 
        ## for allregions
        page_nr = .x, ## iterate page num!
        ipp, nuts_nr, lau_nr, parent_chr,
        all_regions
      )) %>% 
      purrr::map_dfr(~get_results(.x, substat_name) %>% clean_ar)
    
  }
  
  return(final)
  
}




clean_ar <- function(raw) {
  
  # raw <- get_results(field = field, substat_name = substat_name)
  
  id_dat <- raw[["data"]][["allRegions"]][["regions"]] %>%
    magrittr::extract(1:2)
  
  list_dat <- raw[["data"]][["allRegions"]][["regions"]] %>%
    magrittr::extract(3)
  
  source_dat <- raw[["data"]][["allRegions"]][["regions"]] %>% 
    purrr::flatten() %>%
    purrr::flatten() %>% 
    magrittr::use_series(source) %>% 
    tibble::as_tibble() %>% 
    dplyr::slice(1) %>%
    dplyr::rename_all(dplyr::recode, title_de = "GENESIS_source", name = "GENESIS_source_nr")
    
  
  final <- list_dat %>%
    purrr::flatten() %>%
    purrr::map(tibble::as_tibble) %>%
    purrr::map(~purrr::discard(.x, is.list)) %>%
    purrr::set_names(id_dat$id) %>%
    purrr::map_dfr(~ .x %>% tibble::as_tibble(), .id = "id") %>%
    dplyr::left_join(id_dat, by = "id")  %>% 
    cbind(source_dat) %>% 
    tibble::as_tibble()
  
  
  return(final)
}


  

#' define_fields
#'
#' Creates fields for query.
#' 
#' @param region_id description
#' @param stat_name description
#' @param year description
#' @param substat_name description
#' @param parameter description
#' @param page_nr description
#' @param ipp description
#' @param nuts_nr description
#' @param lau_nr description
#' @param parent_chr description
#' @param all_regions all_regions
#' 
#' @return A list

define_fields <- function(year, 
                          stat_name, 
                          substat_name, 
                          parameter, 
                          region_id,
                          page_nr,
                          ipp, 
                          nuts_nr,
                          lau_nr, 
                          parent_chr,
                          all_regions) {
  
  # Define fields -----------------------------------------------------
  
  years <- list(
    "name" = "year",
    "value" = ifelse(length(year) == 1, year, vector_collapse(year)),
    "arguments" = list(),
    "subfield" = list(),
    "type" = "Int"
  )
  
  if (!is.null(substat_name)) {
    substat <- list(
      "name" = substat_name,
      "value" = ifelse(length(parameter) == 1, parameter, vector_collapse(parameter)),
      "arguments" = list(),
      "subfield" = list(),
      "type" = substat_name
    )    
    
    stat <- list(
      "name" = stat_name,
      "value" = list(),
      "arguments" = list(years, substat),
      "subfield" = list(substat),
      "type" = stat_name
    )
  }
  
  if (is.null(substat_name)) {
    stat <- list(
      "name" = stat_name,
      "value" = list(),
      "arguments" = list(years),
      "type" = stat_name
    )
  }
  
  id <- list(
    "name" = "id",
    "value" = region_id,
    "arguments" = list(),
    "subfield" = list(),
    "type" = "String"
  )
  
  region <- list(
    "name" = "region",
    "value" = list(),
    "arguments" = list(id),
    "subfield" = list(stat),
    "type" = "Region"
  )
  
  query_list <- list(
    "name" = "region",
    "value" = list(),
    "arguments" = list(),
    "subfield" = list(region),
    "type" = "query"
  )
  
  # Define allRegions fields -----------------------------------------------------
  if (all_regions) {
    page <- list(
      "name" = "page",
      "value" = page_nr, # if not given graphql default is 0
      "arguments" = list(),
      "subfield" = list(),
      "type" = "Int"
    )
    
    itemsPerPage <- list(
      "name" = "itemsPerPage",
      "value" = ipp, # if not given graphql default is 10
      "arguments" = list(),
      "subfield" = list(),
      "type" = "Int"
    )
    
    nuts <- list(
      "name" = "nuts",
      "value" = nuts_nr,
      "arguments" = list(),
      "subfield" = list(),
      "type" = "Int"
    )
    
    lau <- list(
      "name" = "lau",
      "value" = lau_nr,
      "arguments" = list(),
      "subfield" = list(),
      "type" = "Int"
    )
    
    parent <- list(
      "name" = "parent",
      "value" = parent_chr,
      "arguments" = list(),
      "subfield" = list(),
      "type" = "String"
    )
    
    regions <- list(
      "name" = "regions",
      "value" = list(),
      "arguments" = list(nuts, lau, parent),
      "subfield" = list(stat),
      "type" = "Region"
    )
    
    allRegions <- list(
      "name" = "allRegions",
      "value" = list(),
      "arguments" = list(page, itemsPerPage),
      "subfield" = list(regions),
      "type" = "RegionsResult"
    )
    
    query_list <- list(
      "name" = "allRegions",
      "value" = list(),
      "arguments" = list(),
      "subfield" = list(allRegions),
      "type" = "query"
    )
    
  }
  
  return(query_list)
}

#' add_substat_info
#'
#' Add Substat Info
#' 
#' @param api_results description
#' @param stat_name description
#' @param substat_name description
#' @param parameter description
#' @param full_descriptions description
#' @param all_regions description
#' 
#' @return A list

add_substat_info <- function(api_results, 
                             stat_name, 
                             substat_name, 
                             parameter, 
                             full_descriptions,
                             all_regions) {
  
  
  
  ## this is necessary unfortunately
  stat_name_ <- stat_name
  
  ## get meta data for specific call
  meta_info <- dg_descriptions %>%  
    dplyr::filter(stat_name == stat_name_) %>% 
    tidyr::drop_na(substat_name)
  
  ## if parameter is given, filter by it 
  if (!is.null(parameter)) {
    meta_info <- meta_info %>% 
      dplyr::filter(param_name %in% parameter)
  }
  
  if (!all_regions) {
    
    api_results <- api_results %>% 
      dplyr::group_by(year) %>% 
      dplyr::mutate(param_name = meta_info$param_name) %>% 
      dplyr::ungroup() %>% 
      dplyr::left_join(meta_info, by = "param_name") %>% 
      dplyr::select(-substat_name) %>% 
      tidyr::pivot_wider(names_from = param_name,
                         values_from = substat_name, 
                         id_cols = year) %>% 
      ## TODO: pivoting removed all previous variables so binding them again
      ## may not be the most elegant solution
      cbind(meta_info %>% 
              dplyr::slice(1) %>%
              dplyr::select(-param_name, -param_description)) %>% 
      cbind(api_results %>%
              dplyr::slice(1) %>% 
              dplyr::select(GENESIS_source, GENESIS_source_nr)) %>% 
      tibble::as_tibble()
    
  } else {
    
      api_results <- api_results %>% 
        dplyr::group_by(id, year) %>%
        dplyr::mutate(param_name = meta_info$param_name) %>% 
        dplyr::ungroup() %>% 
        dplyr::left_join(meta_info, by = "param_name") %>% 
        dplyr::select(-substat_name) %>% 
        dplyr::mutate(year_id = paste0(year, "_", id)) %>% 
        tidyr::pivot_wider(names_from = param_name,
                           values_from = substat_name, 
                           id_cols = year_id) %>%
        tidyr::separate(year_id, into = c("year", "id"), sep = "_") %>% 
        # dplyr::left_join(api_results %>% dplyr::select(id, name), by = "id") %>% 
        ## TODO: pivoting removed all previous variables so binding them again
        ## may not be the most elegant solution
        cbind(meta_info %>% 
                dplyr::slice(1) %>%
                dplyr::select(-param_name, -param_description)) %>% 
        tibble::as_tibble()

  }
  
  if (!full_descriptions) {
    api_results <- api_results %>% 
      dplyr::select(-stat_description_full)
  }
  
  return(api_results)
}
