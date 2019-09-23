library(tidyverse)

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

query_builder <- function(field, substat_name){
  
  if(field$name == substat_name){ # stop recursive function on substat-level
    glue::glue('year, <<substat_name>> : value', .open = "<<", .close = ">>") 
  } else {
    
    # check for field arguments
    if (length(field$arguments) > 1) {
      a <- lapply(field[['arguments']], paste_nv) %>%
        unlist(.) %>%
        paste0(., collapse = ', ')
      if (!(a == '')) {
        a <- glue::glue('( <<a>> )', .open = "<<", .close = ">>")
      } else {
        a <- ''
      }
    }
    if (length(field$arguments) == 1) {
      a <- field[['arguments']][[1]] %>%
        paste_nv(.) 
      if (!(a == '')) {
        a <- glue::glue('( <<a>> )', .open = "<<", .close = ">>")
      } else {
        a <- ''
      }
    } 
    if (length(field$arguments) == 0) {
      a <- ''
    }
    
    # check for subfields
    if (length(field$subfield) == 0) {
      query <- glue::glue('<<field$name>> <<a>> { }', .open = "<<", .close = ">>")
    } else {
      subfield <- field$subfield
      query <- glue::glue('<<field$name>> <<a>> {<<insert_regname(field)>> <<insert_pagenr(field)>>
                          <<glue::glue("<<purrr::map_chr(subfield, query_builder, substat_name = substat_name)>>",
                          .open = "<<", .close = ">>")>>}',
                          .open = "<<", .close = ">>")
  }
    
}
  
  }

#*******************

query_builderfin <- function(field, substat_name) {
  query <- query_builder(field = field, substat_name = substat_name)
  query_fin <- glue::glue('query <<query>>', .open = "<<", .close = ">>") # add 'query' at the beginning
}
#*******************

# region_id <- '11'
# stat_name <- 'BAU001'
# substat_name <- 'BAUNW2'
# parameter <- 'BAUNW101'
# year <- 2002

pagenr <- NULL
ipp <- 50
nutsnr <- 1
launr <- NULL
parentchr <- NULL
stat_name <- 'BETR08'
substat_name <- 'TIERA8'
parameter <- 'TIERART3'
year <- 2007


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
# 
# id <-list('name' = 'id',
#           'value' = region_id,
#           'arguments' = list(),
#           'subfield'= list(),
#           'type' = 'String')


# region <- list('name' = 'region',
#                'value' = list(),
#                'arguments' = list(id),
#                'subfield' = list(stat),
#                'type' = 'Region')
# 
# query_region <- list('name' = 'region',
#                      'value' = list(),
#                      'arguments' = list(),
#                      'subfield' = list(region),
#                      'type' = 'query') # not sure if this is an official type of the API, but I used it to avoid conflicts with list region


####################


page <- list('name' = 'page',
             'value' = pagenr, # if not given graphql default is 0
             'arguments' = list(),
             'subfield' = list(),
             'type' = 'Int')

itemsPerPage <- list('name' = 'itemsPerPage',
             'value' = ipp, # if not given graphql default is 10
             'arguments' = list(),
             'subfield' = list(),
             'type' = 'Int')

nuts <- list('name' = 'nuts',
             'value' = nutsnr,
             'arguments' = list(),
             'subfield' = list(),
             'type' = 'Int')

lau <- list('name' = 'lau',
             'value' = launr,
             'arguments' = list(),
             'subfield' = list(),
             'type' = 'Int')

parent <- list('name' = 'parent',
                'value' = parentchr,
                'arguments' = list(),
                'subfield' = list(),
                'type' = 'String')


regions <- list('name' = 'regions',
                'value' = list(),
                'arguments' = list(nuts, lau, parent), # make sure that name only appears if value is not NUll
                'subfield' = list(stat),
                'type' = 'Region')

allRegions <- list('name' = 'allRegions',
                   'value' = list(),
                   'arguments' = list(page, itemsPerPage), 
                   'subfield' = list(regions),
                   'type' = 'RegionsResult')

query_allRegions <- list('name' = 'allRegions',
                         'value' = list(),
                         'arguments' = list(),
                         'subfield' = list(allRegions),
                         'type' = 'query')

queryall <- query_builderfin(field = query_allRegions, substat_name = "TIERA8")
queryall
