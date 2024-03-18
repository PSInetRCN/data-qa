library(dplyr)

esp_til_env <- list.files(here::here("data", "raw_data", "md"), pattern = "ESP_TIL", full.names = T)

esp_til_env <- esp_til_env[ which(grepl("_env_data.csv", esp_til_env))]

esp_til_data <- lapply(esp_til_env, read.csv)
names(esp_til_data) <- c(1:3)

esp_til_data_all <- bind_rows(esp_til_data, .id = "sheet")

esp_til_data_all |>
  select(-sheet) |>
  distinct() |>
  nrow()
