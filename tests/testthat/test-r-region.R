test_that("calling a simple statistic works", {
  r4_df1 <- dg_call(
    region_id = "11",
    year = 2002,
    stat_name = "AI0506")
  expect_s3_class(r4_df1, c("tbl_df", "tbl", "data.frame"))
  
})

test_that("calling a substat statistic works", {
  r4_df2 <- dg_call(
    region_id = "11",
    year = c(2001, 2003, 2007),
    stat_name = "BETR08",
    substat_name = "TIERA8")
  expect_s3_class(r4_df2, c("tbl_df", "tbl", "data.frame"))
  
})

test_that("calling a substat statistic with parameters works", {
  r4_df3 <- dg_call(
    region_id = "11",
    year = c(2001, 2003, 2007),
    stat_name = "BETR08",
    substat_name = "TIERA8",
    parameter = c("TIERART2", "TIERART3", "TIERART4"))
  expect_s3_class(r4_df3, c("tbl_df", "tbl", "data.frame"))
  
})
