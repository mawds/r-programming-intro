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

The power of testing comes when we write code to *check* that the function has behaved as expected.  


The R package `testthat` makes it easy for us to write unit tests to verify our function behaves as we'd like.  If you put your functions in a package (see, for example, FIXME), it integrates well with the development process.  For now let's put our tests in a separate file.  In this file we'll load the `testthat` package, and `source()` the file containing our functions:


~~~
library("testthat")
source("myfunctions.R")
~~~
{: .r}


~~~

Attaching package: 'testthat'
~~~
{: .output}



~~~
The following object is masked from 'package:dplyr':

    matches
~~~
{: .output}



~~~
The following object is masked from 'package:purrr':

    is_null
~~~
{: .output}


FIXME - finish.  Perhaps include example test file in data package?






