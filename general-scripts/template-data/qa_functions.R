
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

set_sheet1_types <- function(sheet1) {
  sheet1 |>  
    mutate(
      across(all_of(c(1,2,3,4,5,6,7,12)), (\(x) ifelse(is.na(x), NA_character_, as.character(x)))),
      across(all_of(c(8,9)), (\(x) ifelse(is.na(x), NA_integer_, as.integer(x)))),
      across(all_of(c(10,11)), (\(x) ifelse(is.na(x), NA_real_, as.numeric(x))))
    )
}