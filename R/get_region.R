#' Get region information from dg_regions
#'
#' Imports geographical information on all regions. The data set contains
#' regional IDs on the NUTS-1, NUTS-2, NUTS-3 and LAU level.
#'
#' @param var Character string naming the variable for filtering. Can be either
#'   id, name, level or parent.
#' @param val Character string naming the value for filtering.
#'
#' @return A data frame containing geographical information on all regions.
#'
#' @examples
#' get_region(var = level, val = "nuts1")
#' @export

get_region <- function(var = NULL, val = NULL) {
  if (missing(var) | missing(val)) {
    dg_regions
  } else {
    dplyr::filter(.data = dg_regions, {{ var }} == val)
  }
}
