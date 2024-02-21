library(boxr)
library(dplyr)

source(here::here("general-scripts", "box_auth.R"))

tracking_data_orig <- box_read_excel("1451006536192", sheet = 1)

sfn_cleaned_box_folder_id <- "250148384955"
sfn_raw_box_folder_id <- "248008105452"

sfn_cleaned_ls <- box_ls(sfn_cleaned_box_folder_id) |> 
  as.data.frame() |>
  select(name, id) |>
  mutate(dataset_name = gsub("_as_psinet.xlsx", "", name),
         processed_box_folder_ID = sfn_cleaned_box_folder_id,
         submission_path = "SAPFLUXNET") |>
  rename(file_name = name,
         processed_box_file_ID = id) |>
  mutate(processed_box_file_name = file_name)

sfn_raw_ls <- box_ls(sfn_raw_box_folder_id) |>
  as.data.frame() |>
  select(name, id) |>
  mutate(dataset_name = gsub(".xlsx", "", name),
         raw_box_folder_id = sfn_raw_box_folder_id) |>
  rename(raw_box_file_name = name,
         raw_box_file_ID = id) 


# For new records, link up file names ###

new_datasets <- sfn_cleaned_ls |>
  filter(!(dataset_name %in% tracking_data_orig$dataset_name)) |>
  left_join(sfn_raw_ls)

# Bind new and old records ####

tracking_data_updated <- tracking_data_orig |>
  bind_rows(new_datasets)
 
# Create folder infrastructure ####

needs_folders <- filter(tracking_data_updated, is.na(qa_box_folder_ID)) 

for(i in 1:nrow(needs_folders)) {
  
  new_dir <- box_dir_create(needs_folders$dataset_name[i], parent_dir_id = "245321620174")
  needs_folders$qa_box_folder_ID[i] = new_dir$id
  
}

tracking_data_updated <- tracking_data_updated |>
  filter(!is.na(qa_box_folder_ID)) |>
  bind_rows(needs_folders)

box_write(tracking_data_updated, "sfn_tracking.xlsx", "230431401206")
