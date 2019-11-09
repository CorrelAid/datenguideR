test_that("dg_regions$id is of type 'character'", {
  expect_type(dg_regions[["id"]], "character")
})

test_that("dg_regions$id is of type 'character'", {
  expect_identical(dg_regions[["id"]], unique(dg_regions[["id"]]))
})
