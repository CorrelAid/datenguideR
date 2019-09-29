#### This code builds and executes the query ####

library(tidyverse)


## Query builder

paste_nv <- function(field){
  if(field$type == 'String'){
    value <- glue::glue('"<<field$value>>"', .sep = ' ', .open = "<<", .close = ">>") # backslashes rausnehmen?!
    glue::glue('<<field[["name"]]>> : <<value>>', .sep = ' ', .open = "<<", .close = ">>")
  } else {
    glue::glue('<<field[["name"]]>> : <<field[["value"]]>>', .sep = ' ', .open = "<<", .close = ">>")
  }
}


query_builder <- function(field, substat_name){
  
  if(field$name == substat_name){ # stop recursive function on substat-level
    glue::glue('year, <<substat_name>>', .open = "<<", .close = ">>")
  } else {
  
  # check for field arguments
  if (length(field$arguments) > 1) {
    a <- lapply(field[['arguments']], paste_nv) %>%
      unlist(.) %>%
      paste0(., collapse = ', ')
    a <- glue::glue('( <<a>> )', .open = "<<", .close = ">>")
  }
  if (length(field$arguments) == 1) {
    a <- field[['arguments']][[1]] %>%
        paste_nv(.) %>% 
        paste0(., collapse = ', ') 
    a <- glue::glue('( <<a>> )', .open = "<<", .close = ">>")
  } 
  if (length(field$arguments) == 0) {
      a <- ''
    }
  
  # check for subfields
  if (length(field$subfield) == 0) {
    query <- glue::glue('<<field$name>> <<a>> { }', .open = "<<", .close = ">>")
  } else {
    subfield <- field$subfield
    query <- glue::glue('<<field$name>> <<a>> {<<glue::glue("<<purrr::map_chr(subfield, query_builder, substat_name = substat_name)>>", .open = "<<", .close = ">>")>>}',
                        .open = "<<", .close = ">>")
  }

  }

}


# Test values (without allRegions)
region_id <- '11'
stat_name <- 'BAU001'
substat_name <- 'BAUNW2'
parameter <- 'BAUNW101'
year <- 2002

#dg_values <- function(region_id, stat_name, substat_name, parameter, year) {
#  values <- tibble(
#    region_id = region_id, 
#    stat_name = stat_name, 
#    substat_name = substat_name, 
#    parameter = parameter, 
#    year = year)
#  return(values)
#}

# Test values
#query_input <- dg_values('11', 'BAU001', 'BAUNW2', 'BAUNW101', '2002') 


substat <- list('name' = substat_name,
                'value' = parameter,
                'arguments' = list(),
                'subfield'= list(),
                'type' = substat_name)

year <- list('name' = 'year',
             'value' = year,
             'arguments' = list(),
             'subfield'= list(),
             'type' = 'Int')

stat <- list('name' = stat_name, 
             'value' = list(),
             'arguments' = list(year, substat),
             'subfield'= list(substat),
             'type' = stat_name)

id <- list('name' = 'id',
           'value' = region_id,
           'arguments' = list(),
           'subfield'= list(),
           'type' = 'String')

region <- list('name' = 'region',
               'value' = list(),
               'arguments' = list(id),
               'subfield' = list(stat),
               'type' = 'Region')

query_region <- list('name' = 'region', # how to preserve blank space?
                     'value' = list(),
                     'arguments' = list(),
                     'subfield' = list(region),
                     'type' = 'Region')


query_builder_final <- function(field, substat_name) {
  query <- query_builder(field = field, substat_name = substat_name)
  query_final <- glue::glue('query <<query>>', .open = "<<", .close = ">>")
}


## Get results

#' @export
get_results <- function(field, substat_name, ...) {
  result <- httr::POST(
    url = "https://api-next.datengui.de/graphql",
    body = list('query' = query_builder_final(field = field, substat_name = substat_name)),
    encode = "json",
    httr::add_headers(.headers = c("Content-Type"="application/json"))
  )
  
  # stop if error
  httr::stop_for_status(result)
  
  httr::content(result, as = "text", encoding = "UTF-8") %>% 
    jsonlite::fromJSON()  

}


## Clean results

clean_it <- function(results) {
  tidy_dat <- results %>%
    purrr::flatten() %>%
    purrr::flatten() %>%
    purrr::flatten() %>% 
    tibble::as_tibble() 
  return(tidy_dat)
}


## Call to the Datenguide GraphQL API

dg_call <- function(field, substat_name) {
  api_results <- get_results(field = query_region, substat_name = substat_name) %>% 
    clean_it()
  return(api_results)
}


## Test call

result_df <- dg_call(field = query_region, substat_name = 'BAUNW2')
