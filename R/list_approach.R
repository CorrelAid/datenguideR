library(tidyverse)

#*******************
# funktioniert noch nicht in der schleife, wenn sozusagen subfield wieder als 
# Parameter für query_builder übergeben wird, das ist dann type 'closure'...
# Es stimmen auch noch nicht alle eckigen Klammern
# Muss jetzt aber Abendessen ;-)

query_builder <- function(field) {
  # check for field arguments
  if (length(field$arguments) > 1) {
    a <- lapply(field[['arguments']], paste_nv) %>%
      unlist(.) %>%
      paste0(., collapse = ', ') %>%
      paste0('(', ., ')', collapse = ' ')
  } else {
    if (length(field$arguments) == 1) {
      a <- paste_nv(field[['arguments']]) %>%
        paste0(., collapse = ', ') %>%
        paste0('(', ., ')', collapse = ' ')
    } else {
      a <- NULL
    }
  }
  
  
  # check for subfields
  if (length(field$subfield) == 0) {
    query <- paste0(field$name, a, '{ }', collapse = ' ')
  } else {
    paste0(field$name,
          a,
          '{',
          paste0(purrr::map_chr(field$subfield, query_builder), collapse = ' '),
          '}')
  }

}


#*******************

paste_nv <- function(field){
  paste(field[['name']], ':',
        field[['value']])
}




# erstmal ohne allRegions

region_id <- '11'
stat_name <- 'BAU001'
substat_name <- 'BAUNW2'
parameter <- 'BAUNW101'
year <- 2002

region <- list('name' = 'region',
               'value' = list(),
               'arguments' = list(id),
               'subfield' = list(stat))

id <-list('name' = 'id',
          'value' = region_id,
          'arguments' = list(),
          'subfield'= list())

stat <- list('name' = stat_name, 
             'value' = list(),
             'arguments' = list(year, substat),
             'subfield'= list(substat))


year <- list('name' = 'year',
             'value' = year,
             'arguments' = list(),
             'subfield'= list())

substat <- list('name' = substat_name,
                'value' = parameter,
                'arguments' = list(),
                'subfield'= list())

query <- query_builder(region)
stat_query <- query_builder(substat)


####################




allRegions <- list('name' = 'allRegions',
                   'arguments' = list(page, itemsPerPage),
                   'subfield' = list(regions))

regions <- list('name' = 'regions',
                'nuts' = ,
                'lau' = ,
                'parent' = ,
                'subfield' = )

#######################################################################


