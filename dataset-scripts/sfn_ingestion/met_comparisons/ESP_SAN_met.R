library(dplyr)

esp_san_env <- list.files(here::here("data", "raw_data", "md"), pattern = "ESP_SAN", full.names = T)

esp_san_env <- esp_san_env[ which(grepl("_env_data.csv", esp_san_env))]

esp_san_data <- lapply(esp_san_env, read.csv)
names(esp_san_data) <- c(1:4)

esp_san_data_all <- bind_rows(esp_san_data, .id = "sheet")

esp_san_data_all |>
  select(-sheet) |>
  distinct() |>
  nrow()
