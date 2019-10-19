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

#' dg_call
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
#' @param full_descriptions description
#'
#' @return Data frame containing the requested data
#'
#' @examples
#' dg_call(region_id = "11", 
#'    year = c(2001, 2007), 
#'    stat_name = "BETR08",
#'    substat_name = 'TIERA8', 
#'    parameter = c("TIERART2", "TIERART3"))
#'
#' @export
dg_call <- function(region_id = NULL, 
                    stat_name = NULL, 
                    year = NULL, 
                    substat_name = NULL,
                    parameter = NULL, 
                    page_nr = NULL, 
                    ipp = NULL, 
                    nuts_nr = NULL,
                    lau_nr = NULL, 
                    parent_chr = NULL,
                    full_descriptions = FALSE) {
  
  if (missing(year)) {
    year <- c(1990:format(Sys.Date(), "%Y")) # Does this cover all years?
  }
  
  # Errors and warnings -----------------------------------------------------
  
  if (missing(stat_name)) {
    stop("Please provide the name of the statistic you want to retrieve.")
  }
  
  ## TODO: We should change param input for region_id/nuts_nr/lau_nr so that dg_call accepts both num and char and converts it internally.
  ## But we have to make sure that the string doesn't reduce to e.g. 3 (needs to be 03) for single-digit region ids.
  ## We should also implement a function to convert single-digit region ids to two-digits id (eg 3 to 03); otherwise this is misleading given the information in dg_regions!
  ## Alternatively, we need to implement a warning that single-digits regions ids need to have a 0 in front of the number provided in dg_regions.
  if (missing(region_id) & missing(nuts_nr) & missing(lau_nr)) {
    stop("Please provide either region_id to query regions or lau_nr/nuts_nr to query all regions. See ?dg_call for an example.")
  } 
  
  ## TODO: Add Warning for missing years.
  
  ## Define Fields, handles allregions vs. regions internaly
  field <- define_fields(
    ## region provided
    year, stat_name, substat_name, parameter, region_id, 
    ## for allregions
    page_nr, ipp, nuts_nr, lau_nr, parent_chr
  )
  


  

  # Get results -----------------------------------------------------

  api_results <- get_results(field = field, substat_name = substat_name) %>%
    clean_it()
  
  ## This is an if statement that handles when we need to get more info on a substat and its parameters
  ## TODO: is this the right condition to trigger getting subinfos??
  if (!is.null(substat_name)) {
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
    
    if (!full_descriptions) {
      api_results <- api_results %>% 
        dplyr::select(-stat_description_full)
    }
  }
  
  return(api_results)
}
