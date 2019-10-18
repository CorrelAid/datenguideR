#' dg_meta.R
#'
#' Gets all available meta data on statistics, sub-statistics, and parameters
#'
#' @return Data frame containing all available meta data
#'
#' @examples
#' dg_meta <- get_meta()
#' dg_meta
#'
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
    httr::add_headers(.headers = c("Content-Type" = "application/json"))
  )

  result_dat <- httr::content(meta_results, as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON()

  final <- result_dat[["data"]][["__type"]][["fields"]] %>% tibble::as_tibble()

  return(final)
}

## TODO (optional): Restructure data in dg_meta?
dg_meta <- get_meta() %>%
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


usethis::use_data(dg_meta, overwrite = T)
