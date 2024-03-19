
check_range_numbers <- function(data, min, max) {
  
  all(between(data, min, max), na.rm = T)
  
}

check_range_options <- function(data, options) {
  
  all(data %in% options, na.rm = T)
  
}

check_range <- function(data, range) {
  if(is.na(range)) {
    return(TRUE)
  }
  
  if(range == "") {
    return(TRUE)
  }
  
  if(all(is.na(data))) {
    return(TRUE)
  }
  
  if(grepl("options:", range)) {
    
    options_from_range <- gsub("options: ", "", range)
    range_vector <- strsplit(options_from_range, split = "; ")[[1]]
    return(check_range_options(unlist(data), options = range_vector))
  }
  
  if(grepl("range:", range)) {
    range_values <- gsub("range: ", "", range)
    range_values <- strsplit(range_values, split = ":")[[1]] |>
      as.numeric()
    range_min <- min(range_values)
    range_max <- max(range_values)
    return(check_range_numbers(unlist(data), range_min, range_max))
  }
}


get_col_classes <- function(x) {
  sapply(x, class)
}

check_col_classes <- function(sheet, sheet_expectations) {
  
  sheet_classes <- as.data.frame(get_col_classes(sheet))
  classes_valid <- (sheet_classes$`get_col_classes(sheet)` == sheet_expectations$Type)
  names(classes_valid) <- sheet_expectations$Cleaned_column_name
  classes_valid
}

check_ranges <- function(sheet, sheet_expectations) {
  
  ranges_valid <- vector(length = nrow(sheet_expectations))
  
  for(i in 1:nrow(sheet_expectations)) {
    
    ranges_valid[i] <- check_range(sheet[,i], sheet_expectations$Range[i])
    
  }
  
  names(ranges_valid) <- sheet_expectations$Cleaned_column_name
  
  ranges_valid
}
