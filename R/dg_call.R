#' get_results()
#'
#' POST file to the GraphQL API.
#' 
#' @param field description
#' @param stat_name description
#' @param substat_name description
#'
#' @return Data frame containing the requested data
#'
#' @export

get_results <- function(field, substat_name, stat_name) {
  result <- httr::POST(
    url = "https://api-next.datengui.de/graphql",
    body = list("query" = dg_query_builder(field = field, 
                                           substat_name = substat_name, 
                                           stat_name = stat_name)),
    encode = "json",
    httr::add_headers(.headers = c("Content-Type" = "application/json"))
  )

  # stop if error
  httr::stop_for_status(result)

  final <- httr::content(result, as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON()

  return(final)
}

#' dg_call()
#'
#' Makes a call to the Datenguide GraphQL API and returns the results.
#' 
#' @param region_id TODO: ADD_FORMAT containing the ID of a specific region.
#' @param stat_name Character string containing the name of the main statistic. Please see dg_descriptions for a full list.
#' @param year Numeric year(s) for which you want to retrieve the data. 
#' @param substat_name Character string containing the name of the sub-statistic. Please see dg_descriptions for a full list. Defaults to all available sub-statistics if not specified.
#' @param parameter Character string containing the name(s) of the parameter(s) you want to retrieve. Please see dg_descriptions for a full list. Defaults to all available parameters if not specified.
#' @param ipp description
#' @param nuts_nr TODO: ADD_FORMAT containing the number of the NUTS level. 1 refers to NUTS-1, 2 to NUTS-2, and 3 to NUTS-3.
#' @param lau_nr TODO: ADD_FORMAT containing the number of the LAU level.
#' TODO: Change this as it can currently only be "1".
#' @param parent_chr description
#' @param full_descriptions If `TRUE`, the returning data frame will contain the full descriptions of the
#' statistics as provided by GENESIS. Defaults to `FALSE`.
#' @param page_nr description
#' @param long_format If `TRUE`, the returning data frame will be in long format.
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
                    ipp = 150,
                    nuts_nr = NULL,
                    lau_nr = NULL,
                    parent_chr = NULL,
                    full_descriptions = FALSE,
                    page_nr = NULL,
                    long_format = TRUE) {
  
  if (!is.null(lau_nr)) {
    yea_right <- usethis::ui_yeah("Retrieving data on the LAU level might take an hour or more. Are you sure you want to continue?")
    if (!yea_right) {
      message("That's OK! I'll be here when you have more time. :)")
      return(NULL)
    }
  }

  # Errors and warnings -----------------------------------------------------

  if (missing(stat_name)) {
    stop("Please provide the name of the main statistic you want to retrieve.")
  }

  ## TODO: We should change param input for region_id/nuts_nr/lau_nr so that dg_call accepts both num and char and converts it internally.
  ## But we have to make sure that the string doesn't reduce to e.g. 3 (needs to be 03) for single-digit region ids.
  ## We should also implement a function to convert single-digit region ids to two-digits id (eg 3 to 03); otherwise this is misleading given the information in dg_regions!
  ## Alternatively, we need to implement a warning that single-digits regions ids need to have a 0 in front of the number provided in dg_regions.
  if (missing(region_id) & missing(nuts_nr) & missing(lau_nr)) {
    stop("Please provide either a region ID to query a single region or specify a NUTS or LAU level to query all regions on the selected regional level.")
  }

  if (missing(region_id)) {
    all_regions <- TRUE
  } else {
    all_regions <- FALSE
  }
  
  stats_with_subs <- dg_descriptions %>% 
    dplyr::group_by(stat_name) %>% 
    dplyr::distinct(substat_name) %>%
    tidyr::drop_na() %>% 
    dplyr::count(stat_name, sort = T) %>% 
    dplyr::filter(n >= 2)
  
  if (missing(substat_name) & stat_name %in% stats_with_subs$stat_name) {
    stop("Please provide a substat for this statistic")
  }
  


  ## TODO: Add Warning for missing years.
  
  # Messages -----------------------------------------------------
  
  if (!all_regions) {
    ## BW
    if (region_id == "08" & stat_name == "TIE003") {
      message('"A alde Kuah vrgissd g\u00e4rn, da\u00df se au amol a Kalb gw\u00e4 isch."')
    }
    
    ## BY
    if (region_id == "09" & stat_name == "BEVSTD") {
      message('"Hintam Berg san a no Leit."')
    }
    
    ## BE
    if (region_id == "11" & stat_name == "EKF002") {
      message('"Jeld macht nich jl\u00fccklich, man muss et ooch haben."')
    }
    
    ## HE
    if (region_id == "06" & stat_name == "BEV004") {
      message('"Woann m\u00e4r ebbes Unangenehmes vor sisch hot, oafach umdrehe. Doann hot m\u00e4rs hinner sisch."')
    }
    
    ## RP
    if (region_id == "07" & stat_name == "ERWZ02") {
      message('"Liewer en Bauch vum Esse wie en Buckel vum Schaffe."')
    }
    
  }
  

  # Set default value for page_nr and define fields -----------------------------------------------------
  
  if (all_regions) {
    page_nr <- 0
  }
  
  field <- define_fields(
    ## region_id provided
    year, stat_name, substat_name, parameter, region_id,
    ## all regions
    page_nr, ipp, nuts_nr, lau_nr, parent_chr,
    all_regions
  )
  

  # Get results -----------------------------------------------------

  if (!all_regions) {
    api_results <- get_results(field = field, substat_name = substat_name, 
                               stat_name = stat_name) %>%
      clean_region()

    if (!long_format) {
      if (is.null(substat_name)) {
        api_results <- api_results %>%
          tidyr::pivot_wider(names_from = year, values_from = value)
      }
    }
  } else {
    api_results <- get_results(field = field, substat_name = substat_name,
                               stat_name = stat_name) %>%
      clean_all_regions(
        ## region_id provided
        year, stat_name, substat_name, parameter, region_id,
        ## all regions
        page_nr, ipp, nuts_nr, lau_nr, parent_chr,
        all_regions
      )
  }

  # ## This is an if statement that handles when we need to get more info on a substat and its parameters
  if (!is.null(substat_name)) {

    ## TODO: This is necessary because Travis (for some reason) sometimes treats API results as empty
    add_substat_info <- purrr::possibly(add_substat_info, otherwise = NULL)

    api_results <- add_substat_info(
        api_results,
        stat_name,
        substat_name,
        parameter,
        full_descriptions,
        all_regions,
        long_format
    )

    # if (is.null(api_results)) {
    #   stop("Sorry, this statistic isn't implemented yet. Please try another one and/or retrieve the data for this statistic via https://www.regionalstatistik.de/genesis/online/")
    # }



  } else if (is.null(substat_name)){
    
    stat_name_ <- stat_name
  
    ## get meta data for specific call
    meta_info <- dg_descriptions %>%  
      dplyr::filter(stat_name == stat_name_) 
      ##TODO: sometimes it says GESAMT sometimes it says INSGESAMT, really odd
      # dplyr::filter(param_name != "INSGESAMT") 
    
    api_results <- api_results %>% 
      dplyr::mutate(stat_name = stat_name_) %>% 
      dplyr::left_join(meta_info, by = "stat_name") %>% 
      dplyr::select_if(~sum(!is.na(.)) > 0)
    
    if (nrow(api_results)==0){
      stop("No data returned. Try different values for year or other combination of inputs.")
    }

    if (!full_descriptions) {
      api_results <- api_results %>% 
        dplyr::select(-stat_description_full, -stat_description_full_en)
    }
  }
  
  api_results <- api_results %>% dplyr::distinct()
  

  return(api_results)
}
