
check_fields <- function(sheet, required_fields) {
  
  
  missing_fields <- sheet |>
    select(all_of(required_fields)) |>
    select(where(anyNA))
  
  if(ncol(missing_fields) > 0) {
    return(paste(colnames(missing_fields), collapse = ", "))
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


set_sheet2_types <- function(sheet2) {
  sheet2 |>  
    mutate(
      across(all_of(c(1,3,4,5,6,9)), (\(x) ifelse(is.na(x), NA_character_, as.character(x)))),
      across(all_of(c(2,7,8)), (\(x) ifelse(is.na(x), NA_integer_, as.integer(x))))
    )
}


set_sheet3_types <- function(sheet3) {
  sheet3 |>  
    mutate(
      across(all_of(c(1, 3:8)), (\(x) ifelse(is.na(x), NA_character_, as.character(x)))),
      across(all_of(c(2)), (\(x) ifelse(is.na(x), NA_integer_, as.integer(x))))
    )
}


set_sheet4_types <- function(sheet4) {
  sheet4 |>  
    mutate(
      across(everything(), (\(x) ifelse(is.na(x), NA_character_, as.character(x))))
    )
}

set_sheet5_types <- function(sheet5) {
  sheet5 |>  
    mutate(
      across(all_of(c(1, 2, 3, 5, 6, 7, 8, 12)), (\(x) ifelse(is.na(x), NA_character_, as.character(x)))),
      across(all_of(c(4, 9, 10, 11)), (\(x) ifelse(is.na(x), NA_real_, as.numeric(x))))    
      )
}


set_sheet6_types <- function(sheet6) {
  sheet6 |>  
    mutate(
      across(all_of(c(1, 3, 4, 5, 6, 7, 8, 12)), (\(x) ifelse(is.na(x), NA_character_, as.character(x)))),
      across(all_of(c(9, 10, 11)), (\(x) ifelse(is.na(x), NA_real_, as.numeric(x)))),
      across(all_of(c(2)), (\(x) ifelse(is.na(x), NA_integer_, as.integer(x))))    
    )
}


