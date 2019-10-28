#' dg_query_builder.R
#'
#' Builds a query in GraphQL syntax through a recursive function that iterates over 
#' the fields defined in define_fields(). It checks for possible arguments and
#' subfields and pastes names and values, respectively.
#' 
#' @param field Field of "highest order" where the recursive function starts. Usually query_list, defined in
#' define fields.
#'
#' @return Query for the GraphQL API
#'
#' @examples
#' dg_query_builder <- function(field, lastfield_name)
#'
#' @export

# Recursive query builder -----------------------------------------------------

query_builder <- function(field, substat_name) { 
    
    if(is.null(substat_name)){
      substat_name <- 'not given'
    }

    if (field$name == substat_name) { # stop recursive function on substat-level and paste variables that should be returned
    glue::glue("year, <<substat_name>> : value, source { title_de name }", .open = "<<", .close = ">>")
    } else {

    # check if field has arguments
    if (length(field$arguments) > 1) {
      a <- lapply(field[["arguments"]], paste_nv) %>% # paste names and values of arguments
        unlist(.) %>%
        paste0(., collapse = ", ")
      #if (!(a == "")) {
      if (!is.null(a)) {
       a <- glue::glue("( <<a>> )", .open = "<<", .close = ">>")
      } else {
        a <- ""
      }
    }
    if (length(field$arguments) == 1) {
      a <- field[["arguments"]][[1]] %>%
        paste_nv(.)
      #if (!(a == "")) {
      if (!is.null(a)) { 
       a <- glue::glue("( <<a>> )", .open = "<<", .close = ">>")
      } else {
        a <- ""
      }
    }
    if (length(field$arguments) == 0) { # include case of no arguments given to avoid that empty brackets are pasted into query
      a <- ""
    }

    # check if field has subfields
    if (is.null(field$subfield)) {
      query <- glue::glue("<<field$name>> <<a>> { year, <<field$name>> : value, source { title_de name } }", .open = "<<", .close = ">>")
    } else {
      subfield <- field$subfield
      field_name <- field$name
      reg_name <- insert_regname(field)
      page_nr <- insert_page_nr(field)
      recursive_part <- purrr::map_chr(subfield, query_builder, substat_name = substat_name) # use subfield as anew input for query_builder 

      # paste default return variables for different field types 
      query <- glue::glue("<<field_name>> <<a>> {<<reg_name>> <<page_nr>> 
                          <<recursive_part>>}", # query_builder is called again for the subfield
        .open = "<<", .close = ">>"
      )
    }
  }
}

# Final query builder -----------------------------------------------------

dg_query_builder <- function(field, substat_name, stat_name) { 
  q <- query_builder(field = field, substat_name = substat_name) 
  query <- glue::glue("query <<q>>", .open = "<<", .close = ">>") %>%  # add 'query' at the beginning
    stringr::str_sub(., 1, stringr::str_length(.)-1) # delete last curly bracket
  # insert metadata call (is this all metadata we want?)
  qu <- glue::glue('<<query>>,
                    __type (name: "<<stat_name>>") { kind, name, description
                    fields { name, description } } }', 
                    .open = "<<", .close = ">>")
}
