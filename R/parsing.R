
dg_glue <- function(...) {
  
  glue::glue(..., .open = "<<", .close = ">>")
  
}


vector_collapse <- function(vector) {
  vector %>% 
    paste0(collapse = ", ") %>% 
    paste0("[", ., "]")
}


# debugonce(query_builder)

query_builder <- function(regions = "11", 
                          year = "2017",
                          parties,
                          all = F) {
  
  
  # parties <- "CDU"
  # regions <- "11"
  
  if (length(parties) != 1) {
    
    parties <- vector_collapse(parties)
    
  }
  
  if (length(year) != 1) {
    
    year <- vector_collapse(year)
    
  }
  
  if (all == T) {
    
    all <- ", filter: { PART04: { nin: []}}"
    
  } else if (all == F) {
    
    all <- NULL
    
  }
  
  
    query <- glue::glue('{
      region(id: "<<regions>>") {
        id
        name
        WAHL09(year: <<year>>, PART04: <<parties>>) {
          year
          value
          PART04
          source {
            title_de
            valid_from 
            periodicity
            name
            url
          }
        }
      }
    }', .open = "<<", .close = ">>")
  
    return(query)
  
}

# query_builder(parties = "CDU")


get_results <- function(parties = c("SPD", "AFD", "DIELINKE")) {
  result <- httr::POST(
    url = "https://api-next.datengui.de/graphql",
    body = list(query = query_builder(year = 2017,
                                      parties = parties)),
    encode = "json",
    httr::add_headers(.headers = c("Content-Type"="application/json"))
  )
  
  
  ## Stop if Error
  httr::stop_for_status(result)
  
  httr::content(result, as = 'text', encoding = "UTF-8") %>% 
    jsonlite::fromJSON()  
}


# get_results() %>% 
#   purrr::flatten()%>% 
#   purrr::flatten()%>% 
#   purrr::flatten() %>% as_tibble()
 
  

# query_builder(year = 2017,
              # parties = c("SPD", "AFD", "DIELINKE"))
