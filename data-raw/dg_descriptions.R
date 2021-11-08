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

usethis::use_data(dg_descriptions, overwrite = TRUE)
