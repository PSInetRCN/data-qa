data_ranges <- list(
  year = c(1950, 2024),
  lat = c(-90, 90),
  long = c(-180, 180),
  percents = c(0, 100)
)


check_in_range <- function(value, range) {
  
  if(any(value < range[1])) {
    return(FALSE)
  }
  
  if(any(value > range[2])) {
    return(FALSE)
  }
  
  return(TRUE)
}


