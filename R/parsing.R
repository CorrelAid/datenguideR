


vector_collapse <- function(vector) {
  vector %>% 
    paste0(collapse = ", ") %>% 
    paste0("[", ., "]")
}


# debugonce(query_builder)

query_builder <- function(regions = "11", 
                          year = "2017",
                          parties,
                          variable,
                          include_source = FALSE,
                          all = F) {
  
  ## Convert R boolean to GraphQL boolean
  include_source <- ifelse(include_source, "true", "false")
  
  
  # parties <- "CDU"
  # regions <- "11"
  
  if (length(parties) != 1) {
    
    parties <- vector_collapse(parties)
    
  }
  
  if (length(year) != 1) {
    
    year <- vector_collapse(year)
    
  }
  
  ## this needs to be reimplemented
  # if (all == T) {
  #   
  #   all <- ", filter: { PART04: { nin: []}}"
  #   
  # } else if (all == F) {
  #   
  #   all <- NULL
  #    
  # }
  
   ## create query
   query <- glue::glue(
   'query ($region_id :String!,$includeSource : Boolean = false){
      region(id:$region_id) {
        id
        name
        <<variable>>(year: <<year>>) {
          year
          <<variable>>: value
          source @include(if: $includeSource) {
            title_de
            valid_from 
            periodicity
            name
            url
          }
        }
      }
    }', .open = "<<", .close = ">>")
    
    ## create variables
    query_variables <- glue::glue('{
                                     "region_id": "<<regions>>", 
                                     "includeSource": <<include_source>>
                                   }', .open = "<<", .close = ">>")
    
    
    pbody <- list(query = query, variables = query_variables)
  
    return(pbody)
  
}

# query_builder(year = 2017,
#               parties = parties, variable = "BEVMK3")



# query_builder(parties = "CDU")

#' @export
get_results <- function(parties = c("SPD", "AFD", "DIELINKE"), ...) {
  result <- httr::POST(
    url = "https://api-next.datengui.de/graphql",
    body = query_builder(parties = parties, include_source = F, ...),
    encode = "json",
    httr::add_headers(.headers = c("Content-Type"="application/json"))
  )
  
  
  ## Stop if Error
  httr::stop_for_status(result)
  
  httr::content(result, as = 'text', encoding = "UTF-8") %>% 
    jsonlite::fromJSON()  
}


#' @export
clean_it <- function(results) {
  tidy_dat <- results %>%
    purrr::flatten() %>%
    purrr::flatten() %>%
    purrr::flatten() %>% 
    tibble::as_tibble() 
  
  return(tidy_dat)
}

#' Make a call to the Datenguide GraphQL API
#' 
#' Thins function will work with non-complex GraphQL API requests
#' 
#' @param region_id provide a valid region_id
#' @param years provide the years you want to make your request for
#' @export
dg_call <- function(region_id, years) {
  api_results <- get_results(region_id = region_id, year = years) %>% clean_it()
  return(api_results)
}



# dg_call(variable = "BEVMK3", year = 1990:2018)



## This code gets all variable descriptions ####

#' @export
get_description <- function() {
  desc_query <-
    '{
    __type(name: "Region") {
      fields {
        name
        description
      }
    }
  }'
  
  desc_results <- httr::POST(
    url = "https://api-next.datengui.de/graphql",
    body = list(query = desc_query),
    encode = "json",
    httr::add_headers(.headers = c("Content-Type"="application/json")))
  
  result_dat <- httr::content(desc_results, as = 'text', encoding = "UTF-8") %>%
    jsonlite::fromJSON()
  
  final <- result_dat[["data"]][["__type"]][["fields"]] %>% as_tibble()
  
  return(final)
  
}



# dg_descriptions <- get_description() %>% 
  # mutate(description = str_extract(description, '\\*\\*([^*]*)\\*\\*') %>% str_remove_all("\\*"))

# usethis::use_data(dg_descriptions, overwrite = T)


# query_builder(year = 2017,
              # parties = c("SPD", "AFD", "DIELINKE"))


#### Get Parties request ####

# query <- glue::glue(
#   'query ($region_id :String!,$includeSource : Boolean = false){
#       region(id:$region_id) {
#         id
#         name
#         WAHL09(year: <<year>>, PART04: <<parties>>) {
#           year
#           value
#           PART04
#           source @include(if: $includeSource) {
#             title_de
#             valid_from 
#             periodicity
#             name
#             url
#           }
#         }
#       }
#     }', .open = "<<", .close = ">>")

# 
# variable_and_inclusion_example ={
#   "query": """
# query foo ($x :String!,$includeSource : Boolean = false)       {
#   region(id:$x) {
#     id
#     name
#     	BEVMK3 {
#     value
#     year
#     source @include(if: $includeSource) {
#       name
#       url
#     }
#     }
#   }
# }
# """
#   ,
#   "operationName": "foo",
#   "variables": { "x": "01" ,
#     "includeSource" : False}
# }
# 
# 
# # url <- "https://granddebat.fr/graphql/internal"
# # 
# query <- "query ($x :String!,$includeSource : Boolean = false)       {
#    region(id:$x) {
#      id
#      name
#      	BEVMK3 {
#      value
#      year
#      source @include(if: $includeSource) {
#        name
#        url
#      }
#      }
#    }
# }"
# 
# query_variables <- '{"cursor": null,"count": 3000,"theme": null,"project": null,"userType": null,"search": null,"isFuture": null}'
# pbody <- list(query = query, variables = query_variables)
# # 
# # list(query = query)
