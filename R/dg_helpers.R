#### This code contains helper functions ####

library(tidyverse)

#*******************

vector_collapse <- function(vector) {
  vector %>% 
    paste0(collapse = ", ") %>% 
    paste0("[", ., "]")
}

#*******************

is_not_null <- function(x) !is.null(x)

#*******************

paste_nv <- function(field){
  if(!is.null(field$value)){
    if(field$type == 'String'){
      value <- glue::glue('"<<field$value>>"', .sep = ' ', .open = "<<", .close = ">>") # backslashes rausnehmen?!
      nv <- glue::glue('<<field[["name"]]>> : <<value>>', .sep = ' ', .open = "<<", .close = ">>")
    } else {
      nv <- glue::glue('<<field[["name"]]>> : <<field[["value"]]>>', .sep = ' ', .open = "<<", .close = ">>")
    }
  } else {
    nv <- NULL
  }
  return(nv)
}

#*******************

# insert 'id, name,' after region to ensure that region id and name are always returned
insert_regname <- function(field){
  if(field$type == 'Region'){
    b <- glue::glue('id, name,', .sep = ' ', .open = "<<", .close = ">>")
  } else {
    b <- ''
  }
  return(b)
}

#*******************

# insert 'page, total, itemsPerPage,' after allRegions by default
insert_pagenr <- function(field){
  if(field$type == 'RegionsResult'){
    b <- glue::glue('page, total, itemsPerPage,', .sep = ' ', .open = "<<", .close = ">>")
  } else {
    b <- ''
  }
  return(b)
}
#*******************

clean_it <- function(results) {
  tidy_dat <- results %>%
    purrr::flatten() %>%
    purrr::flatten() %>%
    purrr::flatten() %>% 
    tibble::as_tibble() 
  return(tidy_dat)
}