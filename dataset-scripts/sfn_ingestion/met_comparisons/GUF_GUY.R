library(dplyr)

GUF_GUY_env <- list.files(here::here("data", "rawdat", "sfn", "md"), pattern = "GUF_GUY", full.names = T)

GUF_GUY_env <- GUF_GUY_env[ which(grepl("_env_data.csv", GUF_GUY_env))]

GUF_GUY_data <- lapply(GUF_GUY_env, read.csv)
names(GUF_GUY_data) <- c(1:2)

GUF_GUY_data_all <- bind_rows(GUF_GUY_data, .id = "sheet")

GUF_GUY_data_all |>
  select(-sheet) |>
  distinct() |>
  nrow()

lapply(GUF_GUY_data, nrow)
