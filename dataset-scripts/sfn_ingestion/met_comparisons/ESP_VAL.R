library(dplyr)

ESP_VAL_env <- list.files(here::here("data", "raw_data", "md"), pattern = "ESP_VAL", full.names = T)

ESP_VAL_env <- ESP_VAL_env[ which(grepl("_env_data.csv", ESP_VAL_env))]

ESP_VAL_data <- lapply(ESP_VAL_env, read.csv)
names(ESP_VAL_data) <- c(1:2)

ESP_VAL_data_all <- bind_rows(ESP_VAL_data, .id = "sheet")

ESP_VAL_data_all |>
  select(-sheet) |>
  distinct() |>
  nrow()