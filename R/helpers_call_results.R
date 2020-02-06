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
    purrr::list_modify("__type" = NULL) %>%
    purrr::flatten() %>%
    purrr::flatten() %>%
    tibble::as_tibble(.name_repair = "unique")

  tidy_dat <- raw %>%
    purrr::discard(is.list) %>%
    ## TODO: Rename name in source sub dataset because there is already a "name" variable in main
    ## NOTE Lisa: Those two vars should not be overall source, but rather source for e.g. different params in TIERA8!
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

  # raw <- final

  current_page <- raw[["data"]][["allRegions"]][["page"]]
  total_items <- raw[["data"]][["allRegions"]][["total"]]
  items_per_page <- raw[["data"]][["allRegions"]][["itemsPerPage"]]

  # total_items <- 14
  # items_per_page <- 7

  if (length(raw[["data"]][["allRegions"]][["regions"]]) == 0) {
    stop("No data available for this variable! Try another one or a different nuts_nr/lau_nr.")
  }

  if (items_per_page >= total_items) {

    ## you are good
    final <- raw %>%
      clean_ar()
    # print("you are good")
  } else {
    if (total_items %% items_per_page != 0) {
      n_pages <- floor(total_items / items_per_page)
      # print(n_pages)
    } else {
      n_pages <- floor(total_items / items_per_page) - 1
      # print(n_pages)
    }

    final <- current_page:n_pages %>%
      purrr::map(~ define_fields(
        ## region provided
        year, stat_name, substat_name, parameter, region_id,
        ## for allregions
        page_nr = .x, ## iterate page num!
        ipp, nuts_nr, lau_nr, parent_chr,
        all_regions
      )) %>%
      purrr::map_dfr(~ get_results(.x, substat_name, stat_name) %>% clean_ar())

    # ss %>%
    #   .[[2]] %>%
    #   # purrr::flatten() %>%
    #   dg_query_builder(stat_name, substat_name)
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
    purrr::map(~ purrr::discard(.x, is.list)) %>%
    purrr::set_names(id_dat$id) %>%
    purrr::map_dfr(~ .x %>% tibble::as_tibble(), .id = "id") %>%
    dplyr::left_join(id_dat, by = "id")

  ## TODO: This is necessary because Travis (for some reason) sometimes thinks source_dat is empty
  if (!(nrow(source_dat) == 0)) {
    final <- final %>%
      cbind(source_dat) %>%
      tibble::as_tibble()
  }


  return(final)
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
#' @param all_regions description#'
#' @param long_format description
#'
#' @return A tibble

add_substat_info <- function(api_results,
                             stat_name,
                             substat_name,
                             parameter,
                             full_descriptions,
                             all_regions,
                             long_format) {



  ## this is necessary unfortunately
  stat_name_ <- stat_name
  substat_name_ <- substat_name

  meta_names <- c(
    "stat_name", "stat_description",
    "stat_description_full", "substat_name",
    "substat_description", substat_name_, "param_description",
    "stat_description_en", "stat_description_full_en",
    "substat_description_en", "param_description_en"
  )


  ## get meta data for specific call
  meta_info <- dg_descriptions %>%
    dplyr::filter(stat_name == stat_name_) %>%
    dplyr::filter(substat_name == substat_name_) %>%
    ## TODO: sometimes it says GESAMT sometimes it says INSGESAMT, really odd
    # dplyr::filter(param_name != "INSGESAMT") %>%
    tidyr::drop_na(substat_name) %>%
    purrr::set_names(meta_names)

  ## if parameter is given, filter by it
  # if (!is.null(parameter)) {
  #   meta_info <- meta_info %>%
  #     dplyr::filter(param_name %in% parameter)
  # }


  if (!all_regions) {
    suppressMessages(
      api_results <- api_results %>%
        dplyr::left_join(meta_info, by = substat_name_)
    )

    if (!is.null(substat_name)) {
      if (!long_format) {
        api_results <- api_results %>%
          dplyr::select(-substat_name) %>%
          tidyr::pivot_wider(
            names_from = substat_name_,
            values_from = value,
            id_cols = year
          ) %>%
          ## TODO: pivoting removed all previous variables so binding them again
          ## may not be the most elegant solution
          cbind(meta_info %>%
            dplyr::slice(1) %>%
            dplyr::select(-substat_name_, -param_description)) %>%
          cbind(api_results %>%
            dplyr::slice(1) %>%
            dplyr::select(GENESIS_source, GENESIS_source_nr)) %>%
          tibble::as_tibble()
      }
    }
  } else {
    suppressMessages(
      api_results <- api_results %>%
        dplyr::left_join(meta_info, by = substat_name_) %>%
        dplyr::select(-substat_name) %>%
        dplyr::mutate(year_id = paste0(year, "_", id)) #
    )

    if (!long_format) {
      api_results <- api_results %>%
        tidyr::pivot_wider(
          names_from = substat_name_,
          values_from = value,
          id_cols = year_id
        ) %>%
        tidyr::separate(year_id, into = c("year", "id"), sep = "_") %>%
        # dplyr::left_join(api_results %>% dplyr::select(id, name), by = "id") %>%
        ## TODO: pivoting removed all previous variables so binding them again
        ## may not be the most elegant solution
        cbind(meta_info %>%
          dplyr::slice(1) %>%
          dplyr::select(-substat_name_, -param_description)) %>%
        tibble::as_tibble()
    }
  }

  if (!full_descriptions) {
    api_results <- api_results %>%
      dplyr::select(-stat_description_full, -stat_description_full_en)
  }

  return(api_results)
}
