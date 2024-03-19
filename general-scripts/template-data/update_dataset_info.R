library(pins)
library(boxr)
library(dplyr)

source(here::here("general-scripts", "box_auth.R"))

submission_data_so_far <- box_read_excel("1426293112360", sheet = 1)

info_data_orig <- box_read_excel("1475679138432", sheet = 1)

# For new records, link up file names ###

new_datasets <- submission_data_so_far |>
  filter(response_ID > 14,
         !(response_ID %in% info_data_orig$response_ID))

box_file_list <- box_ls("242669643766") |>
  as.data.frame() |>
  select(name, id) |>
  rename(file_name = name,
         raw_box_file_ID = id) |>
  mutate(raw_box_file_name = file_name)

new_datasets <- new_datasets |>
  left_join(box_file_list)

new_datasets |>
  filter(is.na(raw_box_file_name))

## If any rows are NA, fix the discrepancy and continue
new_datasets[which(new_datasets$file_name == "DOMEC_PSInetData_2.xls"), "raw_box_file_name"] <- "DOMEC_PSInetData_2.xlsx"

new_datasets <- new_datasets |>
  mutate(raw_box_file_name = ifelse(is.na(raw_box_file_name),
                                    paste0(file_name, ".xlsx"),
                                    raw_box_file_name)) |>
  select(-raw_box_file_ID) |>
  left_join(select(box_file_list, -file_name))

## Look for duplicated file names

new_datasets_dups <- new_datasets |>
  group_by(raw_box_file_ID, raw_box_file_name) |>
  tally() |>
  filter(n > 1)

new_datasets_dups

# Use this to check that, for each filename with a dup, all records except timestamp and response ID are identical
dups <- filter(new_datasets, raw_box_file_name == "Shekhar_PSInetData.xlsx") |>
# select(-timestamp, -response_ID) |>
  distinct()

View(dups)
# Remove duplicate rows
new_datasets <- new_datasets |>
  filter(!(response_ID %in% c(34, 35, 44, 23, 28, 30, 46, 49, 52, 54, 60, 66, 70, 78, 81, 84, 88)))

# Bind new and old records ####

new_datasets <- new_datasets |>
  select(response_ID, raw_box_file_ID, submitter_name_last)

info_data_updated <- info_data_orig |>
  mutate(submitter_name_last =dataset_name) |>
  bind_rows(new_datasets)
 
# Add dataset_names ####

info_data_updated <- info_data_updated |>
  mutate(submitter_name_last = substr(submitter_name_last, 0, 3)) |>
  group_by(submitter_name_last) |>
  mutate(submitter_index = row_number()) |>
  ungroup() |>
  group_by_all() |>
  mutate(dataset_name = ifelse(
    is.na(dataset_name),
    paste(submitter_name_last, submitter_index, sep = "_"),
    dataset_name
  )) |>
  ungroup() |>
 select(-submitter_index, -submitter_name_last) |>
  mutate(dataset_name = stringi::stri_trans_general(dataset_name,"Latin-ASCII"))


# Find any files not listed

not_included_files <- box_file_list |> filter(!(raw_box_file_ID %in% info_data_updated$raw_box_file_ID))

box_write(info_data_updated, "dataset_info.xlsx", "230431401206")
