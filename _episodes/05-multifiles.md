---
title: "Loading multiple files"
teaching: 30
exercises: 0
questions:
- "Example ?"
objectives:
- "Example objective"
keypoints:
- "Example keypoint"
---





## Loading more than one file at once

We have many years of weather data, and we would like to load them into a single tibble. Let's write a new function, `loadMultipleWeatherData()`, which will call our `loadWeatherData()` function, to do this.


Our function will take a vector of weather data's filenames. Before we move onto writing the function, let's think about how we will generate the vector of filenames. We could type these in by hand, for example:

```
weatherfiles <- c("data/met_mlo_insitu_1_obop_hour_1977.txt", "data/met_mlo_insitu_1_obop_hour_1978.txt", "data/met_mlo_insitu_1_obop_hour_1979.txt", ...)
```
But this would be slow and error prone.  We would also need to remember to manually update the vector every time we obtained a new year's worth of data.   Fortunately there is a function, `list.files()` which will return a vector of the files in a directory:


~~~
list.files(path = "data")
~~~
{: .language-r}



~~~
 [1] "co2_data_mlo.png"                   
 [2] "co2_weekly_mlo.txt"                 
 [3] "gapminder-FiveYearData.csv"         
 [4] "met_mlo_insitu_1_obop_hour_1977.txt"
 [5] "met_mlo_insitu_1_obop_hour_1978.txt"
 [6] "met_mlo_insitu_1_obop_hour_1979.txt"
 [7] "met_mlo_insitu_1_obop_hour_1980.txt"
 [8] "met_mlo_insitu_1_obop_hour_1981.txt"
 [9] "met_mlo_insitu_1_obop_hour_1982.txt"
[10] "met_mlo_insitu_1_obop_hour_1983.txt"
[11] "met_mlo_insitu_1_obop_hour_1984.txt"
[12] "met_mlo_insitu_1_obop_hour_1985.txt"
[13] "met_mlo_insitu_1_obop_hour_1986.txt"
[14] "met_mlo_insitu_1_obop_hour_1987.txt"
[15] "met_mlo_insitu_1_obop_hour_1988.txt"
[16] "met_mlo_insitu_1_obop_hour_1989.txt"
[17] "met_mlo_insitu_1_obop_hour_1990.txt"
[18] "met_mlo_insitu_1_obop_hour_1991.txt"
[19] "met_mlo_insitu_1_obop_hour_1992.txt"
[20] "met_mlo_insitu_1_obop_hour_1993.txt"
[21] "met_mlo_insitu_1_obop_hour_1994.txt"
[22] "met_mlo_insitu_1_obop_hour_1995.txt"
[23] "met_mlo_insitu_1_obop_hour_1996.txt"
[24] "met_mlo_insitu_1_obop_hour_1997.txt"
[25] "met_mlo_insitu_1_obop_hour_1998.txt"
[26] "met_mlo_insitu_1_obop_hour_1999.txt"
[27] "met_mlo_insitu_1_obop_hour_2000.txt"
[28] "met_mlo_insitu_1_obop_hour_2001.txt"
[29] "met_mlo_insitu_1_obop_hour_2002.txt"
[30] "met_mlo_insitu_1_obop_hour_2003.txt"
[31] "met_mlo_insitu_1_obop_hour_2004.txt"
[32] "met_mlo_insitu_1_obop_hour_2005.txt"
[33] "met_mlo_insitu_1_obop_hour_2006.txt"
[34] "met_mlo_insitu_1_obop_hour_2007.txt"
[35] "met_mlo_insitu_1_obop_hour_2008.txt"
[36] "met_mlo_insitu_1_obop_hour_2009.txt"
[37] "met_mlo_insitu_1_obop_hour_2010.txt"
[38] "met_mlo_insitu_1_obop_hour_2011.txt"
[39] "met_mlo_insitu_1_obop_hour_2012.txt"
[40] "met_mlo_insitu_1_obop_hour_2013.txt"
[41] "met_mlo_insitu_1_obop_hour_2014.txt"
[42] "met_mlo_insitu_1_obop_hour_2015.txt"
[43] "met_README"                         
~~~
{: .output}

We have some other files in the directory, which we don't want to try and load (such as the gapminder data).
All the files we are interested in have a consistent filename pattern: `met_mlo_insitu_1_obop_hour_yyyy.txt`, 
where `yyyy` is the year.   

The `list.files()` function takes an optional argument, `pattern`; this accepts a _regular expression_.  Unfortunately we don't have time to cover these in any depth at all.   Regular expressions provide an incredibly flexible way of matching text patterns.   They can be fiddly to write (and are often even harder to understand once you've written them).   

A regular expression uses a mixture of literal text (i.e. "normal" text), and special characters to define what matches.    If we specify part of the file that matches FIXME rewrite...


