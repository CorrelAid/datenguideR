test_that("get_region returns subset of dg_regions", {
  r1 <- get_region(var = level, val = "nuts1")
  expect_s3_class(r1, c("tbl_df", "tbl", "data.frame"))
  expect_equal(nrow(r1), 16L)
  expect_true(all(r1[["parent"]] == "DG"))
  expect_equal(r1, get_region(var = parent, val = "DG"))
})
