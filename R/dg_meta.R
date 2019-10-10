#### This code gets all meta data ####

#' @export
get_meta <- function() {
  meta_query <-
    '{ __type(name: "Region") {
  kind
  enumValues {
    name
    description
  }
  fields {
    name
    type {
      ofType {
        name
      }
      kind
      name
      description
    }
    description
    args {
      name
      type {
        kind
        name
        ofType {
          name
          description
          kind
        }
      }
    }
  }
}
}'
  
  meta_results <- httr::POST(
    url = "https://api-next.datengui.de/graphql",
    body = list(query = meta_query),
    encode = "json",
    httr::add_headers(.headers = c("Content-Type"="application/json")))
  
  result_dat <- httr::content(meta_results, as = 'text', encoding = "UTF-8") %>%
    jsonlite::fromJSON()
  
  final <- result_dat[["data"]][["__type"]][["fields"]] %>% as_tibble()
  
  return(final)
  
}

# TOOD: Extract and format args!
dg_meta <- get_meta() %>%
  select(name, description, args) %>%
  mutate(description = str_extract(description, '\\*\\*([^*]*)\\*\\*') %>% 
           str_remove_all("\\*")) %>%
  tail(-2)


#usethis::use_data(dg_meta, overwrite = T)
