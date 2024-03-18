library(dplyr)

ESP_YUN_env <- list.files(here::here("data", "raw_data", "md"), pattern = "ESP_YUN", full.names = T)

ESP_YUN_env <- ESP_YUN_env[ which(grepl("_env_data.csv", ESP_YUN_env))]

ESP_YUN_data <- lapply(ESP_YUN_env, read.csv)
names(ESP_YUN_data) <- c(1:3)

ESP_YUN_data_all <- bind_rows(ESP_YUN_data, .id = "sheet")

ESP_YUN_data_all |>
  select(-sheet) |>
  distinct() |>
  nrow()

lapply(ESP_YUN_data, nrow)
