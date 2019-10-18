#' get_results()
#'
#' POST file to the GraphQL API.
#' 
#' @param field description
#' @param substat_name description
#'
#' @return Data frame containing the requested data
#'
#' @export

get_results <- function(field, substat_name) {
  result <- httr::POST(
    url = "https://api-next.datengui.de/graphql",
    body = list("query" = dg_query_builder(field = field, substat_name = substat_name)),
    encode = "json",
    httr::add_headers(.headers = c("Content-Type" = "application/json"))
  )

  # stop if error
  httr::stop_for_status(result)

  final <- httr::content(result, as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON()
  
  return(final)
}

#' dg_call.R
#'
#' Makes a call to the Datenguide GraphQL API and returns the results.
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
#' @return Data frame containing the requested data
#'
#' @examples
#' dg_call(region_id = "11", year = c(2001, 2007), substat_name = 'TIERA8', 
#' parameter = c("TIERART2", "TIERART3"))
#'
#' @export
dg_call <- function(region_id = "03", 
                    stat_name = "BETR08", 
                    year = 2007, 
                    substat_name = "TIERA8",
                    parameter = NULL, 
                    page_nr = NULL, 
                    ipp = NULL, 
                    nuts_nr = NULL,
                    lau_nr = NULL, 
                    parent_chr = NULL) {
  
  # Define fields -----------------------------------------------------
  
  substat <- list(
    "name" = substat_name,
    "value" = ifelse(length(parameter) == 1, parameter, vector_collapse(parameter)),
    "arguments" = list(),
    "subfield" = list(),
    "type" = substat_name
  )

  years <- list(
    "name" = "year",
    "value" = ifelse(length(year) == 1, year, vector_collapse(year)),
    "arguments" = list(),
    "subfield" = list(),
    "type" = "Int"
  )

  stat <- list(
    "name" = stat_name,
    "value" = list(),
    "arguments" = list(years, substat),
    "subfield" = list(substat),
    "type" = stat_name
  )

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

  query_region <- list(
    "name" = "region",
    "value" = list(),
    "arguments" = list(),
    "subfield" = list(region),
    "type" = "query"
  )

  # Define allRegions fields -----------------------------------------------------
  
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

  query_allRegions <- list(
    "name" = "allRegions",
    "value" = list(),
    "arguments" = list(),
    "subfield" = list(allRegions),
    "type" = "query"
  )

  # Get results -----------------------------------------------------
  
  if (!is.null(region_id)) { # condition is probably not sufficient (throw error if region ids are not given for neither region nor allregions query)
    field <- query_region
  } else {
    field <- query_allRegions
  }

  api_results <- get_results(field = field, substat_name = substat_name) %>%
    clean_it()
  return(api_results)
}
