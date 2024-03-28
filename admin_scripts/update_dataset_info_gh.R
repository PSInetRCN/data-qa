library(boxr)
library(dplyr)

box_auth()

info_data_box <- box_read_excel("1475679138432", sheet = 1)

info_data_local <- read.csv(
  here::here("dataset_tracking.csv"),
  colClasses = c(
    "numeric",
    "character",
    "character",
    "character",
    "character",
    "character",
    "character",
    "character"
  )
)

new_box <- info_data_box |>
  filter(!(response_ID %in% info_data_local$response_ID)) |>
  mutate(source = ifelse(response_ID < 0,
                         "OG",
                         "PSInet"))

info_data_local <- bind_rows(info_data_local, new_box)

write.csv(info_data_local,
          here::here("dataset_tracking.csv"),
          row.names = FALSE)
