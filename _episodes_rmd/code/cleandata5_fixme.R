
cleanfield <- function(indata, missingvalue = -999.99){
  outdata <- ifelse(indata == missingvalue, NA, indata)
  return(outdata)
}

cleanfields <- function(dataset, fieldlist){
  
  if ( is.null(names(fieldlist)) ) {
    # Generate named vector to use for cleaning
    fieldstoclean <- rep(-999.99, length(fieldlist))
    names(fieldstoclean) <- fieldlist
    
    
    if ( !all(names(fieldstoclean) %in% names(dataset)) ) {
      stop("Attempting to clean variables that do not exist in the dataset")
    }
    
    if ( anyDuplicated(names(fieldstoclean)) != 0 ) {
      warning("Duplicated variable names specified")
    }
    
    for (i in 1:length(fieldstoclean)) {
      
      variablename <- names(fieldstoclean)[i] 
      missingval <- fieldstoclean[i] 
      
      dataset[[ variablename ]] <- cleanfield(dataset[[ variablename ]], missingvalue = missingval)
      
    } 
  }
  
  
  return(dataset) 
  
}
