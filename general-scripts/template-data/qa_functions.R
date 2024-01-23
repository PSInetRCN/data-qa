
check_fields <- function(sheet, required_fields) {
  
  
  missing_fields <- sheet |>
    select(all_of(required_fields)) |>
    select(where(is.na))
  
  if(ncol(missing_fields) > 0) {
    return(paste(colnames(missing_fields, collapse = ", ")))
  } else {
    return("No missing fields")
  }
  
}
