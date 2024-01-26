# This script is for general-purpose QA of datasets submitted using the PSInet template.

library(boxr)
library(dplyr)

source(here::here("general-scripts", "box_auth.R"))
source(here::here("general-scripts", "template-data", "qa_functions.R"))

# Setup ####

dataset_identifier <- 11

tracking_sheet <- box_read_excel("1422900875174")

this_dataset_row <- which(tracking_sheet$Dataset_ID == dataset_identifier)
raw_box_id <- tracking_sheet[this_dataset_row, "raw_box_file_id"]
dataset_name <- tracking_sheet[this_dataset_row, "Short_descriptor"]


## Create a box directory for cleaned data ####

savedir <- tracking_sheet[this_dataset_row, "qa_box_folder_id"]

if(is.na(savedir)) {
  
  savedir <- box_dir_create(paste0("qa_", dataset_identifier, "_", dataset_name), parent_dir_id = "245321620174")$id
  tracking_sheet[this_dataset_row, "qa_box_folder_id"] <- savedir
  
  box_write(tracking_sheet, "dataset_tracking_auto.xlsx", dir_id = "230431401206")
}

## Set up an error report for this dataset #### 

error_report_id <-  tracking_sheet[this_dataset_row, "error_report_id"]

if(is.na(error_report_id)) {
  
  error_report <- box_read("1422883959952", sheet = 1) |>
    mutate(dataset_identifier = dataset_identifier,
           Short_descriptor = dataset_name, 
           raw_box_file_id = raw_box_id,
           qa_dir = savedir,
           .before = 1)
  
  tracking_sheet[this_dataset_row, "error_report_id"] <- box_write(error_report, "error_report.csv", write_fun = readr::write_excel_csv, dir_id = savedir)$id
  box_write(tracking_sheet, "dataset_tracking_auto.xlsx", dir_id = "230431401206")
}


# Sheet 1. Study and site information ####

sheet1 <- box_read_excel(raw_box_id, sheet = 2,
                         col_types = "text")[2,-1]

## Check that there are the right number/names rows and columns ####

nrow(sheet1) == 1

all(colnames(sheet1) == c('Submitting author first name', 'Submitting author last name', 'Institution', 'Email', 'Data publication?', 'Data publication DOI(s)', 'Study type', 'Begin year', 'End year', 'Latitude (WGS84)', 'Longitude (WGS84)', 'Remarks'))

# If either is FALSE, uncomment this:
# error_report[1, "bad_dim"] <- 1

## Check if there are missing fields #### 

required_fields_sheet1 <- c(1, 2, 3, 4, 5, 7, 8, 9, 10, 11)
check_fields(sheet1, required_fields_sheet1)

# If either is false, uncomment this:
# error_report[1, "missing_required_fields"] <- 1

## Set column types #### 

sheet1_cols_typed <- set_sheet1_types(sheet1)

# If there are errors, uncomment this:
# error_report[1, "data_typing_error"] <- 1

## Update error report #### 

box_write(error_report, "error_report.csv", write_fun = readr::write_excel_csv, dir_id = savedir)

## Store typed data ####

box_write(sheet1_cols_typed, "sheet1.csv", write_fun = readr::write_excel_csv, dir_id = savedir)

# Sheet 2. Data description ####

sheet2 <- box_read_excel(raw_box_id, sheet = 3,
                         col_types = "text")[-1,-1]

## Sheet 3. Additional data availability ####

sheet3 <- box_read_excel(raw_box_id, sheet = 4,
                         col_types = "text")[-1,-1]

## Sheet 4. Treatments ####

sheet4 <-  box_read_excel(raw_box_id, sheet = 5,
                          col_types = "text")[-1, 2:4]

## Sheet 5. Plots ####

sheet5 <-  box_read_excel(raw_box_id, sheet = 6,
                          col_types = "text")[-1, -1]

## Sheet 6. Plants ####

sheet6 <- box_read_excel(raw_box_id, sheet = 7,
                         col_types = "text")[-1, -1]


## Sheet 7. Pressure chamber WP ####

sheet7_cols <- box_read_excel(raw_box_id,
                              sheet = 8,
                              n_max = 0,
                              col_types = "text")[,-1]

sheet7 <-
  box_read_excel(
    raw_box_id,
    sheet = 8,
    col_names = colnames(sheet7_cols),
    col_types = c(
      "skip",
      "text",
      "text",
      "text",
      "date",
      "text",
      "text",
      "text",
      "text",
      "text"
    )
  )[-c(1:2),]

## Sheet 8. Automated WP ####

sheet8_cols <- box_read_excel(raw_box_id,
                              sheet = 9,
                              n_max = 0)[,-1]

sheet8 <-
  box_read_excel(
    raw_box_id,
    sheet = 9,
    col_names = colnames(sheet8_cols),
    col_types = c(
      "skip",
      "text",
      "text",
      "text",
      "date",
      "text",
      "text",
      "text",
      "text",
      "text"
    )
  )[-c(1:2),]


## Sheet 9. Soil moisture ####

sheet9 <-
  box_read_excel(
    raw_box_id,
    sheet = 10)[-1,-1]

## Sheet 10. Met data ####

sheet10  <-
  box_read_excel(
    raw_box_id,
    sheet = 11)[-1,-1]

# perform QA level checks on each data frame
# flag errors