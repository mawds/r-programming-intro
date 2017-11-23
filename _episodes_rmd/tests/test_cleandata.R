context("Cleaning fields")

test_that("Can clean a field", {
  
  testvector <- c(1,2,-999.99)
  
  expect_equal(c(1,2,NA), cleanfield(testvector))
  expect_equal(c(1,NA,-999.99), cleanfield(testvector, missingvalue = 2))
  
  expect_equal(NA, cleanfield(-999.99))
  expect_equal(1, cleanfield(1))
})

test_that("Can clean multiple fields",{
  
  testtibble <- tibble(a = c(1,2,3), b = c(3,4,-999.99), c = c(1,-999.99,2))
  
  cleanedtibbleSinglefield <- tibble(a = c(1,2,3), b = c(3, 4, NA), c = c(1, -999.99, 2))
  expect_equal(cleanedtibbleSinglefield, cleanfields(testtibble, "b"))
  
  cleanedtibbleMultifield <- tibble(a = c(1,2,3), b = c(3, 4, NA), c = c(1, NA, 2))
  expect_equal(cleanedtibbleMultifield, cleanfields(testtibble, c("b","c")))
})
