test_that("get_descriptions returns tbl_df", {
  r3 <- get_descriptions()
  expect_s3_class(r3, c("tbl_df", "tbl", "data.frame"))
  expect_equal(nrow(r3), 496L)
  expect_equal(ncol(r3), 3L)
})

