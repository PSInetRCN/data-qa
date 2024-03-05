library(dplyr)

GBR_GUI_env <- list.files(here::here("data", "raw_data", "md"), pattern = "GBR_GUI", full.names = T)

GBR_GUI_env <- GBR_GUI_env[ which(grepl("_env_data.csv", GBR_GUI_env))]

GBR_GUI_data <- lapply(GBR_GUI_env, read.csv)
names(GBR_GUI_data) <- c(1:3)

GBR_GUI_data_all <- bind_rows(GBR_GUI_data, .id = "sheet")

GBR_GUI_data_all |>
  select(-sheet) |>
  distinct() |>
  nrow()

lapply(GBR_GUI_data, nrow)
