#### This code gets (almost) all meta data ####

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
        ofType {
          description
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

# *Functional* way to get substat_name and description...
## TODO: substat description is still in a weird format -> fix and rename!
dg_meta <- get_meta() %>%
  select(name, description, args) %>%
  mutate(description = str_extract(description, '\\*\\*([^*]*)\\*\\*') %>% 
           str_remove_all("\\*")) %>%
  tail(-2) %>%
  rename_all(recode, name = "stat_name") %>%
  mutate(args_full = map(args, ~ data.frame((.)))) %>%
  unnest(args_full) %>%
  select(-args) %>%
  filter(name != "year", name != "statistics", name != "filter") %>%
  rename(substat_name = "name")
  

#usethis::use_data(dg_meta, overwrite = T)
