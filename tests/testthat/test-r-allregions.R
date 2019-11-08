test_that("calling number of pigs works nuts 1", {
  
  result <- dg_call(year = c(2001, 2003, 2007), 
          stat_name = 'BETR08', 
          substat_name = 'TIERA8', 
          nuts_nr = 1) 
  
  expect_equal(nrow(result), 383)
  
  
})

test_that("calling number of pigs works nuts 2", {
  
  result <- dg_call(year = c(2001, 2003, 2007), 
          stat_name = 'BETR08', 
          substat_name = 'TIERA8', 
          nuts_nr = 2) 
  
  expect_equal(nrow(result), 744)
  
  
})

test_that("calling number of pigs works nuts 3", {
  
  result <- dg_call(year = c(2001, 2003, 2007),
          stat_name = 'BETR08',
          substat_name = 'TIERA8',
          nuts_nr = 3,
          parent_chr = "1")
  
  
  
  expect_equal(nrow(result), 2901)
  
  
  
})


test_that("Nichtwohngebäude works", {
  
  result <- dg_call(nuts_nr = 1, 
          stat_name =  "BAU018", 
          substat_name = "BAUAHZ")
  
  
  expect_equal(nrow(result), 224)
  
  
  
})
