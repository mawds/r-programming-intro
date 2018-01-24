---
title: "Debugging code"
teaching: 30
exercises: 0
questions:
- "How do we find (and fix) bugs in our code?"
objectives:
- "To be familiar with debugging techniques and the RStudio debugger"
keypoints:
- "We can use the `print()` function to work out what our code is doing"
- "The debugger lets us set breakpoints within our functions, to inspect what is happening"

---




In the previous episodes we showed how to create functions, and test that they are working.  In this episode we will use these ideas, and expand on them to load the weather data that you downloaded at the start of the course. We'll use the process of loading the data to build on the programming constructs (such as `for` loops and `if...else`) statements that we've introduced so far.   

We'll also spend some time on how to debug your program.  Although this may seem somewhat pessimistic, the
reality is that nobody's code works first time.  By learning about the tools needed to debug our code we
can save ourselves a great deal of time and frustration.

The `data` directory contains a series of files, which contain hourly weather observations from an observatory.  Let's work through the process of how to load all these files into a single (large) data-set.  There is a file, `met_README` that explains the file naming convention and the format of the data in the files. Take a look at the README file, and at one of the files containing the weather data.

The README file explains that the "Fields in each line are delimited by whitespace." This is the same as the CO2 data,
which suggests we can use `read_table()` to load a file.  The missing data value in the CO2 data was all `-999.99`. The README file states that the missing data for some fields are different from this (for example, the missing value for wind direction is `-999`).

> ## Challenge: What do we need to do?
> 
> With the person sat next to you, discuss the process we will need to go through to load and clean all of the 
> files, and output a single tibble containing all their contents.  Don't worry if you don't know how to 
> do all of these tasks in R; the important thing is to think about how we might break the process down into
> smaller chunks.  We can then write a function for each of these chunks, to produce our finished loading process. 
> You may realise that we already have functions that (almost) do what we need for some of these tasks.
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
> > We will also need to know how combine the weather files that we have loaded into a single file.
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
{: .language-r}

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
> > {: .language-r}
> {: .solution}
{: .challenge}


## An improved field cleaning function

In contrast to the CO2 data, the value used to represent missing data depends on the 
field.   Let's modify our `cleanfields()` function so that we can (optionally) specify
the missing value we want to use for each field.

We will need to provide a
way of giving the function a list of variable names *and* the value that we
should treat as missing.

One way of doing this is to provide a named vector of missing values.  We
can assign names to elements of a vector in R:


~~~
missingvalues <- c(winddir = -999, windspeed = -999.9, temperature10m = -999.9)
missingvalues
~~~
{: .language-r}



~~~
       winddir      windspeed temperature10m 
        -999.0         -999.9         -999.9 
~~~
{: .output}
We can extract the names of the vector using the `names()` function:

~~~
names(missingvalues)
~~~
{: .language-r}



~~~
[1] "winddir"        "windspeed"      "temperature10m"
~~~
{: .output}


> ## More on `names()`
> 
> In addition to getting the names of an object, we can also use the `names()` function to set the names of an object:
> 
> 
> ~~~
> myvec <- c(1,2,3)
> names(myvec) <- c("a","b","c")
> myvec
> ~~~
> {: .language-r}
> 
> 
> 
> ~~~
> a b c 
> 1 2 3 
> ~~~
> {: .output}
{: .callout}


Let's modify our function so that it calls `cleanfield()` with its default `missingvalue` argument if our vector of fields
to clean doesn't have names, and calls `cleanfield()` with the appropriate missing value if we have specified names.

As we have already written tests to check that `cleanfields()` works properly, we can modify our function knowing that
if we break anything, this should be revealed in the tests we have written.  

In pseudo-code, this is what we want to do:


```

cleanfields <- function(dataset, fieldlist){
  
  if( fieldstoclean doesn't have names ){
    run existing code
  } else {
    clean the fields according to the values passed and their names
  }

  return our results
}

```

