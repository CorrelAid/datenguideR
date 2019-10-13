#' dg_querybuilder.R
#'
#' Builds the query with a recursive function iterating over fields
#' 
#' @param field description
#' @param substat_name description
#'
#' @return Query builder
#'
#' @examples
#' query_builder <- function(field, substat_name)
#'
#' @export

query_builder_pre <- function(field, substat_name) {
  if (field$name == substat_name) { # stop recursive function on substat-level
    glue::glue("year, <<substat_name>> : value", .open = "<<", .close = ">>")
  } else {

    # check for field arguments
    if (length(field$arguments) > 1) {
      a <- lapply(field[["arguments"]], paste_nv) %>%
        unlist(.) %>%
        paste0(., collapse = ", ")
      if (!(a == "")) {
        a <- glue::glue("( <<a>> )", .open = "<<", .close = ">>")
      } else {
        a <- ""
      }
    }
    if (length(field$arguments) == 1) {
      a <- field[["arguments"]][[1]] %>%
        paste_nv(.)
      if (!(a == "")) {
        a <- glue::glue("( <<a>> )", .open = "<<", .close = ">>")
      } else {
        a <- ""
      }
    }
    if (length(field$arguments) == 0) {
      a <- ""
    }

    # check for subfields
    if (length(field$subfield) == 0) {
      query <- glue::glue("<<field$name>> <<a>> { }", .open = "<<", .close = ">>")
    } else {
      subfield <- field$subfield
      query <- glue::glue('<<field$name>> <<a>> {<<insert_regname(field)>> <<insert_pagenr(field)>>
                          <<glue::glue("<<purrr::map_chr(subfield, query_builder_pre, substat_name = substat_name)>>",
                          .open = "<<", .close = ">>")>>}',
        .open = "<<", .close = ">>"
      )
    }
  }
}

#*******************

query_builder <- function(field, substat_name) {
  q <- query_builder_pre(field = field, substat_name = substat_name)
  query <- glue::glue("query <<q>>", .open = "<<", .close = ">>") # add 'query' at the beginning
}