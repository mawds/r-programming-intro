---
title: "Creating Functions and controlling program flow"
teaching: 30
exercises: 0
questions:
- "How do I make a function?"
- "How do I execute code multiple times?"
- "How do I execute code conditionally?"
objectives:
- "Define a function that takes arguments."
- "Return a value from a function."
- "Set default values for function arguments."
- "Explain why we should divide programs into small, single-purpose functions."
- "Explain for loops and if...else"
keypoints:
- "Define a function using `name <- function(...args...) {...body...}`."
- "Call a function using `name(...values...)`."
- "R looks for variables in the current stack frame before looking for them at the top level."
- "Put comments at the beginning of functions to provide help for that function."
- "Annotate your code!"
- "Specify default values for arguments when defining a function using `name = value` in the argument list."
- "Arguments can be passed by matching based on name, by position, or by omitting them (in which case the default value is used)."
---

(This episode is derived from episode 2 of [Software Carpentry's Programming with R course](https://github.com/swcarpentry/r-novice-inflammation/))






In the previous episode we loaded in the CO2 data and recoded the missing values to `NA`.    In this
episode we will recode the missing values using a function.   We mentioned in the previous episode that there were several disadvantages to the approach we adopted there, of writing separate code for each of the 
variables we needed to recode:

1. There was repetition in the code; this means more typing, which means more potential to make mistakes (such as cutting and pasting the code, but forgetting to replace all references to a variable, or mistyping a variable)
2. It is difficult to extend the code; if we get data with differently named variables we'd need to start from scratch.   Even if we were confident our original code worked, we couldn't be sure we'd not introduced errors when we converted it to use different variable names.

The solution to these problems is to use a _function_.  A function will take 0 or more inputs, do stuff, and (usually) return an output.    You've already been using functions (such as `mutate()`) in R.  In this episode we show you how to write your own.

## Managing your code

You should store your functions in an R script file, in the `src` folder of your project (which we created in the previous episode).

It is often useful to keep your functions in a separate file (or files).  These can be read into the scripts that perform the actual analysis of your data using `source("filename.R")`.   This makes it easier to reuse the functions we have written.    

> ## Packages
> 
> An extension of this approach is to create an R package. We don't cover this in this course, but see, for example the ["R Packages"" book, by Hadley Wickham](http://r-pkgs.had.co.nz/).   This makes it easy to share your code with others, and makes it easy to include documentation and example data with your code. It also makes it easy to include automatic tests with your code (covered in the next episode)
> 
{: .callout}

Before we dive in and write a function to recode the missing values, let's illustrate by writing a function to convert temperatures: 

## Defining a Function

Let's start by defining a function `fahr_to_kelvin` that converts temperatures from Fahrenheit to Kelvin:


~~~
fahr_to_kelvin <- function(temp) {
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}
~~~
{: .language-r}

We define `fahr_to_kelvin` by assigning it to the output of `function`.
The list of argument names are contained within parentheses.
Next, the [body]({{ page.root }}/reference/#function-body) of the function--the statements that are executed when it runs--is contained within curly braces (`{}`).
The statements in the body are indented by two spaces, which makes the code easier to read but does not affect how the code operates.

When we call the function, the values we pass to it are assigned to those variables so that we can use them inside the function.
Inside the function, we use a [return statement]({{ page.root }}/reference/#return-statement) to send a result back to whoever asked for it.

> ## Automatic Returns
>
> In R, it is not necessary to include the return statement.
> R automatically returns the value of the last expression that was evaluated in the function.
> It is usually a good idea to explicitly define the
> return statement, to make it clear what the function is returning.
{: .callout}

Let's try running our function.
Calling our own function is no different from calling any other function:


~~~
# freezing point of water
fahr_to_kelvin(32)
~~~
{: .language-r}



~~~
[1] 273.15
~~~
{: .output}



~~~
# boiling point of water
fahr_to_kelvin(212)
~~~
{: .language-r}



~~~
[1] 373.15
~~~
{: .output}

We've successfully called the function that we defined, and we have access to the value that we returned.

> ## Challenge: Writing a function
> 
> Write a function to convert Kelvin to Celsius.  The formula to do this is:
> 
> $$\mbox{Celsisus} = \mbox{Kelvin} - 273.15$$
> 
> > ## Solution: Writing a function
> > 
> > 
> > ~~~
> > kelvin_to_celsius <- function(temp) {
> >   celsius <- temp - 273.15
> >   return(celsius)
> > }
> > 
> > #absolute zero in Celsius
> > kelvin_to_celsius(0)
> > ~~~
> > {: .language-r}
> > 
> > 
> > 
> > ~~~
> > [1] -273.15
> > ~~~
> > {: .output}
> > 
> {: .solution}
{: .challenge}


What about converting Fahrenheit to Celsius?
We could write out the formula, but we don't need to.
Instead, we can combine the two functions we have created:


~~~
fahr_to_celsius <- function(temp) {
  temp_k <- fahr_to_kelvin(temp)
  result <- kelvin_to_celsius(temp_k)
  return(result)
}

# freezing point of water in Celsius
fahr_to_celsius(32.0)
~~~
{: .language-r}



~~~
[1] 0
~~~
{: .output}

This is our first taste of how larger programs are built: we define basic
operations, then combine them in ever-larger chunks to get the effect we want.
Real-life functions will usually be larger than the ones shown here--typically half a dozen to a few dozen lines--but they shouldn't ever be much longer than that, or the next person who reads it won't be able to understand what's going on.

> ## Chaining Functions
>
> This example showed the output of `fahr_to_kelvin` assigned to `temp_k`, which
> is then passed to `kelvin_to_celsius` to get the final result. It is also possible
> to perform this calculation in one line of code, by "chaining" functions
> together, like so:
>
> 
> ~~~
> # freezing point of water in Celsius
> kelvin_to_celsius(fahr_to_kelvin(32.0))
> ~~~
> {: .language-r}
> 
> 
> 
> ~~~
> [1] 0
> ~~~
> {: .output}
{: .callout}

> ## The Call Stack
>
> For a deeper understanding of how functions work,
> you'll need to learn how they create their own environments and call other functions.
> Function calls are managed via the call stack.
> For more details on the call stack,
> have a look at the [supplementary material](http://swcarpentry.github.io/r-novice-inflammation/14-supp-call-stack/).
{: .callout}

## Passing arguments

We refer to the values we pass into a function as the function's arguments. The temperature conversion functions we have written all take a single argument.  We can pass more than
one argument to a function.  There are two ways of passing the arguments; by name or by position.  We can also specify the default value of a parameter when we define the function.


~~~
add_some <- function(invar, some=2){
  # Add the value of some to invar
  outvar = invar + some
  return(outvar)
}

add_some(3) # Will use the default value of some
~~~
{: .language-r}



~~~
[1] 5
~~~
{: .output}



~~~
add_some(3,3) # Specify some by position
~~~
{: .language-r}



~~~
[1] 6
~~~
{: .output}



~~~
add_some(3, some = 4) # Specify some by name
~~~
{: .language-r}



~~~
[1] 7
~~~
{: .output}

Parameters without a default value are mandatory; you will get an error if you try to
call a function without specifying them (either by name or position).

## Variable scope 

If we define a variable _within_ our function, then it is only defined within the 
function, and will no longer be defined when the function exits.

What if we try to use a variable within our function that does not exist?  (either by creating it within the function, or by passing it in as a parameter). In this situation R will look into the _calling environment_ for the variable, and use that instead.  This means that it will look at the variables that were defined when the function was called:


~~~
y <- 2

testfunction <- function(x){
  print(x)
  print(y) # y isn't defined in the function, so R will look elsewhere
  
}

testfunction(3)

rm(y) # Delete y

testfunction(3) # R can't find y *anywhere*, so we get an error.
~~~
{: .language-r}

There are limited situations where this is useful.  In general you should avoid referring
to variables outside of your function; keeping everything self contained within the
function makes your code more modular (which makes it easier to reuse functions), and 
easier to debug.

What if we have the same variable name defined within and outside of the function?
In this case the function will use the variable that was defined within the function.

## Handling missing values

Now we've seen how to write a function, and to pass parameters to it, let's write a function that will recode the values in our CO2 data that are invalid to `NA`.  R uses the special value `NA` to represent data that are not available.

It's often useful to work with a smaller version of your data when developing a code, particularly if your program takes some time to run.  Let's just work with the first 5 rows of our CO2 data:


~~~
co2small <- co2weekly[1:5,]
~~~
{: .language-r}

Let's think about the tasks we need to perform, and how we might write functions to do them (or use existing functions to do them).

1. We will need to specify and select a column of data from the tibble.
2. We will need to convert each value in this data to `NA` if it equals `-999.99`, and leave it unchanged otherwise.
3. We will need to replace the data in the tibble with the new data.

There are already functions in R to perform tasks 1 and 3.  We can select a column of data from a tibble in several ways:


~~~
co2small[,"co2Ppm"] # Which will return a tibble
~~~
{: .language-r}



~~~
# A tibble: 5 x 1
  co2Ppm
   <dbl>
1 333.34
2 332.95
3 332.32
4 332.18
5 332.37
~~~
{: .output}



~~~
co2small$co2Ppm # which will return a vector
~~~
{: .language-r}



~~~
[1] 333.34 332.95 332.32 332.18 332.37
~~~
{: .output}



~~~
co2small[["co2Ppm"]] # which will also return a vector
~~~
{: .language-r}



~~~
[1] 333.34 332.95 332.32 332.18 332.37
~~~
{: .output}

You might recall that R is vectorised.  This makes it easy to perform the same operation on all elements of a vector.  For this reason, the second and third approaches are likely to be more useful when writing functions.   Third approach has the advantage that the column of data we want is named in a string.  So we could put our string in a variable, and then write:


~~~
wantedcolumn <- "co2Ppm"
co2small[[wantedcolumn]]
~~~
{: .language-r}

Similarly, we can add or replace a new column of data using the assignment operator, `<-`:


~~~
co2small[["newcolumn"]] <- c(10,20,30,40,50)

co2small[["co2Ppm"]] <- c(0,0,0,0,0)

co2small %>% select(sampledate, co2Ppm, newcolumn)
~~~
{: .language-r}



~~~
# A tibble: 5 x 3
  sampledate co2Ppm newcolumn
      <date>  <dbl>     <dbl>
1 1974-05-19      0        10
2 1974-05-26      0        20
3 1974-06-02      0        30
4 1974-06-09      0        40
5 1974-06-16      0        50
~~~
{: .output}

Before we go any further, let's  regenerate `co2small`, as we've overwritten some of the data:


~~~
co2small <- co2weekly[1:5,]
~~~
{: .language-r}

This just leaves task 2 to worry about.   We need to go through each element of a vector and change its value to `NA` `if` it is equal to `-999.99`.  We could do this using a loop to iterate over each element of the vector (we will discuss loops shortly), but this tends to be slow in R.  Instead, we can use the function `ifelse`, which we saw in the previous episode, to perform this transformation:

> ## Challenge: putting this all together
> 
> Write a function, `cleanfield()` that will take a vector of data and replace
> all instances of "-999.99" with NA, and then return a vector with the cleaned data.
> Your function should use -999.99 as the default value representing missing data, but
> allow the user to override this
>
> > ## Solution
> > 
> > ~~~
> > cleanfield <- function(indata, missingvalue = -999.99){
> >  outdata <- ifelse(indata == missingvalue, NA, indata)
> >  return(outdata)
> > }
> > ~~~
> > {: .language-r}
> > 
> {: .solution}
{: .challenge}




We can use the `cleanfield()` function to clean each of our variables in turn.  For example:

~~~
co2small[["co2Ppm"]] <- cleanfield(co2small[["co2Ppm"]])
co2small[["co2OneYearAgo"]] <- cleanfield(co2small[["co2OneYearAgo"]])
# etc..
co2small
~~~
{: .language-r}



~~~
# A tibble: 5 x 10
   yyyy    mm    dd  decYear co2Ppm  days co2OneYearAgo co2TenYearsAgo
  <int> <int> <int>    <dbl>  <dbl> <int>         <lgl>          <dbl>
1  1974     5    19 1974.380 333.34     6            NA        -999.99
2  1974     5    26 1974.399 332.95     6            NA        -999.99
3  1974     6     2 1974.418 332.32     5            NA        -999.99
4  1974     6     9 1974.437 332.18     7            NA        -999.99
5  1974     6    16 1974.456 332.37     7            NA        -999.99
# ... with 2 more variables: co2Increase1800 <dbl>, sampledate <date>
~~~
{: .output}
The function works, but there is a lot of repetition in our code.  This makes it easy to make mistakes. Compare:
```
co2small[["co2Ppm"]] <- cleanfield(co2small[["co2Ppm"]])
```
and 
```
co2small[["co2PPm"]] <- cleanfield(co2small[["co2Ppm"]])
```

The second line of code will produce a *new* column, `co2PPm`, rather than replacing the existing data.

Let's write another function that will take a tibble, and a vector of variables we wish to apply
the `cleanfield()` function to.

## For loops

In this case we will need to loop over the vector of variable names.   The `for` loop is the programming construct we can use to do this:


~~~
testdata <- 10:15
for (v in testdata) {
  print(paste("The variable v has value:",v))
}
~~~
{: .language-r}



~~~
[1] "The variable v has value: 10"
[1] "The variable v has value: 11"
[1] "The variable v has value: 12"
[1] "The variable v has value: 13"
[1] "The variable v has value: 14"
[1] "The variable v has value: 15"
~~~
{: .output}

The for loop will iterate over each element of the vector `testdata`, putting the value of that element into the
variable `v`.  In the example above we've printed out its value.  

Often we want to alter the values of elements in the array as we loop over them.  To do this we need to adopt 
a slightly different approach:


~~~
for (i in seq_along(testdata)) {
  print(paste("Element number", i, "of the vector is", testdata[i]))
  
}
~~~
{: .language-r}



~~~
[1] "Element number 1 of the vector is 10"
[1] "Element number 2 of the vector is 11"
[1] "Element number 3 of the vector is 12"
[1] "Element number 4 of the vector is 13"
[1] "Element number 5 of the vector is 14"
[1] "Element number 6 of the vector is 15"
~~~
{: .output}

> ## Making your code robust
> In the example above we could have written `for (i in 1:length(testdata))`.  Since `length(testdata)` is `6`, this will generate the sequence:
> 
> ~~~
> 1:6
> ~~~
> {: .language-r}
> 
> 
> 
> ~~~
> [1] 1 2 3 4 5 6
> ~~~
> {: .output}
> Which is what we want to iterate over; the indices of the vector `testdata`.
> 
> What happens if `testdata` is empty though (i.e. the vector has no elements)?
> 
> 
> ~~~
> emptyvector <- vector()
> length(emptyvector)
> ~~~
> {: .language-r}
> 
> 
> 
> ~~~
> [1] 0
> ~~~
> {: .output}
> 
> 
> 
> ~~~
> # So the code 1:length(emptyvector) generates:
> 1:length(emptyvector)
> ~~~
> {: .language-r}
> 
> 
> 
> ~~~
> [1] 1 0
> ~~~
> {: .output}
> 
> 
> 
> ~~~
> # seq_along() returns an integer vector of length 0
> seq_along(emptyvector)
> ~~~
> {: .language-r}
> 
> 
> 
> ~~~
> integer(0)
> ~~~
> {: .output}
> 
> 
> 
> ~~~
> # So the body of the loop will never execute:
> for (i in seq_along(emptyvector)) {
>   print("Nothing to see here")
> }
> ~~~
> {: .language-r}
> 
> Using `seq_along()` makes our code robust against the situation where our vector is empty.
> 
{: .callout}

By setting up the loop this way we can assign new values to the elements of `testtdata`.  For example, to multiply each element by 2, we could use:


~~~
for (i in seq_along(testdata)) {
  
  testdata[i] <- testdata[i] * 2
  
}
print(testdata)
~~~
{: .language-r}



~~~
[1] 20 22 24 26 28 30
~~~
{: .output}

(In practice we'd never do this; since R is vectorised, we could run `testdata <- testdata * 2`.  This is much quicker to run than creating a `for` loop, and is much less to type)

## Processing multiple columns
As a recap, we could clean a single column of our data using:


~~~
co2small[["co2Ppm"]] <- cleanfield(co2small[["co2Ppm"]])
~~~
{: .language-r}

We can use a `for` loop to run our field cleaning function `cleanfield()` on more than one column at once

> ## Challenge: Cleaning multiple fields
> 
> Write a function, `cleanfields()` that will call the `cleanfield()` function (with its default `missingvalue`
> parameter) on each of the variables whose names are given in a character vector.
> 
> For example,
> 
> 
> ~~~
> fieldsWithMissingData <- c("co2Ppm", "co2OneYearAgo", "co2TenYearsAgo", "co2Increase1800")
> co2clean <- cleanfields(co2small, fieldsWithMissingData)
> ~~~
> {: .language-r}
> will clean clean the input data and assign the tibble containing the 
> cleaned data to `co2clean`
> 
> > ## Solution
> >
> >
> >~~~
> ># Clean multiple fields of data
> >cleanfields <- function(dataset, fieldlist){
> >  
> >  for (f in fieldlist) {
> >    dataset[[f]] <- cleanfield(dataset[[f]])
> >  }
> > 
> >  return(dataset) 
> >}
> >~~~
> >{: .language-r}
> >
> {: .solution}
{: .challenge}



## Passing arguments to other functions

When we wrote our function, `cleanfield()`, to clean a single field of data, we provided the `missingvalue` argument to let the user override the default value.    In writing our `cleanfields()` function, we have lost the ability to change the value that represents missing data.  We can do this using a special argument to
the functions, `...` (three dots).  This lets us pass arguments on to other functions.

To illustrate how this works, let's modify the cleanfields function:



~~~
# Clean multiple fields of data
cleanfields <- function(dataset, fieldlist, ...){
  
  for (f in fieldlist) {
    dataset[[f]] <- cleanfield(dataset[[f]], ...)
  }
  
  return(dataset) 
}
~~~
{: .language-r}

We have added `...` to the argument list for the `cleanfield()` and `cleandfields()` functions.

We can use our function in exactly the same way as before:

~~~
cleanfields(co2weekly, c("co2OneYearAgo", "co2TenYearsAgo"))
~~~
{: .language-r}



~~~
# A tibble: 2,233 x 10
    yyyy    mm    dd  decYear co2Ppm  days co2OneYearAgo co2TenYearsAgo
   <int> <int> <int>    <dbl>  <dbl> <int>         <dbl>          <dbl>
 1  1974     5    19 1974.380 333.34     6            NA             NA
 2  1974     5    26 1974.399 332.95     6            NA             NA
 3  1974     6     2 1974.418 332.32     5            NA             NA
 4  1974     6     9 1974.437 332.18     7            NA             NA
 5  1974     6    16 1974.456 332.37     7            NA             NA
 6  1974     6    23 1974.475 331.59     6            NA             NA
 7  1974     6    30 1974.495 331.68     6            NA             NA
 8  1974     7     7 1974.514 331.44     6            NA             NA
 9  1974     7    14 1974.533 330.85     5            NA             NA
10  1974     7    21 1974.552 330.76     7            NA             NA
# ... with 2,223 more rows, and 2 more variables: co2Increase1800 <dbl>,
#   sampledate <date>
~~~
{: .output}
But if we want to override the value that represents missing (say, we wanted to treat `days=6` as missing):


~~~
cleanfields(co2weekly, "days", missingvalue = 6)
~~~
{: .language-r}



~~~
# A tibble: 2,233 x 10
    yyyy    mm    dd  decYear co2Ppm  days co2OneYearAgo co2TenYearsAgo
   <int> <int> <int>    <dbl>  <dbl> <int>         <dbl>          <dbl>
 1  1974     5    19 1974.380 333.34    NA       -999.99        -999.99
 2  1974     5    26 1974.399 332.95    NA       -999.99        -999.99
 3  1974     6     2 1974.418 332.32     5       -999.99        -999.99
 4  1974     6     9 1974.437 332.18     7       -999.99        -999.99
 5  1974     6    16 1974.456 332.37     7       -999.99        -999.99
 6  1974     6    23 1974.475 331.59    NA       -999.99        -999.99
 7  1974     6    30 1974.495 331.68    NA       -999.99        -999.99
 8  1974     7     7 1974.514 331.44    NA       -999.99        -999.99
 9  1974     7    14 1974.533 330.85     5       -999.99        -999.99
10  1974     7    21 1974.552 330.76     7       -999.99        -999.99
# ... with 2,223 more rows, and 2 more variables: co2Increase1800 <dbl>,
#   sampledate <date>
~~~
{: .output}

> ## Other uses for `...`
> 
> `...` is also used when we want to pass an arbitrary number of arguments to a function. We've seen examples of this such as the `c()` function:
> 
> 
> ~~~
> c(1)
> c(1,2)
> c(1,2,3)
> ~~~
> {: .language-r}
> 
> We don't cover it in this course, but you can examine the aguments that are contained in the `...` parameter
> by converting it to a list within your function:
> 
> ~~~
> ellipsisArguments <- list(...)
> ~~~
> {: .language-r}
> 
> This lets us write functions that are very flexible.
> 
{: .callout}



## Checking our results

Let's run our function on our main data-set, and plot the results to  verify it has done what we expected:


~~~
fieldsWithMissingData <- c("co2Ppm", "co2OneYearAgo", "co2TenYearsAgo", "co2Increase1800")
co2clean <- cleanfields(co2weekly, fieldsWithMissingData) 
summary(co2clean)
~~~
{: .language-r}



~~~
      yyyy            mm               dd           decYear    
 Min.   :1974   Min.   : 1.000   Min.   : 1.00   Min.   :1974  
 1st Qu.:1985   1st Qu.: 4.000   1st Qu.: 8.00   1st Qu.:1985  
 Median :1995   Median : 7.000   Median :16.00   Median :1996  
 Mean   :1995   Mean   : 6.532   Mean   :15.73   Mean   :1996  
 3rd Qu.:2006   3rd Qu.:10.000   3rd Qu.:23.00   3rd Qu.:2006  
 Max.   :2017   Max.   :12.000   Max.   :31.00   Max.   :2017  
                                                               
     co2Ppm           days       co2OneYearAgo   co2TenYearsAgo 
 Min.   :326.7   Min.   :0.000   Min.   :326.8   Min.   :326.6  
 1st Qu.:345.7   1st Qu.:5.000   1st Qu.:345.2   1st Qu.:341.7  
 Median :361.3   Median :6.000   Median :360.4   Median :354.4  
 Mean   :363.9   Mean   :5.829   Mean   :362.9   Mean   :354.7  
 3rd Qu.:381.9   3rd Qu.:7.000   3rd Qu.:380.2   3rd Qu.:367.3  
 Max.   :408.7   Max.   :7.000   Max.   :404.4   Max.   :385.3  
 NA's   :20                      NA's   :69      NA's   :538    
 co2Increase1800    sampledate        
 Min.   : 49.57   Min.   :1974-05-19  
 1st Qu.: 65.84   1st Qu.:1985-01-27  
 Median : 81.62   Median :1995-10-08  
 Mean   : 83.89   Mean   :1995-10-08  
 3rd Qu.:101.94   3rd Qu.:2006-06-18  
 Max.   :126.26   Max.   :2017-02-26  
 NA's   :20                           
~~~
{: .output}

The summary shows us that we don't have any negative co2 values, and that we have `NA` values instead.  This suggests that our function is behaving as we expect.  In the next episode we'll look at how to formalise this testing process.

## Conditional execution

At the moment our `cleanfields()` function doesn't test the variables we want to clean exist.  This causes it
to exit with an unhelpful error message if we try and clean a field that doesn't exist:


~~~
cleanfields(co2small, c("notAVariable"))
~~~
{: .language-r}



~~~
Error in `[[<-.data.frame`(`*tmp*`, f, value = logical(0)): replacement has 0 rows, data has 5
~~~
{: .error}

We want the function to only run `if` all the variable names exist, and to stop otherwise.  To execute statements based on whether a condition is true or not, we use the `if` construct:

## if

The `if...else` construct lets us take an action if a condition is true:


~~~
x <- 5

if (x < 3) { # x < 3 will return FALSE
  print("x is less than 3") # This isn't executed
}

# Using else is optional
if (x < 3) {
  print("x is less than 3") # This isn't executed
} else {
  print("x is not less than 3")
}
~~~
{: .language-r}



~~~
[1] "x is not less than 3"
~~~
{: .output}

The condition we test can be anything that evaluates to a _single_ `TRUE` or `FALSE` value.  We can also "chain" `if` statements:


~~~
x <- 3
if (x < 3) {
  print("x is less than 3")
} else if (x > 3) {
  print("x is greater than 3")
} else {
  print("x is 3")
}
~~~
{: .language-r}



~~~
[1] "x is 3"
~~~
{: .output}

Let's look at how we can use the `if` statement to check if all of our variable names exist in the data-set we're cleaning.  We can use the `names()` function to print a vector of variable names:


~~~
names(co2small)
~~~
{: .language-r}



~~~
 [1] "yyyy"            "mm"              "dd"             
 [4] "decYear"         "co2Ppm"          "days"           
 [7] "co2OneYearAgo"   "co2TenYearsAgo"  "co2Increase1800"
[10] "sampledate"     
~~~
{: .output}

And we have a vector of (one or more) variable names we wish to clean:

~~~
fieldsWithMissingData
~~~
{: .language-r}



~~~
[1] "co2Ppm"          "co2OneYearAgo"   "co2TenYearsAgo"  "co2Increase1800"
~~~
{: .output}

The `%in%` operator lets us test whether the values in one vector are contained in another:


~~~
fieldsWithMissingData %in% names(co2small)
~~~
{: .language-r}



~~~
[1] TRUE TRUE TRUE TRUE
~~~
{: .output}

We see that we obtain a `TRUE` for _each_ of the elements in `fieldsWithMissingData`.   The `if` function requires that we test whether a single element is `TRUE` or `FALSE` (if we pass a vector with length >1 only the first element of the vector is tested, and a warning printed).  We need a function to check whether all the elements of the vector are `TRUE`:


~~~
all( fieldsWithMissingData %in% names(co2small))
~~~
{: .language-r}



~~~
[1] TRUE
~~~
{: .output}



~~~
# and to prove it works if we are missing a field:
all( c(fieldsWithMissingData, "notHere") %in% names(co2small))
~~~
{: .language-r}



~~~
[1] FALSE
~~~
{: .output}

## Logical tests

We often want to test more than one condition at once, or perhaps run a block of code if one thing OR another is TRUE. We can combine tests using logical operators. For example, to test if either or both expressions are TRUE, we use the OR operator, `||`:


~~~
TRUE || TRUE
~~~
{: .language-r}



~~~
[1] TRUE
~~~
{: .output}



~~~
TRUE || FALSE
~~~
{: .language-r}



~~~
[1] TRUE
~~~
{: .output}



~~~
FALSE || TRUE
~~~
{: .language-r}



~~~
[1] TRUE
~~~
{: .output}



~~~
FALSE || TRUE
~~~
{: .language-r}



~~~
[1] TRUE
~~~
{: .output}

For full details of R's logical operators, see `?base::Logic`.   There are also versions of the logical operators which operate on _each_ element of a vector.


> ## Challenge:
> 
> Modify your function `cleanfields()` so that it stops and prints an error if you try 
> to modify a variable that doesn't exist.  You should use the `stop()` function to 
> print an informative error message and stop the execution
> 
> > ## Solution
> > 
> > 
> > ~~~
> > # Clean multiple fields of data
> > cleanfields <- function(dataset, fieldlist){
> >   
> >   if ( !all(fieldlist %in% names(dataset)) ) {
> >     stop("Attempting to clean variables that do not exist in the dataset")
> >   }
> >   
> >   for (f in fieldlist) {
> >     dataset[[f]] <- cleanfield(dataset[[f]])
> >   }
> >   
> >   return(dataset) 
> > }
> > ~~~
> > {: .language-r}
> > 
> > Note that we don't need to use an `else` statement here, as `stop()` causes the function to abort. 
> >
> > If there's a less severe problem, we can use the `warning()` function to print the specified message as a warning. For example
> > `warning("This is a warning")`
> {: .solution}
{: .challenge}