There are two things we will need to figure out:

1. How to test whether `fieldstoclean` has names
2. How to write the code that will be executed if `fieldstoclean` has names


We used the `names()` function to extract the names of a named vector.  Let's look at how we can use
this to generate a condition that evaluates to `TRUE` or `FALSE` depending on whether a vector has names:


~~~
withnames <- c(name1 = 1, name2 = 2.2)
nonames <- c("name1", "name2")

names(withnames) # Will give us the names if there are any
~~~
{: .language-r}



~~~
[1] "name1" "name2"
~~~
{: .output}



~~~
names(nonames) # Or NULL if there are not
~~~
{: .language-r}



~~~
NULL
~~~
{: .output}

This gets us most of the way there; but there is a problem.  Usually we can test if values are equal to each other using
`==` ( or `all.equal()` if we're dealing with floating point numbers).  This doesn't work for "special" values, like `NULL`, `NA`
and `Inf`:

~~~
x <- NULL
# But NULL isn't TRUE (or FALSE)
x == NULL
~~~
{: .language-r}



~~~
logical(0)
~~~
{: .output}



~~~
# We need to use:
is.null(NULL)
~~~
{: .language-r}



~~~
[1] TRUE
~~~
{: .output}

> ## Indenting your code
> 
> As our code becomes more complex, keeping it tidy becomes increasingly important.  One way of doing this is
> by indenting your code, so that everything at the same "level", e.g. everything that will be executed `if` a condition is
> true, has the same indent. RStudio performs this indentation for you automatically.  You may find it gets out of sync
> as you edit and move your blocks of code around.  To re-indent your code, select it and press <kbd>Ctrl</kbd>+<kbd>I</kbd>.
> 
> RStudio will highlight the other half of quotes, brackets, and braces which can be very helpful if you forget to close a string, function or block of code.
> 
{: .callout}

> ## Challenge:  Testing whether we have names
> 
> Modify your `cleanfields()` function to test whether `fieldlist` has  names.  If it does not
> you should use your existing code to clean the fields.  If it does have names you should
> stop the function (we will write the code to clean the data when we have names and values in the 
> next challenge)
> 
> When you have written your function, you should test it still works using the tests we wrote earlier.
> 
> > ## Solution
> > 
> > ~~~
> > function(dataset, fieldlist) {
> >   if (is.null(names(fieldlist))) {
> >     if (!all(fieldlist %in% names(dataset))) {
> >       stop("Attempting to clean variables that do not exist in the dataset")
> >     }
> >     
> >     if (anyDuplicated(fieldlist) != 0) {
> >       warning("Duplicated variable names specified")
> >     }
> >     
> >     
> >     for (f in fieldlist) {
> >       dataset[[f]] <- cleanfield(dataset[[f]])
> >     }
> >     
> >   } else {
> >     stop("Not yet implemented")
> >   }
> >   
> >   return(dataset)
> >   
> > }
> > ~~~
> > {: .language-r}
> > 
> > 
> > 
> > ~~~
> > function(dataset, fieldlist) {
> >   if (is.null(names(fieldlist))) {
> >     if (!all(fieldlist %in% names(dataset))) {
> >       stop("Attempting to clean variables that do not exist in the dataset")
> >     }
> >     
> >     if (anyDuplicated(fieldlist) != 0) {
> >       warning("Duplicated variable names specified")
> >     }
> >     
> >     
> >     for (f in fieldlist) {
> >       dataset[[f]] <- cleanfield(dataset[[f]])
> >     }
> >     
> >   } else {
> >     stop("Not yet implemented")
> >   }
> >   
> >   return(dataset)
> >   
> > }
> > ~~~
> > {: .output}
> {: .solution}
{: .challenge}


We should now write the final part of the function.   We will need to loop over each element of the named `fieldlist`
vector 


> ## Challenge: Cleaning the weather data
> 
> Modify your function to implement the missing functionality.
> 
> > ## Hint - for loops:
> > 
> > There were two different approaches to using `for`:
> > 
> > ~~~
> > for(field in fieldlist){
> >   print(field)
> > }
> > 
> > for(i in 1:seq_along(fieldlist)){
> >   print(fieldlist[i])
> > }
> > ~~~
> > {: .language-r}
> >  
> > You will find it easier to use the second form, since we will need to refer to the positions of the 
> > elements in our vector of missing values.
> > 
> {: .solution}
> 
> > ## Solution
> > 
> > One way of solving this challenge is: 
> > 
> > 
> > ~~~
> > cleanfields <- function(dataset, fieldlist){
> >   
> >   if ( is.null(names(fieldlist)) ) {
> >     
> >     if ( !all(fieldlist %in% names(dataset)) ) {
> >       stop("Attempting to clean variables that do not exist in the dataset")
> >     }
> >     
> >     if ( anyDuplicated(fieldlist) != 0 ) {
> >       warning("Duplicated variable names specified")
> >     }
> >     
> >     for (f in fieldlist) {
> >       dataset[[f]] <- cleanfield(dataset[[f]])
> >     }
> >     
> >   } else {
> >     
> >     variablenames <- names(fieldlist) 
> >     for (i in 1:seq_along(fieldlist)) {
> >       
> >       variablename <- variablenames[i] 
> >       missingval <- fieldlist[i] 
> >       
> >       dataset[[ variablename ]] <- cleanfield(dataset[[ variablename ]], missingvalue = missingval)
> >       
> >     } 
> >   }
> >   
> >   return(dataset) 
> >   
> > }
> > ~~~
> > {: .language-r}
> > 
> > We could write this more succinctly, for example using `dataset[[ variablenames[i] ]]` instead of defining the 
> > `variablename` variable on each iteration of the `for` loop.  This is, however, less clear.
> > 
> > One thing you may notice is that we don't now test whether the variables exist if we're using 
> > our new approach to cleaning the data.  This is not ideal; if there was more time we would 
> > write a test for this, and then modify the code implement the required functionality.
> > 
> > As the function is written, this would mean we would be testing for variable names in two places, 
> > which isn't ideal - there would then be places for our code to go wrong.  A better approach might be 
> > to test whether our input variable has names.  If it does not, we could generate a named vector with the 
> > default missing value.  
> > 
> > Because we've written tests for our function, we can modify it confidently, knowing that if we break anything
> > the tests will tell us.
> > 
> {: .solution}
{: .challenge}




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
  weather <- cleanfields(weather, missingvalues)
  
  return(weather)
}

