cleanfield <- function(indata, missingvalue = -999.99){
  outdata <- ifelse(indata == missingvalue, NA, indata)
  return(outdata)
}

cleanfields <- function(dataset, fieldlist){
  
  if ( !all(fieldlist %in% names(dataset)) ) {
    stop("Attempting to clean variables that do not exist in the dataset")
  }
  
  if ( anyDuplicated(fieldlist) != 0 ) {
    warning("Duplicated variable names specified")
  }
  
  if(is.null(names(fieldlist))){
    
    for (f in fieldlist) {
      dataset[[f]] <- cleanfield(dataset[[f]])
    }
  }else{
    
    fieldnames <- names(fieldlist)
    for(i in 1:length(fieldlist)){
      fieldname <- fieldnames[i]
      missingvalue <- fieldlist[i]
      
      dataset[[fieldname]] <- cleanfield(dataset[[fieldname]], missingvalue = missingvalue)
    }
  }
  
  return(dataset) 
}