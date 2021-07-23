test_that("dg_map returns list", {
  r2 <- dg_map(nuts_nr = 1, year = 2017, stat_name = "AI0506")
  expect_s3_class(r2, c("gg", "ggplot"))
  expect_equal(length(r2), 9L)
})

