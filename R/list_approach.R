library(tidyverse)

#*******************

query_builder <- function(field, substat_name){
  
  if(field$name == substat_name){ # stop recursive function on substat-level
    glue::glue('year, <<substat_name>>', .open = "<<", .close = ">>") # preliminary
  } else {
  
  # check for field arguments
  if (length(field$arguments) > 1) {
    a <- lapply(field[['arguments']], paste_nv) %>%
      unlist(.) %>%
      paste0(., collapse = ', ')
    a <- glue::glue('( <<a>> )', .open = "<<", .close = ">>")
  }
  if (length(field$arguments) == 1) {
    a <- field[['arguments']][[1]] %>%
        paste_nv(.) %>% 
        paste0(., collapse = ', ') 
    a <- glue::glue('( <<a>> )', .open = "<<", .close = ">>")
  } 
  if (length(field$arguments) == 0) {
      a <- NULL
    }
  
  # check for subfields
  if (length(field$subfield) == 0) {
    query <- glue::glue('<<field$name>> <<a>> { }', .open = "<<", .close = ">>")
  } else {
    subfield <- field$subfield
    glue::glue('<<field$name>>
          <<a>>
          {
          <<glue::glue("<<purrr::map_chr(subfield, query_builder, substat_name = substat_name)>>", .open = "<<", .close = ">>")>>
          }', .open = "<<", .close = ">>")
  }

 }
}

#*******************

paste_nv <- function(field){
  if(field$type == 'String'){
    value <- glue::glue('"<<field$value>>"', .sep = ' ', .open = "<<", .close = ">>")
    glue::glue('<<field[["name"]]>> : <<value>>', .sep = ' ', .open = "<<", .close = ">>")
  } else {
    glue::glue('<<field[["name"]]>> : <<field[["value"]]>>', .sep = ' ', .open = "<<", .close = ">>")
  }
}




# erstmal ohne allRegions

region_id <- '11'
stat_name <- 'BAU001'
substat_name <- 'BAUNW2'
parameter <- 'BAUNW101'
year <- 2002

substat <- list('name' = substat_name,
                'value' = parameter,
                'arguments' = list(),
                'subfield'= list(),
                'type' = substat_name)

year <- list('name' = 'year',
             'value' = year,
             'arguments' = list(),
             'subfield'= list(),
             'type' = 'Int')

stat <- list('name' = stat_name, 
             'value' = list(),
             'arguments' = list(year, substat),
             'subfield'= list(substat),
             'type' = stat_name)

id <-list('name' = 'id',
          'value' = region_id,
          'arguments' = list(),
          'subfield'= list(),
          'type' = 'String')


region <- list('name' = 'region',
               'value' = list(),
               'arguments' = list(id),
               'subfield' = list(stat),
               'type' = 'Region')



query <- query_builder(field = region, substat_name = 'BAUNW2')
# region id not quoted....

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


