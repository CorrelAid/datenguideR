test_that("calling number of pigs works nuts 1", {
  
  dg_call(year = c(2001, 2003, 2007), 
          stat_name = 'BETR08', 
          substat_name = 'TIERA8', 
          nuts_nr = 1) 
  
  
})

test_that("calling number of pigs works nuts 2", {
  
  dg_call(year = c(2001, 2003, 2007), 
          stat_name = 'BETR08', 
          substat_name = 'TIERA8', 
          nuts_nr = 2) 
  
  
})

test_that("calling number of pigs works nuts 3", {
  
  dg_call(year = c(2001, 2003, 2007),
          stat_name = 'BETR08',
          substat_name = 'TIERA8',
          nuts_nr = 3, 
          parent_chr = 1)
  
  
})


test_that("Nichtwohngebäude works", {
  
  dg_call(nuts_nr = 1, 
          stat_name =  "BAU018", 
          substat_name = "BAUAHZ")
  
  
})
