#### This code gets all variable descriptions ####

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


dg_descriptions <- get_description() %>% 
  mutate(description = str_extract(description, '\\*\\*([^*]*)\\*\\*') %>% 
           str_remove_all("\\*")) %>%
  tail(-2)

usethis::use_data(dg_descriptions, overwrite = T)
