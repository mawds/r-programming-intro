context("Cleaning fields")

test_that("Can clean a field", {
  
  testvector <- c(1,2,-999.99)
  
  
  expect_equal(c(2,3,NA), cleanfield(testvector))
})

