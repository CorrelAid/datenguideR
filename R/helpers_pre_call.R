#' vector_collapse()
#'
#' @param vector Vector to collapse

vector_collapse <- function(vector) {
  vector %>%
    paste0(collapse = ", ") %>%
    paste0("[", ., "]")
}

#' define_fields
#'
#' Converts given variables into field structure which are processed in query_builder().
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
