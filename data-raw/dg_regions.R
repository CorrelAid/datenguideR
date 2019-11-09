dg_regions <- readr::read_csv("data-raw/regions.csv", col_types = "cccc") 

dg_regions <- dplyr::arrange(dg_regions, id)

usethis::use_data(dg_regions, overwrite = TRUE)
