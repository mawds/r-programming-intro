---
title: "Introduction"
teaching: 45
exercises: 10
questions:
- "Questions"
objectives:
- "To recap the material covered in Introdution to the Tidyverse"
keypoints:
- "Key points"
source: Rmd
---



## Introduction 

Today's course uses at historic CO2 and temperature data as an example.  The focus of the course is using R for programming.  In the "Data Analysis Using R" course we covered:


  *  Introduction to R and RStudio
  *  Getting help
  *  Loading data into R
  *  Transforming and cleaning data
  *  Plotting data
  *  Finding and using packages

This episode briefly recaps these topics.  We will use the data introduced in this section in the remainder of the course.

The "Data Analysis Using R" course almost exclusively used the tidyverse.  This is a collection of packages that have been designed to work well together, and which provide an integrated way of performing data analyses.  They also hide some of the complexity underlying "base" R.    When we come to program with R, we will need to explore some of this complexity.

##  Getting started with R

RStudio is a widely used integrated development environment for R.

Cover:

* Rstudio windows
* Getting help
* Writing scripts
* Running code / scripts


## Loading data into R

Although R contains functions to load data into it, we used the tidyverse equivalents in the previous course.   We loaded CSV data using the `read_csv()` function.  For example, to load the `gapminder` data we used:


~~~
library(tidyverse)
~~~
{: .r}



~~~
── Attaching packages ────────────────────────────────── tidyverse 1.2.0 ──
~~~
{: .output}



~~~
✔ ggplot2 2.2.1     ✔ readr   1.1.1
✔ tibble  1.3.4     ✔ purrr   0.2.4
✔ tidyr   0.7.2     ✔ dplyr   0.7.4
✔ ggplot2 2.2.1     ✔ forcats 0.2.0
~~~
{: .output}



~~~
── Conflicts ───────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
~~~
{: .output}



~~~
gapminder <- read_csv(file = "data/gapminder-FiveYearData.csv",
                      col_types = cols(
                        country = col_character(),
                        year = col_integer(),
                        pop = col_double(),
                        continent = col_character(),
                        lifeExp = col_double(),
                        gdpPercap = col_double()
                      ) )
~~~
{: .r}

We explicitly list the column type of each variable in order to improve the robustness of our code.

> ## Guessing column types
>
> You don't need to type all the column types out by hand.  If you run `read_csv()` without
> the `col_types` argument, it will display a list of the column types it guessed in the console.
> this list can be copy and pasted into your script, and modified if required.
> 
{: .callout}

Let's take a look at the CO2 data we will be using in this lesson:

```
# --------------------------------------------------------------------
# USE OF NOAA ESRL DATA
# 
# These data are made freely available to the public and the
# scientific community in the belief that their wide dissemination
# will lead to greater understanding and new scientific insights.
# The availability of these data does not constitute publication
# of the data.  NOAA relies on the ethics and integrity of the user to
# insure that ESRL receives fair credit for their work.  If the data 
# are obtained for potential use in a publication or presentation, 
# ESRL should be informed at the outset of the nature of this work.  
# If the ESRL data are essential to the work, or if an important 
# result or conclusion depends on the ESRL data, co-authorship
# may be appropriate.  This should be discussed at an early stage in
# the work.  Manuscripts using the ESRL data should be sent to ESRL
# for review before they are submitted for publication so we can
# insure that the quality and limitations of the data are accurately
# represented.
# 
# Contact:   Pieter Tans (303 497 6678; pieter.tans@noaa.gov)
# 
# File Creation:  Sun Mar  5 05:01:22 2017
# 
# RECIPROCITY
# 
# Use of these data implies an agreement to reciprocate.
# Laboratories making similar measurements agree to make their
# own data available to the general public and to the scientific
# community in an equally complete and easily accessible form.
# Modelers are encouraged to make available to the community,
# upon request, their own tools used in the interpretation
# of the ESRL data, namely well documented model code, transport
# fields, and additional information necessary for other
# scientists to repeat the work and to run modified versions.
# Model availability includes collaborative support for new
# users of the models.
# --------------------------------------------------------------------
#  
#  
# See www.esrl.noaa.gov/gmd/ccgg/trends/ for additional details.
#  
# NOTE: DATA FOR THE LAST SEVERAL MONTHS ARE PRELIMINARY, ARE STILL SUBJECT
# TO QUALITY CONTROL PROCEDURES.
# NOTE: The week "1 yr ago" is exactly 365 days ago, and thus does not run from
# Sunday through Saturday. 365 also ignores the possibility of a leap year.
# The week "10 yr ago" is exactly 10*365 days +3 days (for leap years) ago.
#  
#      Start of week      CO2 molfrac           (-999.99 = no data)  increase
# (yr, mon, day, decimal)    (ppm)  #days       1 yr ago  10 yr ago  since 1800
  1974   5  19  1974.3795    333.34  6          -999.99   -999.99     50.36
  1974   5  26  1974.3986    332.95  6          -999.99   -999.99     50.06
  1974   6   2  1974.4178    332.32  5          -999.99   -999.99     49.57
  1974   6   9  1974.4370    332.18  7          -999.99   -999.99     49.63
  1974   6  16  1974.4562    332.37  7          -999.99   -999.99     50.07
  ....
  
```

> ## Different file formats
>
> Compare the format of the co2 data (`co2_weekly_mlo.txt`) and the gapminder data (`gapminder-FiveYearData.csv`).
> What differences do you notice?
> 
> > ## Solution
> > 
> > The main differences are:
> > * The co2 data contains documentation and licencing information at its start.  These rows
> >   are prefixed with the # symbol
> > * The gapminder data contains variables names in its first row (remember we cannot start an R
> >   variable with a number, and including spaces needs special tricks).  The co2 data doesn't 
> >   contain variable names in a nice format.
> > * In the gapminder data each value is separated by a single comma.  In the co2 data, the values
> >   are separated by (varying numbers) of spaces.
> {: .solution}
{: .challenge}

The `read_csv()` function is designed to read comma separated files (like the gapminder data).  This isn't
going to work for the CO2 data.  There are two different approaches we can use:

* We can make sure of the fact that each variable starts in the same column in each row; this data is 
 called "fixed width", and can read with `read_fwf()`
 * We can use the fact that there is at least one space between each variable.  The data is tabular, so we use `read_table()`.
 
TODO compare pros and cons - blank missing data will break the latter, but easier to implement the former

We also have to deal with the text at the start of the file.


~~~
co2 <- read_table("data/co2_weekly_mlo.txt",
                  comment = "#",
                  col_names = FALSE)
~~~
{: .r}



~~~
Parsed with column specification:
cols(
  X1 = col_integer(),
  X2 = col_integer(),
  X3 = col_integer(),
  X4 = col_double(),
  X5 = col_double(),
  X6 = col_integer(),
  X7 = col_double(),
  X8 = col_double(),
  X9 = col_double()
)
~~~
{: .output}

