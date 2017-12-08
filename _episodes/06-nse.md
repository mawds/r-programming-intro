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
{: .r}

Let's put this code in a function; note that we change the input data to be the parameter we pass when we call
the function (it's _really_ easy to forget to make these changes when you start making functions from existing code):


~~~
getWarmWindyObservations <- function(indata, windspeed = 6, temperature2m = 18){
  
  warmWindy <- indata %>% 
    filter(windspeed >= windspeed, temperature2m >= temperature2m)
  
  return(warmWindy)
  
}
~~~
{: .r}

But if we run this function, it doesn't do what we'd expect:


~~~
getWarmWindyObservations(cleanweather)
~~~
{: .r}



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
{: .r}

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
{: .r}



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
{: .r}

When the filter function is evaluated it will see:



~~~
    filter(windspeed >= 6, temperature2m >= 18 ) %>% 
~~~
{: .r}

Modifying our function, we have:


~~~
getWarmWindyObservations <- function(indata, windspeed = 6, temperature2m = 18){
  
  warmWindy <- indata %>% 
    filter(windspeed >= UQ(windspeed), temperature2m >= UQ(temperature2m))
  
  return(warmWindy)
  
}
getWarmWindyObservations(cleanweather)
~~~
{: .r}



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
> {: .r}
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
> {: .r}
> 
> 
> 
> ~~~
> [1] "Hello David"
> ~~~
> {: .output}
> This means that the `person` variable is evaluated in an _unquoted_ environment, so its contents can be evaluated.
{: .callout}

There is one small issue that remains; how does filter _know_ that the first `year` in ``` filter(year == UQ(year) ) %>%  ``` refers to the `year` variable in the tibble?  What happens if we delete the 
year variable? Surely this should give an error?


~~~
gap_noyear <- gapminder %>% select(-year)
calc_GDP_and_filter(gap_noyear, 1997)
~~~
{: .r}



~~~
Error in calc_GDP_and_filter(gap_noyear, 1997): could not find function "calc_GDP_and_filter"
~~~
{: .error}

As you can see, it doesn't; instead the `filter()` function will "fall through" to look for the `year` variable in `filter()`'s _calling environment_,  This is the `calc_GDP_and_filter()` environment, which does have a `year` variable.  Since this is a standard R variable, it will be implicitly unquoted, so `filter()` will see:


~~~
    filter(1997 == 1997) %>% 
~~~
{: .r}

which is always `TRUE`, so the filter won't do anything!

We need a way of telling the function that the first `year` "belongs" to the data.  We can do this with the `.data` pronoun:


~~~
calc_GDP_and_filter <- function(dat, year){
  
gdpgapfiltered <- dat %>%
    filter(.data$year == UQ(year) ) %>% 
    mutate(gdp = .data$gdpPercap * .data$pop)

return(gdpgapfiltered)
  
}

calc_GDP_and_filter(gapminder, 1997)
~~~
{: .r}



~~~
# A tibble: 142 x 7
       country  year       pop continent lifeExp  gdpPercap          gdp
         <chr> <int>     <dbl>     <chr>   <dbl>      <dbl>        <dbl>
 1 Afghanistan  1997  22227415      Asia  41.763   635.3414  14121995875
 2     Albania  1997   3428038    Europe  72.950  3193.0546  10945912519
 3     Algeria  1997  29072015    Africa  69.152  4797.2951 139467033682
 4      Angola  1997   9875024    Africa  40.963  2277.1409  22486820881
 5   Argentina  1997  36203463  Americas  73.275 10967.2820 397053586287
 6   Australia  1997  18565243   Oceania  78.830 26997.9366 501223252921
 7     Austria  1997   8069876    Europe  77.510 29095.9207 234800471832
 8     Bahrain  1997    598561      Asia  73.925 20292.0168  12146009862
 9  Bangladesh  1997 123315288      Asia  59.412   972.7700 119957417048
10     Belgium  1997  10199787    Europe  77.530 27561.1966 281118335091
# ... with 132 more rows
~~~
{: .output}



~~~
calc_GDP_and_filter(gap_noyear, 1997)
~~~
{: .r}



~~~
Error in filter_impl(.data, quo): Evaluation error: Column `year`: not found in data.
~~~
{: .error}


As you can see, we've also used the `.data` pronoun when calculating the GDP; if our tibble was missing either the `gdpPercap` or `pop` variables, R would search in the calling environment (i.e. the `calc_GDP_and_filter()` function).  As the variables aren't found there it would look in the `calc_GDP_and_filter()`'s calling environment, and so on.  If it finds variables matching these names, they would be used instead, giving an incorrect result; if they cannot be found we will get an error.  Using the `.data` pronoun makes our source of the data clear, and prevents this risk.

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
> > {: .r}
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
complications caused by non standard evaluation.   The forthcoming Research IT course "Programming in R" will cover writing, testing and documenting functions in much more detail.  We will notify participants of this course when it is available to book.

[roxygen2]: http://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html
[testthat]: http://r-pkgs.had.co.nz/tests.html
