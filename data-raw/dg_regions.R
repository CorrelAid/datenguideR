library(dplyr)
x <- 
  jsonlite::read_json("https://data.genesapi.org/regionalstatistik/names.json")
dg_regions <- 
  dplyr::tibble(id = names(x), name = as.character(x)) %>% 
  dplyr::mutate(
    level = 
      dplyr::case_when(
        id == "DG" ~ "nuts0",
        nchar(id) == 2 ~ "nuts1",
        nchar(id) == 3 ~ "nuts2",
        nchar(id) == 5 ~ "nuts3",
        nchar(id) == 8 ~ "lau"),
    parent =
      dplyr::case_when(
        nchar(id) == 2 ~ "DG",
        nchar(id) == 3 ~ substr(id, 1, 2),
        nchar(id) == 5 ~ substr(id, 1, 3),
        nchar(id) == 8 ~ substr(id, 1, 5)
      )
  ) %>% 
  dplyr::arrange(id)

usethis::use_data(dg_regions, overwrite = TRUE)
