---
title: Functions and dplyr
teaching: 45
exercises: 15
questions:
- "How do we write functions that work with dplyr?"
objectives:
- "Understand the benefits and drawbacks of non standard evaluation"
keypoints:
- "FIXME - keypoints go here"
source: Rmd
---







A lot of the "cleverness" of the tidyverse comes from how it handles the values we pass to its functions.
This lets us write code in a very expressive way (for example, the idea of treating the dplyr
pipelines as a sentence consisting of a series of verbs, with the `%>%` operator being read as "and then".)

Unfortunately this comes at a price when we come to use `dplyr` in our own functions.  The `dplyr` functions use what is known as "Non Standard Evaluation"; this means that they don't evaluate their parameters in the standard way that the examples in this episode have used so far.  This is probably the most complicted concept we will cover today, so pleae don't worry if you don't "get" it at first attempt. 

We'll illustrate this by way of an example.

Let's write a function that will filter our weather data to only keep observations when it is both warm (which we'll define as at least 18 degrees C), and windy (which we'll define as a wind speed of at least 6m/s).
First, let's think about how we'd do this *without* using a function.  We'll then put our 
code in a function; this will let us easily repeat the calculation for other years, without re-writing the code.


~~~
warmWindy <- cleanweather %>% 
  filter(windspeed >= 6, temperature2m >= 18)
~~~
{: .language-r}

Let's put this code in a function; note that we change the input data to be the parameter we pass when we call
the function (it's _really_ easy to forget to make these changes when you start making functions from existing code):


~~~
getWarmWindyObservations <- function(indata, windspeed = 6, temperature2m = 18){
  
  warmWindy <- indata %>% 
    filter(windspeed >= windspeed, temperature2m >= temperature2m)
  
  return(warmWindy)
  
}
~~~
{: .language-r}

But if we run this function, it doesn't do what we'd expect:


~~~
getWarmWindyObservations(cleanweather)
~~~
{: .language-r}



~~~
# A tibble: 324,813 x 15
     obs  yyyy    mm    dd    hh winddir windspeed windsteadiness pressure
   <chr> <int> <chr> <chr> <chr>   <int>     <dbl>          <int>    <dbl>
 1   MLO  1977    01    01    00     140      11.2            100    678.6
 2   MLO  1977    01    01    01     140      10.7            100    678.6
 3   MLO  1977    01    01    02     140       8.9            100    679.0
 4   MLO  1977    01    01    03     140       8.5            100    679.3
 5   MLO  1977    01    01    04     140       8.9            100    679.7
 6   MLO  1977    01    01    05     140       8.5            100    680.0
 7   MLO  1977    01    01    06     140       8.0            100    680.0
 8   MLO  1977    01    01    07     140       8.0            100    680.0
 9   MLO  1977    01    01    08     140       6.7            100    679.7
10   MLO  1977    01    01    09     140       7.2            100    679.7
# ... with 324,803 more rows, and 6 more variables: temperature2m <dbl>,
#   temperature10m <dbl>, temperaturetop <dbl>, relhumidity <int>,
#   precipitation <int>, recdate <dttm>
~~~
{: .output}

All of our data is returned.

Look at the line: 


~~~
    filter(windspeed >= windspeed, temperature2m >= temperature2m) %>% 
~~~
{: .language-r}

We passed the values of `windspeed` and `temperature2m` into the function when we called it.  R has no way of knowing we're referring to the function parameter's `windspeed` and `temperature2m` variables rather than the tibble's `windspeed` and `temperature2m` variables.     We run into this problem because of dplyr's "Non Standard Evaluation" (NSE); this means that the functions don't follow R's usual rules about how parameters are evaluated.  

NSE is usually really useful; when we've written things like `cleanweather %>% select(recdate, tempeature2m)` we've made use of non standard evaluation.  This is much more intuitive than the base R equivalent, where we'd have to write something like `cleanweather[, names(cleanweather) %in% c("recdate", "temperature2m")]`. Non standard evaluation lets the `select()` function work out that we're referring to variable names in the tibble.  Unfortunately this simplicity comes at a price when we come to write functions.  It means we need a way of telling R whether we're referring to a variable in the tibble, or a parameter we've passed via the function.

If we're using standard evaluation (with "regular" R functions), then we see the value of the parameters we've passed in.  For example, let's put
a couple of `print()` statements in our function:



~~~
getWarmWindyObservations <- function(indata, windspeed = 6, temperature2m = 18){
  #For debugging
  print(windspeed)
  print(temperature2m)
  
  warmWindy <- indata %>% 
    filter(windspeed >= windspeed, temperature2m >= temperature2m)
  
  return(warmWindy)
  
}

warmWindy <- getWarmWindyObservations(cleanweather)
~~~
{: .language-r}



~~~
[1] 6
[1] 18
~~~
{: .output}

As you'd expect, we get the (default) parameter values that we defined with the function.
We can use our parameters like normal variables in our function _except_ when we're using it as part of a parameter to a `dplyr` verb (e.g. `filter`), or another function that uses non standard evaluation.   We need to _unquote_ the parameters so that the `dplyr` function can see their contents (i.e. 6 and 18 in this example).  We do this using the `UQ()` ("unquote") function:


~~~
    filter(windspeed >= UQ(windspeed), temperature2m >= UQ(temperature2m) ) %>% 
~~~
{: .language-r}

When the filter function is evaluated it will see:



~~~
    filter(windspeed >= 6, temperature2m >= 18 ) %>% 
~~~
{: .language-r}

Modifying our function, we have:


~~~
getWarmWindyObservations <- function(indata, windspeed = 6, temperature2m = 18){
  
  warmWindy <- indata %>% 
    filter(windspeed >= UQ(windspeed), temperature2m >= UQ(temperature2m))
  
  return(warmWindy)
  
}
getWarmWindyObservations(cleanweather)
~~~
{: .language-r}



~~~
# A tibble: 97 x 15
     obs  yyyy    mm    dd    hh winddir windspeed windsteadiness pressure
   <chr> <int> <chr> <chr> <chr>   <int>     <dbl>          <int>    <dbl>
 1   MLO  1979    08    01    22     125       7.6            100    681.3
 2   MLO  1981    07    06    23     130       7.2            100    683.0
 3   MLO  1981    07    07    00     126       7.6            100    683.4
 4   MLO  1981    07    08    22      33       6.3            100    683.7
 5   MLO  1981    08    18    23      26       6.7            100    683.0
 6   MLO  1982    07    02    22      92       6.3            100    683.0
 7   MLO  1982    07    02    23      76       6.7            100    682.7
 8   MLO  1983    01    24    23     239       9.8            100    680.3
 9   MLO  1983    08    25    23      33       7.2            100    684.4
10   MLO  1983    08    26    21      10       8.0            100    685.4
# ... with 87 more rows, and 6 more variables: temperature2m <dbl>,
#   temperature10m <dbl>, temperaturetop <dbl>, relhumidity <int>,
#   precipitation <int>, recdate <dttm>
~~~
{: .output}

Our function now works as expected.

> ## Another way of thinking about quoting
> 
> (This section is based on [programming with dplyr](http://dplyr.tidyverse.org/articles/programming.html))
>
> Consider the following code:
>
> 
> ~~~
> greet <- function(person){
>   print("Hello person")
> }
> 
> greet("David")
> ~~~
> {: .language-r}
> 
> 
> 
> ~~~
> [1] "Hello person"
> ~~~
> {: .output}
> 
> The `print` function has no way of knowing that `person` refers to the variable `person`, and isn't 
> part of the string `person`.  To make the contents of the `person` variable visible to the function we
> need to construct the string, using the `paste` function:
>
> 
> ~~~
> greet <- function(person){
>   print(paste("Hello", person))
> }
> 
> greet("David")
> ~~~
> {: .language-r}
> 
> 
> 
> ~~~
> [1] "Hello David"
> ~~~
> {: .output}
> This means that the `person` variable is evaluated in an _unquoted_ environment, so its contents can be evaluated.
{: .callout}

There is one small issue that remains; how does filter _know_ that the first `windspeed` in ``` filter(windspeed >= UQ(windspeed), ...``` refers to the `windspeed` variable in the tibble? (and similarly for the `temperature2m` variable). What happens if we delete the  year variable? Surely this should give an error?


~~~
weather_nowind <- cleanweather %>% select(-windspeed)
getWarmWindyObservations(weather_nowind)
~~~
{: .language-r}



~~~
# A tibble: 211 x 14
     obs  yyyy    mm    dd    hh winddir windsteadiness pressure
   <chr> <int> <chr> <chr> <chr>   <int>          <int>    <dbl>
 1   MLO  1979    08    01    22     125            100    681.3
 2   MLO  1980    06    11    00      26            100    681.0
 3   MLO  1981    05    23    01      NA             NA    682.0
 4   MLO  1981    06    19    20     218            100    682.4
 5   MLO  1981    06    19    21     207            100    682.4
 6   MLO  1981    06    19    22      39            100    682.0
 7   MLO  1981    06    19    23      28            100    681.7
 8   MLO  1981    06    20    00      29            100    681.7
 9   MLO  1981    06    20    01      33            100    681.3
10   MLO  1981    07    06    21     145            100    683.4
# ... with 201 more rows, and 6 more variables: temperature2m <dbl>,
#   temperature10m <dbl>, temperaturetop <dbl>, relhumidity <int>,
#   precipitation <int>, recdate <dttm>
~~~
{: .output}

As you can see, it doesn't; instead the `filter()` function will "fall through" to look for the `windspeed` variable in `filter()`'s _calling environment_,  This is the `getWarmWindyObservations()` environment, which does have a `windspeed` variable.  Since this is a standard R variable, it will be implicitly unquoted, so `filter()` will see:


~~~
    filter(windspeed >= windspeed) %>% 
~~~
{: .language-r}

which is always `TRUE`, so the filter won't do anything!

We need a way of telling the function that the first `windspeed` "belongs" to the data.  We can do this with the `.data` pronoun:


~~~
getWarmWindyObservations <- function(indata, windspeed = 6, temperature2m = 18){
  
  warmWindy <- indata %>% 
    filter(.data$windspeed >= UQ(windspeed), .data$temperature2m >= UQ(temperature2m))
  
  return(warmWindy)
  
}
getWarmWindyObservations(cleanweather)
~~~
{: .language-r}



~~~
# A tibble: 97 x 15
     obs  yyyy    mm    dd    hh winddir windspeed windsteadiness pressure
   <chr> <int> <chr> <chr> <chr>   <int>     <dbl>          <int>    <dbl>
 1   MLO  1979    08    01    22     125       7.6            100    681.3
 2   MLO  1981    07    06    23     130       7.2            100    683.0
 3   MLO  1981    07    07    00     126       7.6            100    683.4
 4   MLO  1981    07    08    22      33       6.3            100    683.7
 5   MLO  1981    08    18    23      26       6.7            100    683.0
 6   MLO  1982    07    02    22      92       6.3            100    683.0
 7   MLO  1982    07    02    23      76       6.7            100    682.7
 8   MLO  1983    01    24    23     239       9.8            100    680.3
 9   MLO  1983    08    25    23      33       7.2            100    684.4
10   MLO  1983    08    26    21      10       8.0            100    685.4
# ... with 87 more rows, and 6 more variables: temperature2m <dbl>,
#   temperature10m <dbl>, temperaturetop <dbl>, relhumidity <int>,
#   precipitation <int>, recdate <dttm>
~~~
{: .output}



~~~
getWarmWindyObservations(weather_nowind)
~~~
{: .language-r}



~~~
Error in filter_impl(.data, quo): Evaluation error: Column `windspeed`: not found in data.
~~~
{: .error}


As you can see, we've also used the `.data` pronoun when calculating the GDP; if our tibble was missing either the `windspeed` or `temperature2m` variables, R would search in the calling environment (i.e. the `getWarmWindyObservations()` function).  As the variables aren't found there it would look in the `getWarmWindyObservations()`'s calling environment, and so on.  If it finds variables matching these names, they would be used instead, giving an incorrect result; if they cannot be found we will get an error.  Using the `.data` pronoun makes our source of the data clear, and prevents this risk.

> ## Challenge:  Filtering by country name and year
>
> Create a new function that will filter by country name *and* by year, and then calculate the GDP.
>
> > ## Solution
> >
> > 
> > ~~~
> >  calcGDPCountryYearFilter <- function(dat, year, country){
> >  dat <- dat %>% filter(.data$year == UQ(year) ) %>% 
> >        filter(.data$country == UQ(country) ) %>% 
> >         mutate(gdp = .data$pop * .data$gdpPercap)
> >         
> >  return(dat)
> > }
> > calcGDPCountryYearFilter(gapminder, year=2007, country="United Kingdom")
> > ~~~
> > {: .language-r}
> > 
> > 
> > 
> > ~~~
> > # A tibble: 1 x 7
> >          country  year      pop continent lifeExp gdpPercap          gdp
> >            <chr> <int>    <dbl>     <chr>   <dbl>     <dbl>        <dbl>
> > 1 United Kingdom  2007 60776238    Europe  79.425  33203.26 2.017969e+12
> > ~~~
> > {: .output}
> > 
> {: .solution}
{: .challenge}


> ## Tip
>
> The "programming with dplyr" vignette is highly recommended if you are
> writing functions for dplyr.  This can be accessed by typing `vignette("programming", package="dplyr")`
>  
{: .callout}

[man]: http://cran.r-project.org/doc/manuals/r-release/R-lang.html#Environment-objects
[chapter]: http://adv-r.had.co.nz/Environments.html
[adv-r]: http://adv-r.had.co.nz/


In this episode we've introduced the idea of writing your own functions, and talked about the
complications caused by non standard evaluation.   

[roxygen2]: http://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html
[testthat]: http://r-pkgs.had.co.nz/tests.html