cleanweather <- loadWeatherData("data/met_mlo_insitu_1_obop_hour_1977.txt")
~~~
{: .language-r}

## Checking our load has worked

The `summary()` function will show us summary statistics for each variable in a data-set.  Let's use this to
check that our data looks reasonable:
The summary shows that some variables, e.g. `winddir` have large, positive values:


~~~
summary(cleanweather)
~~~
{: .language-r}



~~~
     obs                 yyyy           mm                 dd           
 Length:8760        Min.   :1977   Length:8760        Length:8760       
 Class :character   1st Qu.:1977   Class :character   Class :character  
 Mode  :character   Median :1977   Mode  :character   Mode  :character  
                    Mean   :1977                                        
                    3rd Qu.:1977                                        
                    Max.   :1977                                        
                                                                        
      hh               winddir        windspeed     windsteadiness
 Length:8760        Min.   :  0.0   Min.   : 0.00   Min.   :100   
 Class :character   1st Qu.:120.0   1st Qu.: 2.70   1st Qu.:100   
 Mode  :character   Median :170.0   Median : 4.50   Median :100   
                    Mean   :229.9   Mean   :11.78   Mean   :100   
                    3rd Qu.:270.0   3rd Qu.: 7.60   3rd Qu.:100   
                    Max.   :999.0   Max.   :99.90   Max.   :100   
                                                    NA's   :823   
    pressure     temperature2m    temperature10m temperaturetop
 Min.   :673.9   Min.   :-4.400   Mode:logical   Mode:logical  
 1st Qu.:679.3   1st Qu.: 4.100   NA's:8760      NA's:8760     
 Median :680.7   Median : 6.700                                
 Mean   :680.5   Mean   : 7.669                                
 3rd Qu.:681.7   3rd Qu.:10.000                                
 Max.   :685.1   Max.   :99.900                                
 NA's   :18                                                    
  relhumidity     precipitation     recdate                   
 Min.   :  7.00   Mode:logical   Min.   :1977-01-01 00:00:00  
 1st Qu.: 20.00   NA's:8760      1st Qu.:1977-04-02 05:45:00  
 Median : 34.00                  Median :1977-07-02 11:30:00  
 Mean   : 40.79                  Mean   :1977-07-02 11:30:00  
 3rd Qu.: 58.00                  3rd Qu.:1977-10-01 17:15:00  
 Max.   :100.00                  Max.   :1977-12-31 23:00:00  
 NA's   :118                                                  
