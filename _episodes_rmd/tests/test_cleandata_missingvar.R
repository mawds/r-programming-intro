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

test_that("Missing variable detection works",{
  
  # Make a test tibble to run the tests on
  testtibble <- tibble(a = c(1,2,3), b = c(4,5,6) )
  # Test that we get an error if we specify a missing variable name
  expect_error(cleanfields(testtibble, c("a","d")))
  
})

test_that("Duplicate variables give a warning",{
  
  testtibble <- tibble(a = c(1,2,3), b = c(4,5,6) )
  
  expect_warning(cleanfields(testtibble, c("a","a")))
  # Do we still get a warning if the duplicates aren't adjacent?
  expect_warning(cleanfields(testtibble, c("a","b","a")))
})