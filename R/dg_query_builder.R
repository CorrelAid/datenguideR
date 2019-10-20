#' dg_query_builder.R
#'
#' Builds a query in GraphQL Syntax via a recursive function that iterates over 
#' the fields defined in define_fields(). It checks for possible arguments and
#' subfields and pastes names and values respectively.
#' 
#' @param field Field of "highest order" where recursive function starts. Usually query_list, defined in
#' define fields.
#' @param stat_name Name of Statistic (used currently to deal with case of not given substatistic)
#' @param substat_name Name of Substatistic (used currently to deal with case of not given substatistic)
#'
#' @return Query
#'
#' @examples
#' dg_query_builder <- function(field, substat_name)
#'
#' @export

# Recursive query builder -----------------------------------------------------

query_builder <- function(field, stat_name, substat_name) {
  
  # check if a substatistic is given
  if (is.null(substat_name)) {
    substat_name <- "not given"
  }

    if (field$name == substat_name) { # stop recursive function on substat-level and paste variables that should be returned
    glue::glue("year, <<substat_name>> : value, source { title_de name }", .open = "<<", .close = ">>")
  } else {

    # check if field has arguments
    if (length(field$arguments) > 1) {
      a <- lapply(field[["arguments"]], paste_nv) %>% # paste names and values of arguments
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
    if (length(field$arguments) == 0) { # include case of no arguments given to avoid that empty brackets are pasted into query
      a <- ""
    }

    # check if field has subfields
    if (length(field$subfield) == 0) {
      query <- glue::glue("<<field$name>> <<a>> { }", .open = "<<", .close = ">>")
    } else {
      subfield <- field$subfield
      field_name <- field$name
      reg_name <- insert_regname(field)
      page_nr <- insert_page_nr(field)
      recursive_part <- purrr::map_chr(subfield, query_builder, substat_name = substat_name) # use subfield as anew input for query_builder 

      query <- glue::glue("<<field_name>> <<a>> {<<reg_name>> <<page_nr>> # paste default return variables for different field types 
                          <<recursive_part>>}", # query_builder is called again for the subfield
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