~~~
list.files(path = "./data", pattern =  "met_mlo_insitu_1_obop_hour_")
~~~
{: .language-r}



~~~
 [1] "met_mlo_insitu_1_obop_hour_1977.txt"
 [2] "met_mlo_insitu_1_obop_hour_1978.txt"
 [3] "met_mlo_insitu_1_obop_hour_1979.txt"
 [4] "met_mlo_insitu_1_obop_hour_1980.txt"
 [5] "met_mlo_insitu_1_obop_hour_1981.txt"
 [6] "met_mlo_insitu_1_obop_hour_1982.txt"
 [7] "met_mlo_insitu_1_obop_hour_1983.txt"
 [8] "met_mlo_insitu_1_obop_hour_1984.txt"
 [9] "met_mlo_insitu_1_obop_hour_1985.txt"
[10] "met_mlo_insitu_1_obop_hour_1986.txt"
[11] "met_mlo_insitu_1_obop_hour_1987.txt"
[12] "met_mlo_insitu_1_obop_hour_1988.txt"
[13] "met_mlo_insitu_1_obop_hour_1989.txt"
[14] "met_mlo_insitu_1_obop_hour_1990.txt"
[15] "met_mlo_insitu_1_obop_hour_1991.txt"
[16] "met_mlo_insitu_1_obop_hour_1992.txt"
[17] "met_mlo_insitu_1_obop_hour_1993.txt"
[18] "met_mlo_insitu_1_obop_hour_1994.txt"
[19] "met_mlo_insitu_1_obop_hour_1995.txt"
[20] "met_mlo_insitu_1_obop_hour_1996.txt"
[21] "met_mlo_insitu_1_obop_hour_1997.txt"
[22] "met_mlo_insitu_1_obop_hour_1998.txt"
[23] "met_mlo_insitu_1_obop_hour_1999.txt"
[24] "met_mlo_insitu_1_obop_hour_2000.txt"
[25] "met_mlo_insitu_1_obop_hour_2001.txt"
[26] "met_mlo_insitu_1_obop_hour_2002.txt"
[27] "met_mlo_insitu_1_obop_hour_2003.txt"
[28] "met_mlo_insitu_1_obop_hour_2004.txt"
[29] "met_mlo_insitu_1_obop_hour_2005.txt"
[30] "met_mlo_insitu_1_obop_hour_2006.txt"
[31] "met_mlo_insitu_1_obop_hour_2007.txt"
[32] "met_mlo_insitu_1_obop_hour_2008.txt"
[33] "met_mlo_insitu_1_obop_hour_2009.txt"
[34] "met_mlo_insitu_1_obop_hour_2010.txt"
[35] "met_mlo_insitu_1_obop_hour_2011.txt"
[36] "met_mlo_insitu_1_obop_hour_2012.txt"
[37] "met_mlo_insitu_1_obop_hour_2013.txt"
[38] "met_mlo_insitu_1_obop_hour_2014.txt"
[39] "met_mlo_insitu_1_obop_hour_2015.txt"
~~~
{: .output}

`list.files()` now only returns the files we wish to load.

