test_that("calling number of pigs works nuts 1", {
  df1 <- dg_call(
    year = c(2001, 2003, 2007),
    stat_name = "BETR08",
    substat_name = "TIERA8",
    nuts_nr = 1
  )

  expect_is(df1, "tbl_df")
  expect_equal(dim(df1), c(383L, 15L))
})

test_that("calling number of pigs works nuts 2", {
  df2 <- dg_call(
    year = c(2001, 2003, 2007),
    stat_name = "BETR08",
    substat_name = "TIERA8",
    nuts_nr = 2
  )

  expect_is(df2, "tbl_df")
  expect_equal(dim(df2), c(744L, 15L))
})

test_that("calling number of pigs works nuts 3", {
  df3 <- dg_call(
    year = c(2001, 2003, 2007),
    stat_name = "BETR08",
    substat_name = "TIERA8",
    nuts_nr = 3,
    parent_chr = 1
  )

  expect_is(df3, "tbl_df")
  expect_equal(dim(df3), c(2901L, 15L))
})


test_that("Nichtwohngebäude works", {
  df4 <- dg_call(
    nuts_nr = 1,
    stat_name = "BAU018",
    substat_name = "BAUAHZ"
  )

  expect_is(df4, "tbl_df")
  expect_equal(dim(df4), c(336L, 15L))
})
