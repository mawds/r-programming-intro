---
layout: page
title: Setup
permalink: /setup/
---

## Software

If you are using a university PC your machine will already have all the required software installed, with the exception of the `testthat` package.  We will install this together at the appropriate point in the class.  This will be installed on your P drive, so make sure you have at least 5MB free on this. 

If you are using your own machine, you should install [R](https://www.stats.bris.ac.uk/R/), and [R Studio Desktop](https://www.rstudio.com/products/rstudio/download/) for your operating system.  Both are available for Windows, Mac and Linux systems.  You will also need to install the `tidyverse` library.  This can be done using the command ```install.packages("tidyverse")```.   

### Error messages
If you are installing the tidyverse on a Linux machine, you may see some error messages like this

```
------------------------- ANTICONF ERROR ---------------------------
Configuration failed because libcurl was not found. Try installing:
 * deb: libcurl4-openssl-dev (Debian, Ubuntu, etc)
 * rpm: libcurl-devel (Fedora, CentOS, RHEL)
 * csw: libcurl_dev (Solaris)
```

This means that you need to install the missing package(s). On Ubuntu, these are:
- libcurl4-openssl-dev
- libssl-dev
- libxml2-dev

## Data

We will be using some example data, and some pre-written code in the class.  This can be downloaded from [here]({{ page.root }}/data/data.zip).  We will explain where to copy the zip file's contents in the first episode.

