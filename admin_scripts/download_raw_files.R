library(boxr)
library(dplyr)

source(here::here("general-scripts", "box_auth.R"))

info_data <- box_read_excel("1475679138432", sheet = 1)[1:5, ]

for (i in 1:nrow(info_data)) {
  box_dl(
    info_data$raw_box_file_ID[i],
    local_dir = here::here("data", "received_dat", "template"),
    file_name = paste0(info_data$dataset_name[i], ".xlsx")
  )
  
}