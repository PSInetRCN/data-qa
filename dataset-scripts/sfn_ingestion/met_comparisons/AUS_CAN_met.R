library(dplyr)

aus_can_env <- list.files(here::here("data", "raw_data", "md"), pattern = "AUS_CAN", full.names = T)

aus_can_env <- aus_can_env[ which(grepl("_env_data.csv", aus_can_env))]

aus_can_data <- lapply(aus_can_env, read.csv)
names(aus_can_data) <- c(1:3)

aus_can_data_all <- bind_rows(aus_can_data, .id = "sheet")

aus_can_data_all |>
  select(-sheet) |>
  distinct() |>
  nrow()
