library(pins)
library(boxr)
library(dplyr)

source(here::here("general-scripts", "box_auth.R"))

submission_data_so_far <- box_read_excel("1426293112360", sheet = 1)

tracking_data_orig <- box_read_excel("1426404123641", sheet = 1)

# For new records, link up file names ###

new_datasets <- submission_data_so_far |>
  filter(response_ID > 14,
         !(response_ID %in% tracking_data_orig$response_ID))

box_file_list <- box_ls("242669643766") |>
  as.data.frame() |>
  select(name, id) |>
  rename(file_name = name,
         raw_box_file_ID = id) |>
  mutate(raw_box_file_name = file_name)

new_datasets <- new_datasets |>
  left_join(box_file_list)

new_datasets[which(is.na(new_datasets$raw_box_file_name)), ]

## If any rows are NA, fix the discrepancy and continue
# new_datasets[which(is.na(new_datasets$raw_box_file_name)), "raw_box_file_name"] <- "DJohnson_PSInetdata.xlsx"
# new_datasets[which(is.na(new_datasets$raw_box_file_ID)), "raw_box_file_ID"] <- "1422807121407"


# Bind new and old records ####

new_datasets <- new_datasets |>
  mutate(submission_path = "PSInet_template",
         raw_box_folder_id = "242669643766")

tracking_data_updated <- tracking_data_orig |>
  bind_rows(new_datasets)
 
# Add dataset_names ####

tracking_data_updated <- tracking_data_updated |>
  group_by(submitter_name_last) |>
  mutate(submitter_index = row_number()) |>
  mutate(dataset_name = ifelse(
    is.na(dataset_name),
    paste(submitter_name_last, submitter_index, sep = "_"),
    dataset_name
  )) |>
  select(-submitter_index) |>
  ungroup() 

# Create folder infrastructure ####

needs_folders <- filter(tracking_data_updated, is.na(qa_box_folder_ID)) 

for(i in 1:nrow(needs_folders)) {
  
  new_dir <- box_dir_create(needs_folders$dataset_name[i], parent_dir_id = "245321620174")
  needs_folders$qa_box_folder_ID[i] = new_dir$id
  
}

tracking_data_updated <- tracking_data_updated |>
  filter(!is.na(qa_box_folder_ID)) |>
  bind_rows(needs_folders)

# Create error report files #### 

error_report <- box_read("1422883959952", sheet = 1)

for(i in 1:nrow(tracking_data_updated)) {
  
  if(!is.na(tracking_data_updated$error_report_box_file_ID[i])) {
    next
  }
  
  write_output <- box_write(
    error_report |>
      mutate(dataset_name = tracking_data_updated$dataset_name[i],
             raw_box_file_ID = tracking_data_updated$raw_box_file_ID[i]),
    file_name = paste(tracking_data_updated$dataset_name[i], "error_report.xlsx", sep = "_"),
    dir_id = tracking_data_updated$qa_box_folder_ID[i]
  )
  
  tracking_data_updated$error_report_box_file_ID[i] <- write_output$id
  tracking_data_updated$error_report_box_file_name[i] <- write_output$name
}

box_write(tracking_data_updated, "dataset_tracking.xlsx", "230431401206")