> ## More on regular expressions
> 
> Regular expressions are really useful if you are working with text.  For example, you could use them to validate that a postcode or telephone number has the correct format, or to extract parts of strings, or to perform complicated searching and replacing within strings. 
> 
> Regular expressions look intimidating, and can be fiddly to write.  If you are doing any work with text it is well worth investing the time to learn (at least the basics of) regular expressions.   A nice interactive tutorial can be found [here](https://regexone.com/)
> 
> The site [regex101](https://regex101.com/) lets you
> interactively write a regular expression, and test it on a sample of data.  
> 
> You will find that your regular expressions contain a lot of `\`s.  Unfortunately R treats the
> `\` as a special character in strings.  This means that we need to tell R to treat a `\` as a regular
> character; we do this by _escaping_ it.  We do this with another `\`:
> 
> 
> ~~~
> mystring <- "We write a backslash as \\"
> ~~~
> {: .language-r}
> 
{: .callout}

We are almost there with listing our files.   The file names don't contain the file path, which we will need to use when we load them. 

> ## Challenge
> 
> Take a look at the help page for `list.files()`.  What option do you need to use to return the file path?
> Use this to generate a vector, `weatherfiles`, containing the filename (with relative path) for each data file.
> 
> > ## Solution
> > 
> > The `full.names` option will return the file names with a directory path:
> > 
> > 
> > ~~~
> > weatherfiles <- list.files(path = "./data", "met_mlo_insitu_1_obop_hour_", full.names = TRUE)
> > ~~~
> > {: .language-r}
> > 
> {: .solution}
{: .challenge}

## Back to our function

We need to load each file in, and then combine them all into a single file, and then clean them.

One approach to this might be to load each file in, and then append it to a master data-set.   This will work, but is actually quite slow, since the R will have to take a copy of the entire master data set each time we add more data to it.

A more efficient way of performing the task is to make a list of tibbles, and then combine these in a single step after we've loaded all of the data.

## Lists

We have previously encountered vectors, which we can create using the `c()` function:


~~~
c(1,2,4,8)
~~~
{: .language-r}



~~~
[1] 1 2 4 8
~~~
{: .output}



~~~
c("a", "b", "c")
~~~
{: .language-r}



~~~
[1] "a" "b" "c"
~~~
{: .output}

All of the elements of a vector must be the same data type; R will make this so if we try and make a vector with different data types:


~~~
c(1, "a", 2, 3)
~~~
{: .language-r}



~~~
[1] "1" "a" "2" "3"
~~~
{: .output}

We can think of a _list_ as a generalisation of this; each element of the list can contain pretty much any other object.  We make a list with the `list()` function:


~~~
mylist <- list(1, "a", 2, c(1,2,3))
mylist
~~~
{: .language-r}



~~~
[[1]]
[1] 1

[[2]]
[1] "a"

[[3]]
[1] 2

[[4]]
[1] 1 2 3
~~~
{: .output}
This has created a list; the first element contains the number 1, the second the letter "a", the third contains the number 3 and the 4th element contains a vector, which contains the values 1,2 and 3.

We can use the subsetting operator, `[]` on the list in the same way we would a vector. This will return another list:


~~~
mylist[2]
~~~
{: .language-r}



~~~
[[1]]
[1] "a"
~~~
{: .output}



~~~
mylist[2:3]
~~~
{: .language-r}



~~~
[[1]]
[1] "a"

[[2]]
[1] 2
~~~
{: .output}

To refer to the contents of a list element we use the `[[]]` operator.  In contrast to the `[]` operator, this takes a single value:


~~~
mylist[[1]]
~~~
{: .language-r}



~~~
[1] 1
~~~
{: .output}



~~~
mylist[[4]]
~~~
{: .language-r}



~~~
[1] 1 2 3
~~~
{: .output}
But note we cannot use, e.g.:


~~~
mylist[[1:2]]
~~~
{: .language-r}
Since this would return more than one element.

There is another way of manipulating lists, which is to name its elements:


~~~
weatherlist <- list(temperature = 2.5, windspeed = 4, winddir = "N")
~~~
{: .language-r}

We can still refer to the list elements by number

~~~
weatherlist[1:2]
~~~
{: .language-r}



~~~
$temperature
[1] 2.5

$windspeed
[1] 4
~~~
{: .output}
We can also refer to them by name:


~~~
# This will return a list
weatherlist[c("windspeed", "winddir")]
~~~
{: .language-r}



~~~
$windspeed
[1] 4

$winddir
[1] "N"
~~~
{: .output}



~~~
# As will this
weatherlist[c("windspeed")]
~~~
{: .language-r}



~~~
$windspeed
[1] 4
~~~
{: .output}



~~~
## We use [[]] to access the data itself:
weatherlist[["windspeed"]]
~~~
{: .language-r}



~~~
[1] 4
~~~
{: .output}

We can also return the contents of a list element with the `$` operator:


~~~
weatherlist$windspeed
~~~
{: .language-r}



~~~
[1] 4
~~~
{: .output}

One useful feature of the `[[]]` operator is that we can define the element we want in a variable:


~~~
myvar <- "windspeed"
weatherlist[[myvar]]
~~~
{: .language-r}



~~~
[1] 4
~~~
{: .output}

We cannot do this with the `$` operator.

We can add or update an element of a list using the `[[]]` or `$` operators:


~~~
weatherlist$windspeed <- 3
weatherlist[["winddir"]] <- "E"
~~~
{: .language-r}

You can only add elements to a list if it already exists.  You can create a new (empty) list using the `list()` function with no arguments.

To delete an element from a list assign the element the value `NULL`, e.g. `weatherlist$deleteme <- NULL`.

## Loading our files

This is what we want our function to do:

```
loadWeatherDataPseudoCode <- function(weatherfiles){
  Make an empty list
  for i in 1:length(i) {
    Load in data for file weatherfiles[i]
    Append the data to the ith element of the list
  }
  convert the list into a single tibble
  
}

loadWeatherDataPseudoCode(weatherfiles)

```


> ## Challenge 
> 
> Taking the pseudocode above as a starting point, create a function to load more than one weather file.
> The function should return a list, each element of which contains a tibble of weather data (we will cover
> converting the list into a single tibble after the challenge).
> 
> > ## Solution
> > 
> > 
> > ~~~
> > loadMultipleWeatherData <- function(weatherfiles){
> >   weatherList <- list()
> >   for (i in 1:length(weatherfiles)) {
> >     weatherList[[i]] <- loadWeatherData(weatherfiles[i])
> >   }
> >   
> >   return(weatherList)
> > }
> > 
> > # Load in a couple of years data:
> > weatherDataList <- loadMultipleWeatherData(weatherfiles[1:2])
> > ~~~
> > {: .language-r}
> > 
> {: .solution}
{: .challenge}


## Generating a single tibble

We use the `bind_rows()` function to combine multiple tibbles into a single tibble.  We can pass a list of tibbles as the argument to the function, or provide one or more tibbles that we wish to concatenate.

Let's modify our function to convert the list of tibbles into a single tibble:


~~~
loadMultipleWeatherData <- function(weatherfiles){
  weatherList <- list()
  for (i in 1:length(weatherfiles)) {
    weatherList[[i]] <- loadWeatherData(weatherfiles[i])
  }

  # Convert list of tibbles to a single tibble
  weatherData <- bind_rows(weatherList) 
  return(weatherData)
}

# Load in a couple of years data:
weatherData <- loadMultipleWeatherData(weatherfiles[1:2])
~~~
{: .language-r}

Let's load in the data for all years:


~~~
cleanweather <- loadMultipleWeatherData(weatherfiles)
~~~
{: .language-r}

We can sense check our load by checking that the number of observations in each year is (roughly - don't forget leap years) the same.


~~~
cleanweather %>%  
  group_by(yyyy) %>% 
  count()  
~~~
{: .language-r}



~~~
# A tibble: 39 x 2
# Groups:   yyyy [39]
    yyyy     n
   <int> <int>
 1  1977  8760
 2  1978  8760
 3  1979  8760
 4  1980  8784
 5  1981  8760
 6  1982  8760
 7  1983  8760
 8  1984  8784
 9  1985  8760
10  1986  8760
# ... with 29 more rows
~~~
{: .output}

And by checking the summary statistics for any unusual values:


~~~
summary(cleanweather)
~~~
{: .language-r}



~~~
     obs                 yyyy           mm                 dd           
 Length:341838      Min.   :1977   Length:341838      Length:341838     
 Class :character   1st Qu.:1986   Class :character   Class :character  
 Mode  :character   Median :1996   Mode  :character   Mode  :character  
                    Mean   :1996                                        
                    3rd Qu.:2006                                        
                    Max.   :2015                                        
                                                                        
      hh               winddir        windspeed      windsteadiness  
 Length:341838      Min.   :  0.0   Min.   : 0.000   Min.   :  0.00  
 Class :character   1st Qu.:126.0   1st Qu.: 2.200   1st Qu.: 97.00  
 Mode  :character   Median :166.0   Median : 3.900   Median :100.00  
                    Mean   :177.7   Mean   : 4.566   Mean   : 96.56  
                    3rd Qu.:236.0   3rd Qu.: 6.300   3rd Qu.:100.00  
                    Max.   :360.0   Max.   :24.800   Max.   :285.00  
                    NA's   :11124   NA's   :11114    NA's   :12981   
    pressure     temperature2m    temperature10m   temperaturetop  
 Min.   :666.1   Min.   :-5.500   Min.   :-3.90    Min.   :-3.60   
 1st Qu.:679.3   1st Qu.: 4.500   1st Qu.: 5.60    1st Qu.: 5.90   
 Median :680.5   Median : 7.000   Median : 7.50    Median : 7.70   
 Mean   :680.3   Mean   : 7.277   Mean   : 7.52    Mean   : 7.56   
 3rd Qu.:681.7   3rd Qu.:10.000   3rd Qu.: 9.50    3rd Qu.: 9.40   
 Max.   :686.4   Max.   :21.000   Max.   :18.40    Max.   :16.70   
 NA's   :9174    NA's   :10630    NA's   :163053   NA's   :159106  
  relhumidity     precipitation       recdate                   
 Min.   :  1.00   Min.   :  0.00   Min.   :1977-01-01 00:00:00  
 1st Qu.: 15.00   1st Qu.:  0.00   1st Qu.:1986-10-01 19:15:00  
 Median : 30.00   Median :  0.00   Median :1996-07-01 14:30:00  
 Mean   : 37.64   Mean   :  0.05   Mean   :1996-07-01 14:50:57  
 3rd Qu.: 58.00   3rd Qu.:  0.00   3rd Qu.:2006-04-01 09:45:00  
 Max.   :101.00   Max.   :180.00   Max.   :2015-12-31 23:00:00  
 NA's   :29157    NA's   :94003                                 
~~~
{: .output}

## Summary

In this episode we've written a function to load in more than 1 weather data file at once, and to return a tibble containing all of the loaded data.   



