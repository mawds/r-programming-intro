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





At the end of the previous episode we verified that our `cleanfields()` function worked on one of the variables using the `summary()` function.  This showed that all the `-999.9` values had been recoded to `NA`.

We can (and should) adopt a more formal approach to testing the functionality of our function by writing *unit tests*.   These let us test *specific* elements of our function's functionality.    If we need to modify our function the unit tests let us confirm that our change hasn't broken any of the function's existing functionality; this is really powerful - if we test our code, we *know* we can modify it without fear of 
breaking it.

For example, let's test that our `cleanfield()` function behaves as we expect:


~~~
testvector <- c(1,2,-999.99)
cleanfield(testvector)
~~~
{: .language-r}



~~~
[1]  1  2 NA
~~~
{: .output}

The power of testing comes when we write code to *check* that the function has behaved as expected.  We would need to write code to check that the `cleanfield()` function had
produced the vector `c(1,2,NA)`.

Writing such tests is cumbersome. We may also want to test things besides equality. For
example, if we pass invalid data into a function we would want to check we obtained an
error.   

The R package `testthat` makes it easy for us to write and run tests to verify our function behaves as we'd like.  If you put your functions in a package (see, for example, [R Packages, by Hadley Wickham](http://r-pkgs.had.co.nz/)), it integrates well with the package development process. 

> ## Installing testthat
> 
> Testthat is not installed on the university teaching machines.  It can be installed like any
> other R package on CRAN, using:
> 
> 
> ~~~
> install.packages("testthat")
> ~~~
> {: .language-r}
> 
> By default, this will install the package to your personal package directory.  On
> the university machines, this is at `P:\R\win-library\3.4`.
> 
{: .callout}

For now let's put our tests in a separate file.  It is good practice to keep
your tests in a separate directory. If we write an R package, R will expect this directory to be called `tests`, so it is a very good idea to stick with this convention.  When you downloaded the course data, this included some example test, which will be in your project's `tests` folder.  `testthat` test files are named `test_xxx.R`.  The file `test_cleandata.R` contains some initial tests for our function.  The file is shown below:


~~~
context("Cleaning fields") # We group tests for similar functionality into contexts

# Note the position of {} 
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
{: .language-r}

We can execute the tests by loading the `testthat` package, and running `test_file()`:
(note that the output of `test_file()` will look slightly different on your machine; the fancy formatting
used by `testthat` doesn't show correctly in these lessons)

~~~
library("testthat")
~~~
{: .language-r}

~~~
test_file("tests/test_cleandata.R")
~~~
{: .language-r}



~~~
Cleaning fields: .......

══ DONE ═══════════════════════════════════════════════════════════════════
~~~
{: .output}

`tests/test_fail.R` contains a test which expects the result of cleaning the field to
be `c(2,3,NA)` (not `c(1,2,NA)`). If a test fails we get an informative error message, 
which shows where in the file the failure occurred (the number after the `#` is the line number of the file), and an indication of what the failure was:


~~~
test_file("tests/test_fail.R")
~~~
{: .language-r}



~~~
Cleaning fields: 1

══ Failed ═════════════════════════════════════════════════════════════════
── 1. Failure: Can clean a field (@test_fail.R#8)  ────────────────────────
c(2, 3, NA) not equal to cleanfield(testvector).
2/3 mismatches (average diff: 1)
[1] 2 - 1 == 1
[2] 3 - 2 == 1

══ DONE ═══════════════════════════════════════════════════════════════════
~~~
{: .output}


> ## Challenge
> 
> The `test_cleandata.R` file doesn't test whether the code we wrote to check variable names exist
> works properly.  Modify the file where indicated to test this functionality.  You may find the `expect_error()` 
> function useful. 
> 
> Note that all the expectations start `expect_`; if you're unsure of the exact name of the 
> expectation you want (or unsure of exactly what you want to test), you can use R Studio's command
> completion popup to look through the list.
> 
> > ## Solution
> > 
> > 
> > ~~~
> > test_that("Missing variable detection works",{
> >   
> >   # Make a test tibble to run the tests on
> >   testtibble <- tibble(a = c(1,2,3), b = c(4,5,6) )
> >   # Test that we get an error if we specify a missing variable name
> >   expect_error(cleanfields(testtibble, c("a","d")))
> >   
> > })
> > ~~~
> > {: .language-r}
> {: .solution}
{: .challenge}

> ## Challenge: Repeated variable names
> 
> At present we can pass the same variable name to our `cleanfields()` function more than once, e.g.
> 
> ~~~
> cleanfields(mydata, c("field1","field2","field1"))
> ~~~
> {: .language-r}
> 
> The function will still work, but the second pass through the data for the repeated field will have no effect.
> The user probably didn't mean to repeat the field; maybe they made a typing error and meant field3. 
> 
> Write a test to expect a warning if a variable name is repeated.  Run your tests, and check that the test failure (i.e. the lack of warning) is reported.
> 
> Then modify your function to return a warning so that the test passes.   Developing code in this way is referred to as test driven development.  See, for example, [Test Driven Development: By Example, by Beck]( https://www.amazon.co.uk/Test-Driven-Development-Addison-Wesley-Signature/dp/0321146530)
> 
> Hint:  There are a number of ways of checking whether a vector contains duplicated elements.  `unique()` returns only the unique elements of a vector.  You could compare the length of this vector to the original vector.  `anyDuplicated()` returns the index of the first duplicated element in a vector, or 0 if there are no duplicate elements.
> 
> > ## Solution
> > 
> > A suitable test would be:
> > 
> > ~~~
> > test_that("Duplicate variables give a warning",{
> >   
> >   testtibble <- tibble(a = c(1,2,3), b = c(4,5,6) )
> >   
> >   expect_warning(cleanfields(testtibble, c("a","a")))
> >   # Do we still get a warning if the duplicates aren't adjacent?
> >   expect_warning(cleanfields(testtibble, c("a","b","a")))
> > })
> > ~~~
> > {: .language-r}
> > 
> > These tests fail unless we modify our `cleanfields()` function:
> > 
> > 
> > ~~~
> > cleanfields <- function(dataset, fieldlist, ...){
> >   
> >   if ( !all(fieldlist %in% names(dataset)) ) {
> >     stop("Attempting to clean variables that do not exist in the dataset")
> >   }
> >   
> >   if ( anyDuplicated(fieldlist) != 0 ) {
> >     warning("Duplicated variable names specified")
> >   }
> >   
> >   for (f in fieldlist) {
> >     dataset[[f]] <- cleanfield(dataset[[f]], ...)
> >   }
> >   
> >   return(dataset) 
> > }
> > ~~~
> > {: .language-r}
> {: .solution}
{: .challenge}




