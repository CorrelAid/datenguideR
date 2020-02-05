#' paste_nv()
#'
#' Pastes name(s) and value(s) of fields, used for field arguments in query_builder.
#'
#' @param field The field whos name and value should be pasted into the query

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

#' insert_regname()
#'
#' If given field is of type Region 'id, name,' is inserted in query to
#' ensure that region id and name are always returned.
#'
#' @param field Field to be checked if of type Region.

insert_regname <- function(field) {
  if (field$type == "Region") {
    b <- glue::glue("id, name,", .sep = " ", .open = "<<", .close = ">>")
  } else {
    b <- ""
  }
  return(b)
}

#' insert_page_nr()
#'
#' Insert 'page, total, itemsPerPage,' after allRegions to to
#' ensure that those variables are always returned for allRegions queries.
#'
#' @param field Field to be checked if of type RegionsResult (allRegions specific type)

insert_page_nr <- function(field) {
  if (field$type == "RegionsResult") {
    b <- glue::glue("page, total, itemsPerPage,", .sep = " ", .open = "<<", .close = ">>")
  } else {
    b <- ""
  }
  return(b)
}
