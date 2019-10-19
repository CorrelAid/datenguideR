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

#' clean_it()
#' 
#' Clean retrieved data.
#'
#' @param .data description
#' 
#' @return Tidy data frame containing the retrieved results from the API call

clean_it <- function(.data) {
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
                          parent_chr) {
  
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
  if (!missing(region_id)) {
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