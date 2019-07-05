# 
# 
# 
# curl 'https://api-next.datengui.de/graphql' -H 'Accept-Encoding: gzip, deflate, br' -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'Connection: keep-alive' -H 'DNT: 1' -H 'Origin: https://api-next.datengui.de' --data-binary '{"query":"# Write your query or mutation here\n{\n region(id: \"11\") {\n id\n name\n WAHL09(year: 2017, PART04: CDU) {\n year\n value\n PART04\n }\n }\n}"}' --compressed
# 
# 
# httr::POST()
# 
# 
# result <- httr::POST("https://api-next.datengui.de/graphql",
#                      body = query,
#                      httr::add_headers(.headers = c("Content-Type"="application/json")))
# 
# httr::content(result, "text") 
# 
# httr::content_type(result)
# 
# "id" %>%
#   purrr::map(
#     ~{list(x = NULL) %>% purrr::set_names(.x)}
#   ) %>%
#   purrr::flatten() %>% jsonlite::toJSON()
# 
# 
# 
# devtools::install_github("ropensci/graphql")
# 
# query <- "{
#   region(id: '11') {
#     id
#     name
#     WAHL09(year: 2017, PART04: CDU) {
#       year
#       value
#       PART04
#     }
#   }
# }" %>% jsonlite::toJSON(auto_unbox = T)
# 
# 
# 
# query <- "{ region(id: '11') { id name WAHL09(year: 2017, PART04: CDU) { year value PART04 } } }" %>% jsonlite::toJSON(auto_unbox = T)
# 
# list(list(region = c(id = 11))) %>%  jsonlite::toJSON()
# 
# 
# 
# ss <- graphql::graphql2json('{ region(id: "11") { id name WAHL09(year: 2017, PART04: CDU) { year value PART04 } } }', parse_schema = T)
# 
# graphql::graphql2json("schema { query: QueryType }", TRUE)
# 
# graphql::graphql2json("{ field(complex: { a: { b: [ $var ] } }) }")
# 
# 
# gqlr::gqlr_schema('{ region(id: "11") { id name WAHL09(year: 2017, PART04: CDU) { year value PART04 } } }')
# 
# 
# 
# library(gqlr)
# 
# schema <- "
#   type Hello {
#     world: String
#   }
#   schema {
#     query: Hello
#   }
# " %>%
#   gqlr_schema()
# 
# execute_request("{world}", schema, initial_value = list(world = "Hi!"))
# 
# 
# 
# 
# schema <- "
#   type region {
#     id: String
#   }
#   schema {
#     query: Hello
#   }
# " %>%
#   gqlr_schema()
# 
# execute_request("{world}", schema, initial_value = list(world = "Hi!"))
# 
# library(graphql)
# 
# graphql2json("schema { query: QueryType }", parse_schema = F)
# 
# 
# library(ghql)
# 
# devtools::install_github("ropensci/ghql")
# 
# 
# query <- '{
#   region(id: "11") {
#     id
#     name
#     WAHL09(year: 2017, PART04: CDU) {
#       year
#       value
#       PART04
#     }
#   }
# }'
# 
# 
# # get_compendia <- function(){
#   my_query <- '{
#     compendia {
#   	  name
#       fullName
#       description
#       normalization
# 	  }
#   }'
#   parze(cont(do_POST("https://api-next.datengui.de/graphql", query)))
# # }
# 
# list(query = query) %>% jsonlite::toJSON(auto_unbox = T)
# 
# 
# do_POST <- function(url, query, ...){
#   temp <- httr::POST(
#     url,
#     body = list(query = query) ,
#     encode = "json",
#     httr::add_headers(.headers = c("Content-Type"="application/json")),
#     ...)
#   # httr::stop_for_status(temp)
#   temp
# }
# 
# cont <- function(x) httr::content(x, as = 'text', encoding = "UTF-8")
# 
# parze <- function(x) jsonlite::fromJSON(x)
# 
