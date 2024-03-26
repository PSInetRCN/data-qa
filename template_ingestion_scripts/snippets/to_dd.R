to_dd <- function(deg, minutes = 0, sec = 0, dir) {
  
  if(dir %in% c("S", "W")) {
    dir_times = -1
  } else {
    dir_times = 1
  }
  
  as.character(dir_times * (as.numeric(deg) +
    (as.numeric(minutes) / 60) +
    (as.numeric(sec) / 3600)))

}
