---
title: "Testing Functions"
teaching: 30
exercises: 0
questions:
- "Why should we test our functions?"
- "How do we test our functions?"
objectives:
- "To use testthat to run unit tests on our functions"
keypoints:
- "Use testthat to formalise your tests"
---





At the end of the previous episode we verified that our `cleanfields()` function worked on one of the variables by plotting a graph of the cleaned data.  This showed that all the `-999.9` values had been recoded to `NA`.

We can (and should) adopt a more formal approach to testing the functionality of our function by writing *unit tests*.   These let us test *specific* elements of our function's functionality.    If we need to modify our function the unit tests let us confirm that our change hasn't broken any of the function's existing functionality.


For example, let's test that our `cleanfield()` function behaves as we expect:



~~~
testvector <- c(1,2,-999.99)
cleanfield(testvector)
~~~
{: .r}



~~~
[1]  1  2 NA
~~~
{: .output}



The power of testing comes when we write code to *check* that the function has behaved as expected.  For example:

FIXME - this is a horrid example, as it takes us down the rabbit-hole of dealing with `NA`s in logic tests
and the all.equal() wrinkle



~~~
expectedResults <- c(1,2,NA)

if( isTRUE(all.equal(cleanfield(testvector), expectedResults)) ){
  print("Test passed")
} else {
  print("Test failed")
}
~~~
{: .r}



~~~
[1] "Test passed"
~~~
{: .output}





~~~
ls()
~~~
{: .r}



~~~
 [1] "cleanfield"            "cleanfields"          
 [3] "co2clean"              "co2small"             
 [5] "co2weekly"             "demodata"             
 [7] "expectedResults"       "fahr_to_celsius"      
 [9] "fahr_to_kelvin"        "fieldsWithMissingData"
[11] "fix_fig_path"          "gapminder"            
[13] "hook_error"            "hook_in"              
[15] "hook_out"              "i"                    
[17] "kelvin_to_celsius"     "knitr_fig_path"       
[19] "testdata"              "testvector"           
[21] "v"                     "x"                    
~~~
{: .output}



Writing such tests is cumbersome.  The R package `testthat` makes it easy for us to write and run tests to verify our function behaves as we'd like.  If you put your functions in a package (see, for example, FIXME), it integrates well with the development process.  For now let's put our tests in a separate file.  In this file we'll load the `testthat` package.  An example of a file containing tests is included in the data you downloaded at the start of the course.



~~~
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
~~~
{: .r}



We can execute the tests by loading the `testthat` package, and running `test_file()`:



~~~
library("testthat")
test_file("tests/test_cleandata.R", env=.GlobalEnv)
~~~
{: .r}



~~~
Cleaning fields: .......

DONE ======================================================================
~~~
{: .output}



To show you what happens when a test fails:



~~~
test_file("tests/test_fail.R")
~~~
{: .r}



~~~
Cleaning fields: 1

Failed --------------------------------------------------------------------
1. Failure: Can clean a field (@test_fail.R#8) ----------------------------
c(2, 3, NA) not equal to cleanfield(testvector).
2/3 mismatches (average diff: 1)
[1] 2 - 1 == 1
[2] 3 - 2 == 1


DONE ======================================================================
~~~
{: .output}








