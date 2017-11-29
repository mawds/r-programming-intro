---
title: "Loading the weather data"
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




In the previous episodes we showed how to create functions, and test that they are working.  In this episode we will use these ideas, and expand on them to load the weather data that you downloaded at the start of the course.  



The `data` directory contains a series of files, which contain hourly weather observations from an observatory.  Let's work through the process of how to load all these files into a single (large) data-set.  There is a file, `met_README` that explains the file naming convention and the format of the data in the files. Take a look at the README file, and at one of the files containing the weather data.

The README file explains that the "Fields in each line are delimited by whitespace." This is the same as the CO2 data,
which suggests we can use `read_table()` to load a file.  The missing data value in the CO2 data was all `-999.99`. The README file states that the missing data for some fields are different from this (for example, the missing value for wind direction is `-999`).

> ## Challenge: What do we need to do?
>
> With the person sat next to you, discuss the process we will need to go through to load and clean all of the 
> files, and output a single tibble containing all their contents.  Don't worry if you don't know how to 
> do all of these tasks in R; the important thing is to thinkg about how we might break the process down into
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

## Removed if section from here
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


## Loading more than one file at once

We have many years of weather data, and we would like to load them into a single tibble.  We can modify our `loadWeatherData()` function to do this.  We already know how to iterate over a vector using a `for` loop.  Let's make an example vector by hand, while we develop the function:


~~~
weatherfiles <- c("data/met_mlo_insitu_1_obop_hour_1977.txt", "data/met_mlo_insitu_1_obop_hour_1978.txt")
~~~
{: .r}

What happens if we try to use this with our existing function?

FIXME - enable before release.  Disabled so whole episode can be run in Rstudio


~~~
cleanweather <- loadWeatherData(weatherfiles)
~~~
{: .r}

FIXME - introduce debugger here?

We need to modify our fuction to loop over each element of the vector, and load the corresponding file:



~~~
loadWeatherData <- function(infiles){
  # Load in a weather data file
  
  for (infile in infiles) {  
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
  }
  return(weather)
}
~~~
{: .r}



~~~
cleanweather <- loadWeatherData(weatherfiles)
~~~
{: .r}

That looks like it's worked; but what does our `cleanweather` data set contain?


~~~
cleanweather %>%  
 group_by(yyyy) %>% 
 count()  
~~~
{: .r}



~~~
# A tibble: 1 x 2
# Groups:   yyyy [1]
   yyyy     n
  <int> <int>
1  1978  8760
~~~
{: .output}

We only have data for the most recent year that we read in.  This is because the `weather` data-set gets overwritten each time we run through the `for` loop.  Let's modify the function so that we append the current year's data to a tibble that we define out of the loop.


~~~
loadWeatherData <- function(infiles){
  # Load in a weather data file
  allweather <- NULL
  for (infile in infiles) {  
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
                       windspeed = -99.9, ## Some records use this as missing
                       windsteadiness = -9,
                       pressure = -999.9,
                       temperature2m = -999.9,
                       temperature10m = -999.9,
                       temperaturetop = -999.9,
                       relhumidity = -99,
                       precipitation = -99)
    weather <- cleandataset(weather, missingvalues)
    
    
    
    allweather <- bind_rows(allweather, weather)
  }
  return(allweather)
}
~~~
{: .r}





~~~
cleanweather <- loadWeatherData(weatherfiles)
~~~
{: .r}



~~~
cleanweather %>%  
 group_by(yyyy) %>% 
 count()  
~~~
{: .r}



~~~
# A tibble: 2 x 2
# Groups:   yyyy [2]
   yyyy     n
  <int> <int>
1  1977  8760
2  1978  8760
~~~
{: .output}

So we can now pass more than one file to our `loadWeatherData` function.   Rather than type all the files in, we
can use the `list.files()` function to generate the vector of filenames:


~~~
weatherfiles <- list.files(path="./data", "met_mlo_ins*",full.names=TRUE)
cleanweather <- loadWeatherData(weatherfiles)
cleanweather %>%  
 group_by(yyyy) %>% 
 count()  %>% print(n=inf)
~~~
{: .r}



~~~
Error in typeof(x): object 'inf' not found
~~~
{: .error}

Are we missing data?


~~~
cleanweather %>%  
 group_by(yyyy, mm, dd) %>% 
 count()  %>% print(n=inf) %>% 
  filter(n != 24)
~~~
{: .r}



~~~
Error in typeof(x): object 'inf' not found
~~~
{: .error}


~~~
ggplot(data = cleanweather, aes(x=recdate, y=temperature2m) ) + geom_line()
~~~
{: .r}

