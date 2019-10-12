#### This code imports information on all regions ####

## Option to filter by variable (e.g. level or "level") and value (e.g. "lau").

get_region = function(var = NULL, val = NULL) {
  
  if (missing(var) | missing(val)) { 
    df <- read_csv("data/regions.csv")
    
  } else { 
    
    var <- rlang::parse_expr(quo_name(enquo(var)))
    
    df <- read_csv("data/regions.csv") %>% 
      filter(!!var == val)  
  }
  
  return(df)
}


dg_regions <- get_region()


usethis::use_data(dg_regions, overwrite = T)