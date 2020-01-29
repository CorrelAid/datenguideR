##' join_en_translation
##'
##' This function joins a list of English translations to the dg_descriptions dataset.
##'
##' @param dg_descriptions data set which includes all meta data
##' @param en_list list that includes all English translations
##' @return Data frame containing all available meta data *with* English translation
##'
##' @examples
##' dg_descriptions <- join_en_translation(datenguideR::dg_descriptions, en_list)
##' dg_descriptions
##'
##' @export
join_en_translation <- function(dg_descriptions, en_list) {
  start_dat <- dg_descriptions
  
  for (jj in seq_along(en_list)) {
    start_dat <- start_dat %>% 
      dplyr::left_join(en_list[[jj]])
  }
  
  start_dat <- start_dat %>% dplyr::mutate_all(~ifelse(.x == "N / a", NA, .x))
  
  return(start_dat)
}



##' dg_descriptions.R
##'
##' Gets all available meta data on statistics, sub-statistics, and parameters.
##'
##' @return Data frame containing all available meta data
##'
##' @examples
##' dg_descriptions <- get_descriptions()
##' dg_descriptions
##'
##' @export

get_descriptions <- function() {
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
    httr::add_headers(.headers = c("Content-Type" = "application/json"))
  )

  result_dat <- httr::content(meta_results, as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON()

  final <- result_dat[["data"]][["__type"]][["fields"]] %>% tibble::as_tibble()

  return(final)
}

dg_descriptions <- get_descriptions() %>%
  dplyr::select(name, description, args) %>%
  dplyr::mutate(stat_description_full = description %>%
    stringr::str_trim()) %>%
  dplyr::mutate(description = stringr::str_extract(description, '(?<=\\*\\*)[^*]*(?=\\*\\*)')) %>%
  utils::tail(-2) %>%
  dplyr::rename_all(dplyr::recode, name = "stat_name", description = "stat_description") %>%
  tidyr::unnest(args) %>%
  dplyr::filter(name != "year", name != "filter") %>%
  dplyr::mutate(substat_description = type$ofType$description) %>%
  dplyr::rename(substat_name = "name") %>%
  dplyr::mutate(substat_name = stringr::str_replace(substat_name, "statistics", "")) %>%
  dplyr::mutate_at(
    .vars = c("substat_name", "substat_description"),
    .funs = list(~ ifelse(. == "", NA, as.character(.)))
  ) %>%
  dplyr::mutate(parameter = type$ofType$enumValues) %>%
  dplyr::select(stat_name, stat_description, stat_description_full, substat_name, substat_description, parameter) %>%
  tidyr::unnest(parameter) %>%
  dplyr::rename(param_name = "name", param_description = "description") %>%
  dplyr::mutate_at(
    .vars = c("param_name", "param_description"),
    .funs = list(~ ifelse(substat_name == "", NA, as.character(.)))
  )

# load("r/sysdata.rda")



# dg_descriptions <- join_en_translation(dg_descriptions, en_list)

# load("r/sysdata.rda")
# usethis::use_data(en_list, overwrite = TRUE, internal = T)



usethis::use_data(dg_descriptions, overwrite = TRUE)