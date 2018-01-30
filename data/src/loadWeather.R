loadWeatherData <- function(infile){
  # Load the weather data stored in infile to a tibble, and return it
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
  
  #  Generate recdate field
  weather <- weather %>% mutate(recdate = lubridate::ymd_h(paste(yyyy,mm,dd,hh)))
  
  # Clean missing values, using values specified in met_README
  weather <- cleanfields(weather, c("windspeed", "pressure", "temperature2m",
                                    "temperature10m", "temperaturetop"), missingvalue = -999.9)
  weather <- cleanfields(weather, "winddir", missingvalue = -999)
  weather <- cleanfields(weather, "windsteadiness", missingvalue = -9)
  weather <- cleanfields(weather, c("relhumidity", "precipitation"), missingvalue = -99)
  
  return(weather)
  
}

cleanweather <- loadWeatherData("data/met_mlo_insitu_1_obop_hour_1977.txt")

loadWeatherData <- function(infile){
  # Load the weather data stored in infile to a tibble, and return it
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
  
  #  Generate recdate field
  weather <- weather %>% mutate(recdate = lubridate::ymd_h(paste(yyyy,mm,dd,hh)))
  
  return(weather)
  
}
