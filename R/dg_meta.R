#### This code gets all meta data on statistics, sub-statistics, and parameters ####

#' @export
get_meta <- function() {
  meta_query <-
    '{ __type(name: "Region") {
  fields {
    name
    description
    args {
      name
      type {
        name
        ofType {
          name
          description
          enumValues {
            name
            description
          }
        }
      }
    }
  }
}}'
  
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

# Functional way to get (sub)stat_name,(sub)stat_description, and parameters
## TODO: If no substat is available for stat, parameter should be empty (currently it displays data source)!
dg_meta <- get_meta() %>%
  select(name, description, args) %>%
  mutate(stat_description_full = description %>% 
           str_trim()) %>%
  mutate(description = str_extract(description, '\\*\\*([^*]*)\\*\\*') %>% 
           str_remove_all("\\*")) %>%
  tail(-2) %>%
  rename_all(recode, name = "stat_name", description = "stat_description") %>%
  unnest(args) %>%
  filter(name != "year", name != "filter") %>%
  mutate(substat_description = type$ofType$description) %>%
  rename(substat_name = "name") %>%
  mutate(substat_name = str_replace(substat_name, "statistics", "")) %>%
  mutate_at(.vars = c("substat_name", "substat_description"),
            .funs = list(~ ifelse(. == "", NA, as.character(.)))) %>%
  mutate(parameter = type$ofType$enumValues) %>%
  select(stat_name, stat_description, stat_description_full, substat_name, substat_description, parameter)


usethis::use_data(dg_meta, overwrite = T)
