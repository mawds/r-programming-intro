---
title: "Creating Functions"
teaching: 30
exercises: 0
questions:
- "How do I make a function?"
- "How can I test my functions?"
- "How should I document my code?"
objectives:
- "Define a function that takes arguments."
- "Return a value from a function."
- "Test a function."
- "Set default values for function arguments."
- "Explain why we should divide programs into small, single-purpose functions."
keypoints:
- "Define a function using `name <- function(...args...) {...body...}`."
- "Call a function using `name(...values...)`."
- "R looks for variables in the current stack frame before looking for them at the top level."
- "Use `help(thing)` to view help for something."
- "Put comments at the beginning of functions to provide help for that function."
- "Annotate your code!"
- "Specify default values for arguments when defining a function using `name = value` in the argument list."
- "Arguments can be passed by matching based on name, by position, or by omitting them (in which case the default value is used)."
---

(This episode is derived from episode 2 of [Software Carpentry's Programming with R course](https://github.com/swcarpentry/r-novice-inflammation/))






In the previous episode we loaded in the CO2 data and recoded the missing values to NA FIXME: Do this.   In this
episode we will recode the missing values using a function.

TODO benefits of functions.. reusability, testing, easier to maintain code, etc.

Before we write a function to recode the missing values, let's illustrate the approach using the example of converting temperatures:


### Defining a Function

Let's start by defining a function `fahr_to_kelvin` that converts temperatures from Fahrenheit to Kelvin:


~~~
fahr_to_kelvin <- function(temp) {
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}
~~~
{: .r}

We define `fahr_to_kelvin` by assigning it to the output of `function`.
The list of argument names are contained within parentheses.
Next, the [body]({{ page.root }}/reference/#function-body) of the function--the statements that are executed when it runs--is contained within curly braces (`{}`).
The statements in the body are indented by two spaces, which makes the code easier to read but does not affect how the code operates.

When we call the function, the values we pass to it are assigned to those variables so that we can use them inside the function.
Inside the function, we use a [return statement]({{ page.root }}/reference/#return-statement) to send a result back to whoever asked for it.

> ## Automatic Returns
>
> In R, it is not necessary to include the return statement.
> R automatically returns whichever variable is on the last line of the body
> of the function. Since we are just learning, we will explicitly define the
> return statement.
{: .callout}

Let's try running our function.
Calling our own function is no different from calling any other function:


~~~
# freezing point of water
fahr_to_kelvin(32)
~~~
{: .r}



~~~
[1] 273.15
~~~
{: .output}



~~~
# boiling point of water
fahr_to_kelvin(212)
~~~
{: .r}



~~~
[1] 373.15
~~~
{: .output}

We've successfully called the function that we defined, and we have access to the value that we returned.

### Composing Functions

Now that we've seen how to turn Fahrenheit into Kelvin, it's easy to turn Kelvin into Celsius:


~~~
kelvin_to_celsius <- function(temp) {
  celsius <- temp - 273.15
  return(celsius)
}

#absolute zero in Celsius
kelvin_to_celsius(0)
~~~
{: .r}



~~~
[1] -273.15
~~~
{: .output}

What about converting Fahrenheit to Celsius?
We could write out the formula, but we don't need to.
Instead, we can [compose]({{ page.root }}/reference/#function-composition) the two functions we have already created:


~~~
fahr_to_celsius <- function(temp) {
  temp_k <- fahr_to_kelvin(temp)
  result <- kelvin_to_celsius(temp_k)
  return(result)
}

# freezing point of water in Celsius
fahr_to_celsius(32.0)
~~~
{: .r}



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
> {: .r}
> 
> 
> 
> ~~~
> [1] 0
> ~~~
> {: .output}
{: .callout}

> ## Create a Function
>
> In the last lesson, we learned to **c**oncatenate elements into a vector using the `c` function,
> e.g. `x <- c("A", "B", "C")` creates a vector `x` with three elements.
> Furthermore, we can extend that vector again using `c`, e.g. `y <- c(x, "D")` creates a vector `y` with four elements.
> Write a function called `fence` that takes two vectors as arguments, called
> `original` and `wrapper`, and returns a new vector that has the wrapper vector
> at the beginning and end of the original:
>
> 
> ~~~
> best_practice <- c("Write", "programs", "for", "people", "not", "computers")
> asterisk <- "***"  # R interprets a variable with a single value as a vector
>                    # with one element.
> fence(best_practice, asterisk)
> ~~~
> {: .r}
> 
> 
> 
> ~~~
> [1] "***"       "Write"     "programs"  "for"       "people"    "not"      
> [7] "computers" "***"      
> ~~~
> {: .output}
>
> > ## Solution
> > ~~~
> > fence <- function(original, wrapper) {
> >   answer <- c(wrapper, original, wrapper)
> >   return(answer)
> > }
> > ~~~
> > {: .r}
> {: .solution}
>
> If the variable `v` refers to a vector, then `v[1]` is the vector's first element and `v[length(v)]` is its last (the function `length` returns the number of elements in a vector).
> Write a function called `outside` that returns a vector made up of just the first and last elements of its input:
>
> 
> ~~~
> dry_principle <- c("Don't", "repeat", "yourself", "or", "others")
> outside(dry_principle)
> ~~~
> {: .r}
> 
> 
> 
> ~~~
> [1] "Don't"  "others"
> ~~~
> {: .output}
{: .challenge}

> ## The Call Stack
>
> For a deeper understanding of how functions work,
> you'll need to learn how they create their own environments and call other functions.
> Function calls are managed via the call stack.
> For more details on the call stack,
> have a look at the [supplementary material]({{ page.root }}/14-supp-call-stack/).
{: .callout}

> ## Named Variables and the Scope of Variables
>
>  + Functions can accept arguments explicitly assigned to a variable name in
>    in the function call `functionName(variable = value)`, as well as arguments by
>    order:
> 
> ~~~
> input_1 = 20
> mySum <- function(input_1, input_2 = 10) {
>   output <- input_1 + input_2
>   return(output)
> }
> ~~~
> {: .r}
>
> 1.  Given the above code was run, which value does `mySum(input_1 = 1, 3)` produce?
>     1. 4
>     2. 11
>     3. 23
>     4. 30
> 2.  If `mySum(3)` returns 13, why does `mySum(input_2 = 3)` return an error?
{: .challenge}

## Handling missing values

Now we've seen how to write a function, and to pass parameters to it, let's write a function that will recode the values in our CO2 data that are invalid to `NA`.  R uses the special `NA` to represent data that are not available.

It's often useful to work with a smaller version of your data when developing a code, particularly if your program takes some time to run.  Let's just work with the first 5 rows of our CO2 data:


~~~
co2small <- co2weekly[1:5,]
~~~
{: .r}


Let's think about the tasks we need to perform, and how we might write functions to do them (or use existing functions to do them).

1. We will need to specify and select a column of data from the tibble.
2. We will need to convert each value in this data to `NA` if it equals `-999.99`, and leave it unchanged otherwise.
3. We will need to replace the data in the tibble with the new data.

There are already functions in R to perform tasks 1 and 3.  We can select a column of data from a tibble in several ways:


~~~
co2small[,"co2Ppm"] # Which will return a tibble
~~~
{: .r}



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
{: .r}



~~~
[1] 333.34 332.95 332.32 332.18 332.37
~~~
{: .output}



~~~
co2small[["co2Ppm"]] # which will also return a vector
~~~
{: .r}



~~~
[1] 333.34 332.95 332.32 332.18 332.37
~~~
{: .output}

You might recall that R is vectorised.  This makes it easy to perform the same operation on all elements of a vector.  For this reason, the second and third approaches are likely to be more useful when writing functions.   Third approach has the advantage that the column of data we want is named in a string.  So we could put our string in a variable, and then write:


~~~
wantedcolumn <- "co2Ppm"
co2small[[wantedcolumn]]
~~~
{: .r}

Similarly, we can add or replace a new column of data using the assignment operator, `<-`:


~~~
co2small[["newcolumn"]] <- c(10,20,30,40,50)

co2small[["co2Ppm"]] <- c(0,0,0,0,0)

co2small %>% select(sampledate, co2Ppm, newcolumn)
~~~
{: .r}



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
{: .r}

This just leaves task 2 to worry about.   We need to go through each element of a vector and change its value to `NA` `if` it is equal to `-999.99`.  We could do this using a loop to iterate over each element of the vector (we will discuss loops shortly), but this tends to be slow in R.  Instead, we can use the function `ifelse` to perform this transformation:


~~~
demodata <- 1:10
ifelse(demodata == 5, demodata,  NA)
~~~
{: .r}



~~~
 [1] NA NA NA NA  5 NA NA NA NA NA
~~~
{: .output}

FIXME - explain function in detail

> ## Challenge: PUTting this all together
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
> > {: .r}
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
{: .r}



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
{: .r}



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
for (i in 1:length(testdata)) {
  print(paste("Element number", i, "of the vector is", testdata[i]))
  
}
~~~
{: .r}



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
>
> In the example above we could have written `for (i in 1:6)`, since this is the length
> of the testdata vector.    By using `length(testdata)` our code will be able to handle
> any length of the `testdata` vector.  This makes the code more generalisable and robust
{: .callout}

By setting up the loop this way we can assign new values to the elements of `testtdata`.  For example, to multiply each element by 2, we could use:


~~~
for (i in 1:length(testdata)) {
  
  testdata[i] <- testdata[i] * 2
  
}
print(testdata)
~~~
{: .r}



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
{: .r}

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
> cleanfields(co2small, fieldsWithMissingData)
> ~~~
> {: .r}
> should clean our data-file
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
> >{: .r}
> >
> {: .solution}
{: .challenge}





## Checking our results

Let's run our function on our main data-set, and plot the results to  verify it has done what we expected:


~~~
fieldsWithMissingData <- c("co2Ppm", "co2OneYearAgo", "co2TenYearsAgo", "co2Increase1800")
co2weekly <- cleanfields(co2weekly, fieldsWithMissingData) 
ggplot(data = co2weekly, aes(x = sampledate, y = co2Ppm)) + geom_line() 
~~~
{: .r}

<img src="../fig/rmd-02-func-R-unnamed-chunk-26-1.png" title="plot of chunk unnamed-chunk-26" alt="plot of chunk unnamed-chunk-26" style="display: block; margin: auto;" />

The `-999.99`s that were visible on the plot in episode 1 have now been removed.  `NA`s are shown as gaps in the 
line plotted by `geom_line()`


## Loading temperature data

The `data` directory contains a series of files, which contain hourly weather observations from an observatory.  Let's work through the process of how to load all these files into a single (large) data-set.  There is a file, `met_README` that explains the file naming convention and the format of the data in the files. Take a look at the README file, and at one of the files containing the weather data.

The README file explains that the "Fields in each line are delimited by whitespace." This is the same as the CO2 data,
which suggests we can use `read_table()` to load a file.  The missing data value in the CO2 data was all `-999.99`. The README file states that the missing data for some fields are different from this (for example, the missing value for wind direction is `-999`).

> ## Challenge: What do we need to do?
>
> With the person sat next to you, discuss the process we will need to go through to load and clean all of the 
> files, and output a single tibble containing all their contents.  Don't worry if you don't know how to 
> do all of these tasks in R; the important thing is to thinkg about how we might break the process down into
> smaller chunks.  We can then write a function for each of these chunks, to produce our finished loading process. 
> You may realise that we already have functions that (almost) do what we need.
> 
> > ## Solution
> > 
> > * We will need to process each file in turn.  We know how to loop over a vector of values, using a `for` loop.  We don't *yet* know how to list a series of files that match a pattern
> > 
> > In each file:
> >
> > * We will need to load the data into a tibble.  `readr` comes with lots of functions to do this; we can
> > use `read_table()` as we did with the CO2 data (although the parameters we use will need to be modified as the 
> > variables contained in the data are different).
> > * We will need to clean the data.  We have a function that will do this for a single field, with an arbitrary special value to represent "missing".  Our function to handle more than one field doesn't let us specify anything other than the default missing value from our CO2 data.  But we may be able to extend this function.  
> > * We will need to handle the date and time fields in the data.  We used `lubridate`'s `ymd()` function to 
> > do this with the CO2 data. So we're part way there on this
> > * It would be a good idea to validate the data.  For example, precipitation should be `>=0`, the wind direction 
> > should be between 0 and 359 degrees.
> >
> {: .solution}
{: .challenge}

## Getting started

Let's load one of the weather files into R, using the `read_table()` function, as we already know how to do this.
We'll use the following command, so that we are all using the same variable names (you should copy and paste
this command to save typing):

FIXME? Get participants to generate col_types and check sensible guesses?


~~~
weather <- read_table("data/met_mlo_insitu_1_obop_hour_1977.txt",
                      col_names = c("obs",
                                    "yyyy",
                                    "mm",
                                    "dd",
                                    "hh",
                                    "winddir",
                                    "windspeed",
                                    "windsteadiness",
                                    "pressure",
                                    "temperature2m",
                                    "temperature10m",
                                    "temperaturetop",
                                    "relhumidity",
                                    "precipitation" ),
                      col_types = cols(
                        obs = col_character(),
                        yyyy = col_integer(),
                        mm = col_character(),
                        dd = col_character(),
                        hh = col_character(),
                        winddir = col_integer(),
                        windspeed = col_double(),
                        windsteadiness = col_integer(),
                        pressure = col_double(),
                        temperature2m = col_double(),
                        temperature10m = col_double(),
                        temperaturetop = col_double(),
                        relhumidity = col_integer(),
                        precipitation = col_integer()
                      )
)
~~~
{: .r}

> ## Challenge
>
> Create a new field, `recdate` that contains the date and hour of the observation, stored
> as a `datetime` (this is a special type of data that will let us handle the date and time
> in a similar way to the dates we used with the CO2 data).  
> 
> Hint: Look at the help file for `lubridate`'s `ymd_h()` function
> 
> > ## Solution
> > 
> > ~~~
> > weather <- weather %>% mutate(recdate = lubridate::ymd_h(paste(yyyy,mm,dd,hh)))
> > ~~~
> > {: .r}
> {: .solution}
{: .challenge}


## An improved field cleaning function

Let's deal with making our `cleanfields()` function work with 
something other than the default missing value.   We will need to provide a
way of giving the function a list of variable names *and* the value that we
should treat as missing.

One way of doing this is to provide a named vector of missing values.  We
can assign names to elements of a vector in R:


~~~
missingvalues <- c(winddir = -999, windspeed = -999.9, temperature10m = -999.9)
missingvalues
~~~
{: .r}



~~~
       winddir      windspeed temperature10m 
        -999.0         -999.9         -999.9 
~~~
{: .output}
We can extract the names of the vector using the `names()` function:

~~~
names(missingvalues)
~~~
{: .r}



~~~
[1] "winddir"        "windspeed"      "temperature10m"
~~~
{: .output}

Note that we can also use the `names()` function to set the names of an object:


~~~
myvec <- c(1,2,3)
names(myvec) <- c("a","b","c")
myvec
~~~
{: .r}



~~~
a b c 
1 2 3 
~~~
{: .output}
This approach is easier if we're nameing vectors in a function, for example.  But it makes it easier
to assign names to the wrong elements if you type the two vectors by hand.  In contrast, in the first method it
is clearer *what* the name we're assigning to each element is.

This gives us all the "ingredients" we need to write a function that we can use to clean the weather data.

FIXME - too many concepts in one go for this challenge? Perhaps split into 2 challenges?

> ## Challenge: Cleaning the weather data
> 
> Using the `cleanfields()` function we wrote earlier as a starting point, create a function, `cleanfields2()`
> that will read a named vector of missing values and use these to clean the data.  
> 
> Hint:  There were two different approaches to using `for`:
> 
> ~~~
> for(field in fieldlist){
>   print(field)
> }
> 
> for(i in 1:length(fieldlist)){
>   print(fieldlist[i])
> }
> ~~~
> {: .r}
> 
> You will find it easier to use the second form, since we will need to refer to the positions of the 
> elements in our vector of missing values.
> 
> > ## Solution
> > 
> > One way of solving this challenge is: 
> > 
> > 
> > ~~~
> > cleanfields2 <- function(dataset, missinglist){
> >   
> >   variablenames <- names(missinglist) 
> >   for (i in 1:length(missinglist)) {
> >     variablename = variablenames[i] 
> >     missingval = missinglist[i] 
> >     dataset[[ variablename ]] <- cleanfield(dataset[[ variablename ]], missingvalue = missingval)
> >   }
> >   
> >   return(dataset) 
> > }
> > ~~~
> > {: .r}
> > 
> > We could write this more succinctly, for example using `dataset[[ variablenames[i] ]]` instead of defining the 
> > `variablename` variable on each iteration of the `for` loop.  This is, however, less clear.
> > 
> {: .solution }
{: .challenge }


We now have two functions, `cleanfields()` and `cleanfields2()`, which do almost the same thing.   It would be 
good if we could combine these into a single function, which would call the appropriate version depending on 
whether we gave it a vector of variable names (for `cleanfields()`),  or a vector of named missing values (for `cleanfields2()`)

We need a way of testing whether the vector has names, and a way of doing one thing if it does, and another if it doesn't.  

## if

The `if...else` construct lets us take an action if a condition is true:


~~~
x <- 5

x < 3
~~~
{: .r}



~~~
[1] FALSE
~~~
{: .output}



~~~
if (x < 3) {
  print("x is less than 3") # This isn't executed
}

# Using else is optional
if (x < 3) {
  print("x is less than 3") # This isn't executed
} else {
  print("x is not less than 3")
}
~~~
{: .r}



~~~
[1] "x is not less than 3"
~~~
{: .output}

The condition we test can be anything that evaluates to a single `TRUE` or `FALSE` value.

We can use this to work out which version of our function we want to call.  Using pseudo code:


~~~
cleandataset <- function(dataset, fieldstoclean){
  
  if( fieldstoclean doesn't have names ){
    run cleanfields
  } else {
    run cleanfields2
  }

  return our results
}
~~~
{: .r}

We used the `names()` function to extract the names of a named vector.  Let's look at how we can use
this to generate a condition that evaluates to `TRUE` or `FALSE` depending on whether a vector has names:


~~~
withnames <- c(name1 = 1, name2 = 2.2)
nonames <- c("name1", "name2")

names(withnames) # Will give us the names if there are any
~~~
{: .r}



~~~
[1] "name1" "name2"
~~~
{: .output}



~~~
names(nonames) # Or NULL if there are not
~~~
{: .r}



~~~
NULL
~~~
{: .output}



~~~
# But NULL isn't TRUE (or FALSE)
# We need to use 
is.null(NULL)
~~~
{: .r}



~~~
[1] TRUE
~~~
{: .output}



~~~
# to see whether something is NULL
is.null(c(1,2,3))
~~~
{: .r}



~~~
[1] FALSE
~~~
{: .output}

> ## Challenge: Combining the functions
> 
> Modify the pseudocode above to write a function, `cleandataset(dataset, fieldstoclean)`, that will accept either a list of field names or a named numeric vector, and call the appropriate function `cleanfield()` or `cleanfield2()`
> 
> > ## Solution
> > 
> > 
> > ~~~
> > cleandataset <- function(dataset, fieldstoclean) {
> >   
> >   if ( is.null( names(fieldstoclean)) ) {
> >     cleandata <- cleanfields(dataset, fieldstoclean)
> >   } else {
> >     cleandata <- cleanfields2(dataset, fieldstoclean)
> >   }
> >   
> >   return(cleandata)
> > }
> > 
> > cleandataset(weather, missingvalues)
> > ~~~
> > {: .r}
> > 
> > 
> > 
> > ~~~
> > # A tibble: 8,760 x 15
> >      obs  yyyy    mm    dd    hh winddir windspeed windsteadiness pressure
> >    <chr> <int> <chr> <chr> <chr>   <int>     <dbl>          <int>    <dbl>
> >  1   MLO  1977    01    01    00     140      11.2            100    678.6
> >  2   MLO  1977    01    01    01     140      10.7            100    678.6
> >  3   MLO  1977    01    01    02     140       8.9            100    679.0
> >  4   MLO  1977    01    01    03     140       8.5            100    679.3
> >  5   MLO  1977    01    01    04     140       8.9            100    679.7
> >  6   MLO  1977    01    01    05     140       8.5            100    680.0
> >  7   MLO  1977    01    01    06     140       8.0            100    680.0
> >  8   MLO  1977    01    01    07     140       8.0            100    680.0
> >  9   MLO  1977    01    01    08     140       6.7            100    679.7
> > 10   MLO  1977    01    01    09     140       7.2            100    679.7
> > # ... with 8,750 more rows, and 6 more variables: temperature2m <dbl>,
> > #   temperature10m <lgl>, temperaturetop <dbl>, relhumidity <int>,
> > #   precipitation <int>, recdate <dttm>
> > ~~~
> > {: .output}
> {: .solution }
{: .challenge }

## Processing a file

We now have all the elements we need to load and process a file.  We can:

* Load a file using `read_table()`
* Make the datetime field, using `ymd_h()`
* Clean the data using `cleandataset()`

Let's combine these functions into a single function.  This will take a single argument; the name of the file
it is to read.  


~~~
loadWeatherData <- function(infile){
  # Load in a weather data file
  
weather <- read_table(infile,
                      col_names = c("obs",
                                    "yyyy",
                                    "mm",
                                    "dd",
                                    "hh",
                                    "winddir",
                                    "windspeed",
                                    "windsteadiness",
                                    "pressure",
                                    "temperature2m",
                                    "temperature10m",
                                    "temperaturetop",
                                    "relhumidity",
                                    "precipitation" ),
                      col_types = cols(
                        obs = col_character(),
                        yyyy = col_integer(),
                        mm = col_character(),
                        dd = col_character(),
                        hh = col_character(),
                        winddir = col_integer(),
                        windspeed = col_double(),
                        windsteadiness = col_integer(),
                        pressure = col_double(),
                        temperature2m = col_double(),
                        temperature10m = col_double(),
                        temperaturetop = col_double(),
                        relhumidity = col_integer(),
                        precipitation = col_integer()
                      )
)

  
 weather <- weather %>% mutate(recdate = lubridate::ymd_h(paste(yyyy,mm,dd,hh)))

 missingvalues <- c(winddir = -999,
                    windspeed = -999.9,
                    windsteadiness = -9,
                    pressure = -999.9,
                    temperature2m = -999.9,
                    temperature10m = -999.9,
                    temperaturetop = -999.9,
                    relhumidity = -99,
                    precipitation = -99)
 weather <- cleandataset(weather, missingvalues)

 return(weather)
}

cleanweather <- loadWeatherData("data/met_mlo_insitu_1_obop_hour_2010.txt")
~~~
{: .r}




## Testing our code

We should check our functions are doing what we think they are


~~~
sum(weather$temperature10m == -999.9 )
~~~
{: .r}



~~~
[1] 8760
~~~
{: .output}



~~~
sum(cleanfields2(weather, missingvalues)$temperature10m == -999.9, na.rm = TRUE)
~~~
{: .r}



~~~
[1] 0
~~~
{: .output}

New episode?  


~~~
library(testthat)
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



~~~
expect_equal(cleanfield(c(1,2,-999.99)), c(1,2,NA))
expect_equal(cleanfield(c(1,2,3)), c(1,2,3))
expect_equal(cleanfield(c("a","b","c", "-999.99")), c("a","b","c", NA))

expect_equal(cleanfield(c(1,2,3), missingvalue = 2), c(1,NA,3))

testtibble <- tibble(x = c(1,2,-999.99), y = c(1,2,3))
cleanedtibble <- testtibble
cleanedtibble[["x"]] <- c(1,2,NA)

expect_equal(cleanfields(testtibble, "x"), cleanedtibble)
expect_equal(cleanfields(testtibble, c("x")), cleanedtibble)
~~~
{: .r}

