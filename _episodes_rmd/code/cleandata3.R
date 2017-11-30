cleanfield <- function(indata, missingvalue = -999.99){
  outdata <- ifelse(indata == missingvalue, NA, indata)
  return(outdata)
}

cleanfields <- function(dataset, fieldlist){
  
  if ( is.null(names(fieldlist)) ) {
    
    if ( !all(fieldlist %in% names(dataset)) ) {
      stop("Attempting to clean variables that do not exist in the dataset")
    }
    
    if ( anyDuplicated(fieldlist) != 0 ) {
      warning("Duplicated variable names specified")
    }
    
    for (f in fieldlist) {
      dataset[[f]] <- cleanfield(dataset[[f]])
    }
    
  } else {
    stop("Not yet implemented")
  }
  
  return(dataset) 
  
}
