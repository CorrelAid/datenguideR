#' dg_regions.R
#'
#' Imports information on all regions.
#'
#' @return Data frame containing information on all regions
#'
#' @examples
#' dg_regions <- get_region()
#' dg_regions
#'
#' @export

get_region <- function(var = NULL, val = NULL) {
  if (missing(var) | missing(val)) {
    df <- readr::read_csv("data/regions.csv")
  } else {
    var <- rlang::parse_expr(quo_name(enquo(var)))

    df <- readr::read_csv("data/regions.csv") %>%
      filter(!!var == val)
  }

  return(df)
}

dg_regions <- get_region()

usethis::use_data(dg_regions, overwrite = T)