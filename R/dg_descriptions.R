#' dg_descriptions.R
#'
#' Gets information on all statistics and their descriptions.
#'
#' @return Data frame containing information on all statistics
#'
#' @examples
#' dg_descriptions <- get_description()
#' dg_descriptions
#'
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
    httr::add_headers(.headers = c("Content-Type" = "application/json"))
  )

  result_dat <- httr::content(desc_results, as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON()

  final <- result_dat[["data"]][["__type"]][["fields"]] %>% tibble::as_tibble()

  return(final)
}

dg_descriptions <- get_description() %>%
  dplyr::mutate(description = stringr::str_extract(description, '\\*\\*([^*]*)\\*\\*') %>%
    stringr::str_remove_all("\\*")) %>%
  dplyr::rename_all(dplyr::recode, name = "stat_name") %>%
  utils::tail(-2)

usethis::use_data(dg_descriptions, overwrite = T)