~~~
{: .output}

It looks like the cleaning process hasn't worked properly!   We've tested our `cleanfields()` function, so we can be reasonably confident that is working properly (it's possible that something has gone wrong that we *haven't* tested for).  So what's going on?
## Hunting bugs

Hunting a bug down can be very difficult.   They're often "obvious" once you've found them (it's often the case that the more "obvious" the bug the longer it takes to find).  There are a number of techniques we can use to help us:

* We can print out statements (using `print()` so we know which bits of code are being run)
* We can use a debugger to pause the program execution and look at the values of variables _within_ the function


Take a look at our `loadWeatherData()` function; it does two main things: loads the data and cleans it (it also creates the `recdate` field - but that looks OK in our summary).  We'd like to know what the `weather` tibble looks like once we've read it in, but _before_ we've cleaned it - we can use this to help work out whether the problem is with the data itself (i.e. the file doesn't conform to the specificiation), our loading the data or our cleaning of the data.

Find the line in your code where we generate the `recdate` field, and click to the left of the line number, as shown below:  You should find a red circle appears next to the line.  This creates a breakpoint.  If we run the code again, 

![Debugger screenshot](../fig/debugger.png)

When we run the code again, by pressing <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Enter</kbd>, it will stop on the selected line _before it is executed_.  We can look at the contents of the weather tibble by entering its name in the console window.  