<img src="../fig/rmd-04-weather-R-unnamed-chunk-26-1.png" title="plot of chunk unnamed-chunk-26" alt="plot of chunk unnamed-chunk-26" style="display: block; margin: auto;" />


~~~
cleanweather %>% filter(yyyy == 2010) %>% mutate(dayinyear = yday(recdate)) %>% 
  ggplot(aes(x=hh, y=dayinyear, fill = temperature2m)) + geom_raster()
~~~
{: .r}

<img src="../fig/rmd-04-weather-R-unnamed-chunk-27-1.png" title="plot of chunk unnamed-chunk-27" alt="plot of chunk unnamed-chunk-27" style="display: block; margin: auto;" />



~~~
cleanweather %>% filter(temperature2m > 80)
~~~
{: .r}



~~~
# A tibble: 1,765 x 15
     obs  yyyy    mm    dd    hh winddir windspeed windsteadiness pressure
   <chr> <int> <chr> <chr> <chr>   <int>     <dbl>          <int>    <dbl>
 1   MLO  1977    05    20    19     350       2.2            100    681.7
 2   MLO  1977    05    20    20     300       3.1            100    681.7
 3   MLO  1977    05    21    11     130      13.9            100    680.3
 4   MLO  1977    05    21    12     140       8.9            100    680.7
 5   MLO  1977    05    21    13     180       0.0             NA    680.0
 6   MLO  1977    05    21    14     130       9.4            100    680.0
 7   MLO  1977    05    21    15     130       8.5            100    680.3
 8   MLO  1977    05    21    16     130      10.7            100    680.7
 9   MLO  1977    05    21    17     120      11.2            100    681.0
10   MLO  1977    05    21    18     115      11.2            100    681.0
# ... with 1,755 more rows, and 6 more variables: temperature2m <dbl>,
#   temperature10m <dbl>, temperaturetop <dbl>, relhumidity <int>,
#   precipitation <int>, recdate <dttm>
~~~
{: .output}



~~~
cleanweather %>% filter(windspeed < 0)
~~~
{: .r}



~~~
# A tibble: 0 x 15
# ... with 15 variables: obs <chr>, yyyy <int>, mm <chr>, dd <chr>,
#   hh <chr>, winddir <int>, windspeed <dbl>, windsteadiness <int>,
#   pressure <dbl>, temperature2m <dbl>, temperature10m <dbl>,
#   temperaturetop <dbl>, relhumidity <int>, precipitation <int>,
#   recdate <dttm>
~~~
{: .output}



~~~
cleanweather %>% filter(pressure < 0)
~~~
{: .r}



~~~
# A tibble: 0 x 15
# ... with 15 variables: obs <chr>, yyyy <int>, mm <chr>, dd <chr>,
#   hh <chr>, winddir <int>, windspeed <dbl>, windsteadiness <int>,
#   pressure <dbl>, temperature2m <dbl>, temperature10m <dbl>,
#   temperaturetop <dbl>, relhumidity <int>, precipitation <int>,
#   recdate <dttm>
~~~
{: .output}



~~~
cleanweather %>% filter(winddir < 0 | winddir > 360) # Recode 360s to 0s?
~~~
{: .r}



~~~
# A tibble: 3,141 x 15
     obs  yyyy    mm    dd    hh winddir windspeed windsteadiness pressure
   <chr> <int> <chr> <chr> <chr>   <int>     <dbl>          <int>    <dbl>
 1   MLO  1977    02    17    18     999      99.9             NA    679.0
 2   MLO  1977    02    18    05     999      99.9             NA    678.6
 3   MLO  1977    02    18    08     999      99.9             NA    680.3
 4   MLO  1977    02    18    14     999      99.9             NA    678.6
 5   MLO  1977    02    20    04     999      99.9             NA    682.0
 6   MLO  1977    02    20    05     999      99.9             NA    682.4
 7   MLO  1977    02    20    06     999      99.9             NA    682.7
 8   MLO  1977    02    20    07     999      99.9             NA    682.7
 9   MLO  1977    02    20    08     999      99.9             NA    682.7
10   MLO  1977    02    20    09     999      99.9             NA    682.7
# ... with 3,131 more rows, and 6 more variables: temperature2m <dbl>,
#   temperature10m <dbl>, temperaturetop <dbl>, relhumidity <int>,
#   precipitation <int>, recdate <dttm>
~~~
{: .output}

Something has gone wrong...  challenge is working out what.  Need to use read_table2() or read_table(guess_max = Inf)




