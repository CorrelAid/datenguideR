#' dg_helpers.R
#'
#' Contains various helper functions.
#'
#' @export

vector_collapse <- function(vector) {
  vector %>%
    paste0(collapse = ", ") %>%
    paste0("[", ., "]")
}

## -----##

paste_nv <- function(field) {
  if (!is.null(field$value)) {
    if (field$type == "String") {
      value <- glue::glue('"<<field$value>>"', .sep = " ", .open = "<<", .close = ">>")
      nv <- glue::glue('<<field[["name"]]>> : <<value>>', .sep = " ", .open = "<<", .close = ">>")
    } else {
      nv <- glue::glue('<<field[["name"]]>> : <<field[["value"]]>>', .sep = " ", .open = "<<", .close = ">>")
    }
  } else {
    nv <- NULL
  }
  return(nv)
}

## -----##

# insert 'id, name,' after region to ensure that region id and name are always returned
insert_regname <- function(field) {
  if (field$type == "Region") {
    b <- glue::glue("id, name,", .sep = " ", .open = "<<", .close = ">>")
  } else {
    b <- ""
  }
  return(b)
}

## -----##

# insert 'page, total, itemsPerPage,' after allRegions by default
insert_pagenr <- function(field) {
  if (field$type == "RegionsResult") {
    b <- glue::glue("page, total, itemsPerPage,", .sep = " ", .open = "<<", .close = ">>")
  } else {
    b <- ""
  }
  return(b)
}

## -----##

clean_it <- function(.data) {
  raw <- .data %>%
    purrr::flatten() %>%
    purrr::flatten() %>%
    purrr::flatten() %>%
    tibble::as_tibble()
  
  tidy_dat <- raw %>% 
    purrr::discard(is.list) %>%
    ##TODO: Rename name in source sub dataset because there is already a "name" variable in main
    ##NOTE Lisa: Those two vars should not be overall source, but rather source for e.g. different params in TIERA8!
    dplyr::bind_cols(raw$source) %>%
    dplyr::rename(GENESIS_stat_name = "title_de", GENESIS_stat_nr = "name1")
    
  return(tidy_dat)
}