> ## Challenge
> 
> Use the `summary()` function (or other methods of your choice) to work out whether the problem is with our cleaning function or with what's being read in.  If there are problems with what's being read in, find a record which appears to be incorrect (perhaps uing, `filter()`).  Take a look at the raw data-file to establish whether the problem is with our _reading in_ of the data, or the data itself.
> 
> > ## Solution
> > 
> >  Within the debugger, setting a breakpoint as described in the text, 
> >  we obtain:
> > 
> > 
> > 
> > 
> > ~~~
> > summary(weather)
> > ~~~
> > {: .language-r}
> > 
> > 
> > 
> > ~~~
> >      obs                 yyyy           mm                 dd           
> >  Length:8760        Min.   :1977   Length:8760        Length:8760       
> >  Class :character   1st Qu.:1977   Class :character   Class :character  
> >  Mode  :character   Median :1977   Mode  :character   Mode  :character  
> >                     Mean   :1977                                        
> >                     3rd Qu.:1977                                        
> >                     Max.   :1977                                        
> >       hh               winddir        windspeed     windsteadiness  
> >  Length:8760        Min.   :  0.0   Min.   : 0.00   Min.   : -9.00  
> >  Class :character   1st Qu.:120.0   1st Qu.: 2.70   1st Qu.:100.00  
> >  Mode  :character   Median :170.0   Median : 4.50   Median :100.00  
> >                     Mean   :229.9   Mean   :11.78   Mean   : 89.76  
> >                     3rd Qu.:270.0   3rd Qu.: 7.60   3rd Qu.:100.00  
> >                     Max.   :999.0   Max.   :99.90   Max.   :100.00  
> >     pressure      temperature2m    temperature10m   temperaturetop  
> >  Min.   :-999.9   Min.   :-4.400   Min.   :-999.9   Min.   :-999.9  
> >  1st Qu.: 679.3   1st Qu.: 4.100   1st Qu.:-999.9   1st Qu.:-999.9  
> >  Median : 680.7   Median : 6.700   Median :-999.9   Median :-999.9  
> >  Mean   : 677.1   Mean   : 7.669   Mean   :-999.9   Mean   :-999.9  
> >  3rd Qu.: 681.7   3rd Qu.:10.000   3rd Qu.:-999.9   3rd Qu.:-999.9  
> >  Max.   : 685.1   Max.   :99.900   Max.   :-999.9   Max.   :-999.9  
> >   relhumidity    precipitation
> >  Min.   :-99.0   Min.   :-99  
> >  1st Qu.: 19.0   1st Qu.:-99  
> >  Median : 34.0   Median :-99  
> >  Mean   : 38.9   Mean   :-99  
> >  3rd Qu.: 58.0   3rd Qu.:-99  
> >  Max.   :100.0   Max.   :-99  
> > ~~~
> > {: .output}
> > 
> > As we're looking at the data _before_ cleaning it, we see the large negative values that are used to represent missing data.
> > We also see that some variables have the large positive values we saw before.  This suggests the problem is with our loading of the data, or the data itself. We can find a problematic record
> > by filtering the tibble:
> > 
> > 
> > ~~~
> > weather %>% filter(winddir == 999)
> > ~~~
> > {: .language-r}
> > 
> > 
> > 
> > ~~~
> > # A tibble: 631 x 14
> >      obs  yyyy    mm    dd    hh winddir windspeed windsteadiness pressure
> >    <chr> <int> <chr> <chr> <chr>   <int>     <dbl>          <int>    <dbl>
> >  1   MLO  1977    02    17    18     999      99.9             -9    679.0
> >  2   MLO  1977    02    18    05     999      99.9             -9    678.6
> >  3   MLO  1977    02    18    08     999      99.9             -9    680.3
> >  4   MLO  1977    02    18    14     999      99.9             -9    678.6
> >  5   MLO  1977    02    20    04     999      99.9             -9    682.0
> >  6   MLO  1977    02    20    05     999      99.9             -9    682.4
> >  7   MLO  1977    02    20    06     999      99.9             -9    682.7
> >  8   MLO  1977    02    20    07     999      99.9             -9    682.7
> >  9   MLO  1977    02    20    08     999      99.9             -9    682.7
> > 10   MLO  1977    02    20    09     999      99.9             -9    682.7
> > # ... with 621 more rows, and 5 more variables: temperature2m <dbl>,
> > #   temperature10m <dbl>, temperaturetop <dbl>, relhumidity <int>,
> > #   precipitation <int>
> > ~~~
> > {: .output}
> > 
> > Let's look at the data file:
> > 
> > 
> > ~~~
> > MLO 1977 02 17 18 -999 -99.9  -9  679.00    7.2 -999.9 -999.9  17 -99
> > ~~~
> > {: .language-r}
> > 
> > The data look like they are correct; the "missing" values are negative; something has gone wrong with how we're reading in the data.
> > 
> {: .solution}
{: .challenge}

In the challenge we deduced that the issue was with how the `read_table()` function is reading the data in.  

Take a look a the help file for `read_table()` - it shows that there is also a function `read_table2()`, which "is like read.table(), [but] it allows any number of whitespace characters between columns, and the lines can be of different lengths."

Let's try this:


~~~
loadWeatherData <- function(infile){
  # Load in a weather data file
  
  weather <- read_table2(infile,
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
  weather <- cleanfields(weather, missingvalues)
  
  return(weather)
}

cleanweather <- loadWeatherData("data/met_mlo_insitu_1_obop_hour_1977.txt")
summary(cleanweather)
~~~
{: .language-r}



~~~
     obs                 yyyy           mm                 dd           
 Length:8760        Min.   :1977   Length:8760        Length:8760       
 Class :character   1st Qu.:1977   Class :character   Class :character  
 Mode  :character   Median :1977   Mode  :character   Mode  :character  
                    Mean   :1977                                        
                    3rd Qu.:1977                                        
                    Max.   :1977                                        
                                                                        
      hh               winddir        windspeed       windsteadiness
 Length:8760        Min.   :  0.0   Min.   :-99.900   Min.   :100   
 Class :character   1st Qu.:110.0   1st Qu.:  2.200   1st Qu.:100   
 Mode  :character   Median :160.0   Median :  4.000   Median :100   
                    Mean   :170.2   Mean   : -2.615   Mean   :100   
                    3rd Qu.:230.0   3rd Qu.:  6.300   3rd Qu.:100   
                    Max.   :360.0   Max.   : 19.200   Max.   :100   
                    NA's   :631                       NA's   :823   
    pressure     temperature2m    temperature10m temperaturetop
 Min.   :673.9   Min.   :-4.400   Mode:logical   Mode:logical  
 1st Qu.:679.3   1st Qu.: 4.000   NA's:8760      NA's:8760     
 Median :680.7   Median : 6.700                                
 Mean   :680.5   Mean   : 6.926                                
 3rd Qu.:681.7   3rd Qu.: 9.600                                
 Max.   :685.1   Max.   :17.400                                
 NA's   :18      NA's   :70                                    
  relhumidity     precipitation     recdate                   
 Min.   :  7.00   Mode:logical   Min.   :1977-01-01 00:00:00  
 1st Qu.: 20.00   NA's:8760      1st Qu.:1977-04-02 05:45:00  
 Median : 34.00                  Median :1977-07-02 11:30:00  
 Mean   : 40.79                  Mean   :1977-07-02 11:30:00  
 3rd Qu.: 58.00                  3rd Qu.:1977-10-01 17:15:00  
 Max.   :100.00                  Max.   :1977-12-31 23:00:00  
 NA's   :118                                                  
~~~
{: .output}

This looks much better, with the exception of the windspeed data, which has `-99.9` as its minimum.  If we check back to the original data, it looks like they are using this as their "missing" value for windspeed, and not `-999.9` as it says in the README.

> ## Challenge:  Our final loading function
> 
> Modify your `loadWeatherData()` function so that it uses `read_table2()` and uses the correct
> value for the missing wind speeds.   You should make sure you put a comment in your function
> explaining why this is _different_ to the missing value specified in the README.  Check your data 
> look sensible using the `summary()` function
> 
> > ## Solution
> > 
> > 
> > ~~~
> > loadWeatherData <- function(infile){
> >   # Load in a weather data file
> >   
> >   weather <- read_table2(infile,
> >                         col_names = c("obs",
> >                                       "yyyy",
> >                                       "mm",
> >                                       "dd",
> >                                       "hh",
> >                                       "winddir",
> >                                       "windspeed",
> >                                       "windsteadiness",
> >                                       "pressure",
> >                                       "temperature2m",
> >                                       "temperature10m",
> >                                       "temperaturetop",
> >                                       "relhumidity",
> >                                       "precipitation" ),
> >                         col_types = cols(
> >                           obs = col_character(),
> >                           yyyy = col_integer(),
> >                           mm = col_character(),
> >                           dd = col_character(),
> >                           hh = col_character(),
> >                           winddir = col_integer(),
> >                           windspeed = col_double(),
> >                           windsteadiness = col_integer(),
> >                           pressure = col_double(),
> >                           temperature2m = col_double(),
> >                           temperature10m = col_double(),
> >                           temperaturetop = col_double(),
> >                           relhumidity = col_integer(),
> >                           precipitation = col_integer()
> >                         )
> >   )
> >   
> >   
> >   weather <- weather %>% mutate(recdate = lubridate::ymd_h(paste(yyyy,mm,dd,hh)))
> >   
> >   missingvalues <- c(winddir = -999,
> >                      windspeed = -99.9, # Was given as -999.9 in met_README
> >                      windsteadiness = -9,
> >                      pressure = -999.9,
> >                      temperature2m = -999.9,
> >                      temperature10m = -999.9,
> >                      temperaturetop = -999.9,
> >                      relhumidity = -99,
> >                      precipitation = -99)
> >   weather <- cleanfields(weather, missingvalues)
> >   
> >   return(weather)
> > }
> > 
> > cleanweather <- loadWeatherData("data/met_mlo_insitu_1_obop_hour_1977.txt")
> > summary(cleanweather)
> > ~~~
> > {: .language-r}
> > 
> > 
> > 
> > ~~~
> >      obs                 yyyy           mm                 dd           
> >  Length:8760        Min.   :1977   Length:8760        Length:8760       
> >  Class :character   1st Qu.:1977   Class :character   Class :character  
> >  Mode  :character   Median :1977   Mode  :character   Mode  :character  
> >                     Mean   :1977                                        
> >                     3rd Qu.:1977                                        
> >                     Max.   :1977                                        
> >                                                                         
> >       hh               winddir        windspeed      windsteadiness
> >  Length:8760        Min.   :  0.0   Min.   : 0.000   Min.   :100   
> >  Class :character   1st Qu.:110.0   1st Qu.: 2.700   1st Qu.:100   
> >  Mode  :character   Median :160.0   Median : 4.000   Median :100   
> >                     Mean   :170.2   Mean   : 4.937   Mean   :100   
> >                     3rd Qu.:230.0   3rd Qu.: 6.700   3rd Qu.:100   
> >                     Max.   :360.0   Max.   :19.200   Max.   :100   
> >                     NA's   :631     NA's   :631      NA's   :823   
> >     pressure     temperature2m    temperature10m temperaturetop
> >  Min.   :673.9   Min.   :-4.400   Mode:logical   Mode:logical  
> >  1st Qu.:679.3   1st Qu.: 4.000   NA's:8760      NA's:8760     
> >  Median :680.7   Median : 6.700                                
> >  Mean   :680.5   Mean   : 6.926                                
> >  3rd Qu.:681.7   3rd Qu.: 9.600                                
> >  Max.   :685.1   Max.   :17.400                                
> >  NA's   :18      NA's   :70                                    
> >   relhumidity     precipitation     recdate                   
> >  Min.   :  7.00   Mode:logical   Min.   :1977-01-01 00:00:00  
> >  1st Qu.: 20.00   NA's:8760      1st Qu.:1977-04-02 05:45:00  
> >  Median : 34.00                  Median :1977-07-02 11:30:00  
> >  Mean   : 40.79                  Mean   :1977-07-02 11:30:00  
> >  3rd Qu.: 58.00                  3rd Qu.:1977-10-01 17:15:00  
> >  Max.   :100.00                  Max.   :1977-12-31 23:00:00  
> >  NA's   :118                                                  
> > ~~~
> > {: .output}
> > 
> {: .solution}
{: .challenge} 


It (finally) looks like we've read the data in successfully.   

Although this has been quite a protracted
episode it highlights some of the typical problems you will come accross when dealing with real-life data.  We've spent a lot of time on looking at how to work out what's gone wrong, and how to fix it, using a combination of testing and debugging.   It's quite normal to spend a lot of time on these aspects of programming; this is fine.



