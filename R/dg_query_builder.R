#' dg_query_builder.R
#'
#' Builds the query with a recursive function iterating over fields.
#' 
#' @param field description
#' @param stat_name description
#' @param substat_name description
#'
#' @return Query
#'
#' @examples
#' dg_query_builder <- function(field, substat_name)
#'
#' @export

# Recursive query builder -----------------------------------------------------

query_builder <- function(field, stat_name, substat_name) {
  
  if (is.null(substat_name)) {
    substat_name <- "not given"
  }

    if (field$name == substat_name) { # stop recursive function on substat-level
    glue::glue("year, <<substat_name>> : value source { title_de name }", .open = "<<", .close = ">>")
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
      field_name <- field$name
      reg_name <- insert_regname(field)
      page_nr <- insert_page_nr(field)
      recursive_part <- purrr::map_chr(subfield, query_builder, substat_name = substat_name)

      query <- glue::glue("<<field_name>> <<a>> {<<reg_name>> <<page_nr>>
                          <<recursive_part>>}",
        .open = "<<", .close = ">>"
      )
    }
  }
}

# Final query builder -----------------------------------------------------

dg_query_builder <- function(field, stat_name, substat_name) {
  q <- query_builder(field = field, stat_name = stat_name, substat_name = substat_name)
  
  ##TODO: This is a hacky solution when substat_name is not given
  if (is.null(substat_name)) {
    
    q <- q %>%
      stringr::str_replace("\\{ \\}",
                           glue::glue("{year, <<stat_name>> : value, source { title_de name }}", .open = "<<", .close = ">>"))
  }
  
  query <- glue::glue("query <<q>>", .open = "<<", .close = ">>") # add 'query' at the beginning
}
