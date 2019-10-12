#### This code gets all descriptions on statistics and sub-statistics ####

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

# *Functional* way to get (sub)stat_name and (sub)stat_description...
## TODO: Add information on parameters!
dg_meta <- get_meta() %>%
  select(name, description, args) %>%
  mutate(description = str_extract(description, '\\*\\*([^*]*)\\*\\*') %>% 
           str_remove_all("\\*")) %>%
  tail(-2) %>%
  rename_all(recode, name = "stat_name", description = "stat_description") %>%
  unnest(args) %>%
  filter(name != "year", name != "statistics", name != "filter") %>%
  mutate(substat_description = dg_meta$type$ofType$description) %>%
  rename(substat_name = "name") %>%
  select(-type)


#usethis::use_data(dg_meta, overwrite = T)
