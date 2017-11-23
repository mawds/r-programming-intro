cleanfield <- function(indata, missingvalue = -999.99){
  outdata <- ifelse(indata == missingvalue, NA, indata)
  return(outdata)
}

# Clean multiple fields of data
cleanfields <- function(dataset, fieldlist){
  
  for (f in fieldlist) {
    dataset[[f]] <- cleanfield(dataset[[f]])
  }
  
  return(dataset) 
}

