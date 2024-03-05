library(dplyr)

SEN_SOU_env <- list.files(here::here("data", "raw_data", "md"), pattern = "SEN_SOU", full.names = T)

SEN_SOU_env <- SEN_SOU_env[ which(grepl("_env_data.csv", SEN_SOU_env))]

SEN_SOU_data <- lapply(SEN_SOU_env, read.csv)
names(SEN_SOU_data) <- c(1:3)

SEN_SOU_data_all <- bind_rows(SEN_SOU_data, .id = "sheet")

SEN_SOU_data_all |>
  select(-sheet) |>
  distinct() |>
  nrow()

lapply(SEN_SOU_data, nrow)
