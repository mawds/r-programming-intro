context("Cleaning fields")

  testvector <- c(1,2,-999.99)
  testtibble <- tibble(a = c(1,2,3), b = c(3,4,-999.99), c = c(1,-999.99,2))
  
  
  test_that("Can clean a field", {
  
  
  expect_equal(c(1,2,NA), cleanfield(testvector))
  expect_equal(c(1,NA,-999.99), cleanfield(testvector, missingvalue = 2))
  
  expect_equal(NA, cleanfield(-999.99))
  expect_equal(1, cleanfield(1))
})

test_that("Can clean multiple fields",{
  
  
  cleanedtibbleSinglefield <- tibble(a = c(1,2,3), b = c(3, 4, NA), c = c(1, -999.99, 2))
  expect_equal(cleanedtibbleSinglefield, cleanfields(testtibble, "b"))
  
  cleanedtibbleMultifield <- tibble(a = c(1,2,3), b = c(3, 4, NA), c = c(1, NA, 2))
  expect_equal(cleanedtibbleMultifield, cleanfields(testtibble, c("b","c")))
})

test_that("Missing variable detection works",{
  
  # Test that we get an error if we specify a missing variable name
  expect_error(cleanfields(testtibble, c("a","d")))
  
})

test_that("Duplicate variables give a warning",{
  
  
  expect_warning(cleanfields(testtibble, c("a","a")))
  # Do we still get a warning if the duplicates aren't adjacent?
  expect_warning(cleanfields(testtibble, c("a","b","a")))
})


test_that("We can handle named vectors",{
  
  fieldlist <- c("a" = 3, "b" = 4)
  cleanedtibble <- tibble(a = c(1, 2, NA),
                          b = c(3, NA, -999.99),
                          c = c(1, -999.99, 2))
  
  expect_equal(cleanedtibble, cleanfields(testtibble, fieldlist))
})
