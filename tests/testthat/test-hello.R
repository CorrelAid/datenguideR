test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("supplying string should throw error", {
  expect_error(
    add(5, "i_am_not_a_number")
  )
})
