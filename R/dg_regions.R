#' dg_regions.R
#'
#' Imports geographical information on all regions. The data set contains regional IDs on
#' the NUTS-1, NUTS-2, NUTS-3 and LAU level.
#' 
#' @param var Character string naming the variable for filtering. 
#' Can be either id, name, level or parent.
#' @param val Character string naming the value for filtering.
#'
#' @return Data frame containing geographical information on all regions
#'
#' @examples
#' dg_regions <- get_region(var = level, val = "nuts1")
#' dg_regions
#'
#' @export

get_region <- function(var = NULL, val = NULL) {
  df <- readr::read_csv(
      system.file("extdata", "regions.csv", package = "datenguideR"),
      col_types = "cccc"
    )
  if (missing(var) | missing(val)) {
    return(df)
  } else {
    var <- rlang::parse_expr(rlang::quo_name(rlang::enquo(var)))
    dplyr::filter(df, !!var == val)
  }
}

dg_regions <- get_region()

usethis::use_data(dg_regions, overwrite = TRUE)