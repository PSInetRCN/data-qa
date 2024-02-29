library(boxr)
library(dplyr)

source(here::here("general-scripts", "box_auth.R"))

tracking_data_orig <- box_read_excel("1451006536192", sheet = 1)

sfn_raw_box_folder_id <- "248008105452"

sfn_raw_ls <- box_ls(sfn_raw_box_folder_id) |>
  as.data.frame() |>
  select(name, id) |>
  mutate(dataset_name = gsub(".xlsx", "", name),
         raw_box_folder_id = sfn_raw_box_folder_id) |>
  rename(raw_box_file_name = name,
         raw_box_file_ID = id) 

sfn_md_box_folder_id <- "251357771783"

sfn_md_ls <- box_ls(sfn_md_box_folder_id) |>
  as.data.frame() |>
  select(name, id) |>
  mutate(file_name = gsub(".csv", "", name)) |>
  mutate(filename_2 = file_name) |>
  tidyr::separate_wider_delim(filename_2, delim = "_", too_few = "align_end", names_sep = "_") |>
  filter(filename_2_6 == "md") |>
  select(name, id, file_name, filename_2_5) |>
  rename(md_type = filename_2_5) |>
  mutate(dataset_name = stringr::str_remove_all(name, stringr::regex("[a-z]", ignore_case = F))) |>
  mutate(dataset_name = stringr::str_remove_all(dataset_name, "__.")) |>
  select(dataset_name, md_type, id, file_name) |>
  rename(md_id = id)

sfn_available_md <- sfn_raw_ls |>
  left_join(sfn_md_ls) |>
  group_by(dataset_name) |>
  summarize(nmd = length(unique(na.omit(md_type)))) |>
  ungroup()

sfn_missing_md <- filter(sfn_available_md, nmd < 5)
