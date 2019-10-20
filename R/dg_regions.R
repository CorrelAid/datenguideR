#' dg_regions.R
#'
#' Imports information on all regions.
#' 
#' @param var Character string naming variable for filtering. 
#' Can be either id, name, level or parent.
#' @param val Character string naming the value for filtering.
#'
#' @return Data frame containing information on all regions
#'
#' @examples
#' dg_regions <- get_region(var = level, val = "nuts1")
#' dg_regions
#'
#' @export

get_region <- function(var = NULL, val = NULL) {
  if (missing(var) | missing(val)) {
    suppressWarnings(df <- readr::read_csv(system.file("extdata", "regions.csv", package = "datenguideR")))
  } else {
    var <- rlang::parse_expr(rlang::quo_name(rlang::enquo(var)))

    suppressWarnings(df <- readr::read_csv(system.file("extdata", "regions.csv", package = "datenguideR")) %>%
      dplyr::filter(!!var == val))
  }

  return(df)
}

dg_regions <- get_region()

usethis::use_data(dg_regions, overwrite = TRUE)