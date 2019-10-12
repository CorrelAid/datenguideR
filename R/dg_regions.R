#### This code imports information on all regions ####

get_regions <- function() {
  df <- read_csv("data/regions.csv")
  return(df)
}


dg_regions <- get_regions()


usethis::use_data(dg_regions, overwrite = T)