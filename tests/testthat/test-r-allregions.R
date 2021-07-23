test_that("calling number of pigs works nuts 1", {
  r3_df1 <- dg_call(
    year = c(2001, 2003, 2007),
    stat_name = "BETR08",
    substat_name = "TIERA8",
    nuts_nr = 1)
  expect_s3_class(r3_df1, c("tbl_df", "tbl", "data.frame"))
})

test_that("calling number of pigs works nuts 2", {
  r3_df2 <- dg_call(
    year = c(2001, 2003, 2007),
    stat_name = "BETR08",
    substat_name = "TIERA8",
    nuts_nr = 2)
  expect_s3_class(r3_df2, c("tbl_df", "tbl", "data.frame"))
})

test_that("calling number of pigs works nuts 3", {
  r3_df3 <- dg_call(
    year = c(2001, 2003, 2007),
    stat_name = "BETR08",
    substat_name = "TIERA8",
    nuts_nr = 3,
    parent_chr = 1)
  expect_s3_class(r3_df3, c("tbl_df", "tbl", "data.frame"))
})


test_that("Nichtwohngebäude works", {
  r3_df4 <- dg_call(
    nuts_nr = 1,
    stat_name = "BAU018",
    substat_name = "BAUAHZ")
  expect_s3_class(r3_df4, c("tbl_df", "tbl", "data.frame"))
  
})
