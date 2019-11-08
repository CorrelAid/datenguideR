test_that("calling a simple statistic works", {
  
  result <- dg_call(region_id = "11",
          year = 2002,
          stat_name = 'AI0506')
  
  expect_equal(nrow(result), 1)
  
})

test_that("calling a substat statistic works", {
  
  result <- dg_call(region_id = "11", 
          year = c(2001, 2003, 2007), 
          stat_name = 'BETR08', 
          substat_name = 'TIERA8') 
  
  expect_equal(nrow(result), 23)
  
})

test_that("calling a substat statistic with parameters works", {
  
  result <- dg_call(region_id = "11", 
          year = c(2001, 2003, 2007), 
          stat_name = 'BETR08', 
          substat_name = 'TIERA8',
          parameter = c("TIERART2", "TIERART3", "TIERART4")) 
  

  expect_equal(nrow(result), 9)
  
})
