library(boxr)
library(dplyr)

boxr::box_auth()

og_ids <- c('1408436168424', '1408436175624', '1408436170824', '1408436180424', '1408436185224', '1408436182824', '1440431852720', '1440396099965', '1440393453485', '1440420289310', '1440415943721')

box_file_list <- box_ls("242669643766") |>
  as.data.frame() |>
  select(name, id) |>
  filter(id %in% og_ids) |>
  rename(file_name = name,
         raw_box_file_ID = id) |>
  mutate(raw_box_file_name = file_name,
         dataset_name = paste0("og_", row_number()),
         response_ID = -100:-110) |>
  select(response_ID, dataset_name, raw_box_file_ID)

info_data_box <- box_read_excel("1475679138432", sheet = 1)

updated_info_data <- info_data_box |>
  bind_rows(box_file_list)


