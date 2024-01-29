# This script is for general-purpose QA of datasets submitted using the PSInet template.

library(boxr)
library(dplyr)

source(here::here("general-scripts", "box_auth.R"))
source(here::here("general-scripts", "template-data", "qa_functions.R"))

# Setup ####

dataset_identifier <- "Flo_1"

tracking_sheet <- box_read_excel("1426404123641")

this_dataset_row <-
  which(tracking_sheet$dataset_name == dataset_identifier)
raw_box_id <- tracking_sheet[this_dataset_row, "raw_box_file_ID"]
qa_box_folder_id <-
  tracking_sheet[this_dataset_row, "qa_box_folder_ID"]
error_report_id <-
  tracking_sheet[this_dataset_row, "error_report_box_file_ID"]
error_report_name <-
  tracking_sheet[this_dataset_row, "error_report_box_file_name"]

error_report <- box_read_excel(error_report_id, sheet = 1)

# Sheet 1. Study and site information ####

sheet1 <- box_read_excel(raw_box_id, sheet = 2,
                         col_types = "text")[2, -1]

## Check that there are the right number/names rows and columns ####

nrow(sheet1) == 1

all(
  colnames(sheet1) == c(
    'Submitting author first name',
    'Submitting author last name',
    'Institution',
    'Email',
    'Data publication?',
    'Data publication DOI(s)',
    'Study type',
    'Begin year',
    'End year',
    'Latitude (WGS84)',
    'Longitude (WGS84)',
    'Remarks'
  )
)

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

box_write(error_report, file_name = error_report_name, dir_id = qa_box_folder_id)

## Store typed data ####

box_write(
  sheet1_cols_typed,
  "sheet1.csv",
  write_fun = readr::write_excel_csv,
  dir_id = qa_box_folder_id
)

# Sheet 2. Data description ####

sheet2 <- box_read_excel(raw_box_id, sheet = 3,
                         col_types = "text")[-1, -1]

## Check that there are the right number/names rows and columns ####

nrow(sheet2) == 14

all(
  colnames(sheet2) == c(
    'Data variable',
    'Is it available?',
    'Manual or automated collection?',
    'Units',
    'Sensor location',
    'Methodology or Instrument',
    'Soil depth - start (cm)',
    'Soil depth - end (cm)',
    'Remarks'
  )
)

# If either is FALSE, uncomment this:
# error_report[2, "bad_dim"] <- 1

## Check for missing required fields ####

# Missing data availability specification
anyNA(sheet2$`Is it available?`)

# For data specified as available...

sheet2_available <- sheet2 |>
  filter(`Is it available?` == 1)

anyNA(sheet2_available$Units)

anyNA(sheet2_available |>
        filter(grepl("potential", `Data variable`)) |>
        select(`Methodology or Instrument`))

# If any TRUE, uncomment this:
# error_report[2, "missing_required_fields"] <- 1

## Set column types ####

sheet2_cols_typed <- set_sheet2_types(sheet2)

# If there are errors, uncomment this:
# error_report[2, "data_typing_error"] <- 1

## Update error report ####

box_write(error_report, file_name = error_report_name, dir_id = qa_box_folder_id)

## Store typed data ####

box_write(
  sheet2_cols_typed,
  "sheet2.csv",
  write_fun = readr::write_excel_csv,
  dir_id = qa_box_folder_id
)


# Sheet 3. Additional data availability ####

sheet3 <- box_read_excel(raw_box_id, sheet = 4,
                         col_types = "text")[-1, -1]

## Check that there are the right number/names rows and columns ####

nrow(sheet3) == 13

all(
  colnames(sheet3) == c(
    'Variable',
    'Availability',
    'Publication',
    'Network',
    'If other, provide the database name',
    'Network or database ID',
    'Link to data',
    'Remarks'
  )
)

# If either is FALSE, uncomment this:
# error_report[3, "bad_dim"] <- 1

## Check for missing required fields ####

# Missing data availability specification
anyNA(sheet3$Availability)

# If any TRUE, uncomment this:
# error_report[3, "missing_required_fields"] <- 1

## Set column types ####

sheet3_cols_typed <- set_sheet3_types(sheet3)

# If there are errors, uncomment this:
# error_report[3, "data_typing_error"] <- 1

## Update error report ####

box_write(error_report, file_name = error_report_name, dir_id = qa_box_folder_id)

## Store typed data ####

box_write(
  sheet3_cols_typed,
  "sheet3.csv",
  write_fun = readr::write_excel_csv,
  dir_id = qa_box_folder_id
)


# Sheet 4. Treatments ####

## Check that there are the right number/names rows and columns ####

sheet4 <-  box_read_excel(raw_box_id, sheet = 5,
                          col_types = "text")[-1, 2:4]


nrow(sheet4) > 0

all(colnames(sheet4) == c('Level of treatment', 'Treatment ID', 'Treatment description'))

# If either is FALSE, uncomment this:
# error_report[4, "bad_dim"] <- 1

## Check for missing required fields ####

# Missing data availability specification

sheet4_truevals <- sheet4 |>
  group_by_all() |>
  filter(any(
    !is.na(`Level of treatment`),!is.na(`Treatment ID`),!is.na(`Treatment description`)
  ))

anyNA(sheet4_truevals$`Level of treatment`)
anyNA(sheet4_truevals$`Treatment ID`)

# If any TRUE, uncomment this:
# error_report[4, "missing_required_fields"] <- 1

## Set column types ####

sheet4_cols_typed <- set_sheet4_types(sheet4_truevals)

# If there are errors, uncomment this:
# error_report[4, "data_typing_error"] <- 1

## Update error report ####

box_write(error_report, file_name = error_report_name, dir_id = qa_box_folder_id)

## Store typed data ####

box_write(
  sheet4_cols_typed,
  "sheet4.csv",
  write_fun = readr::write_excel_csv,
  dir_id = qa_box_folder_id
)


# Sheet 5. Plots ####

sheet5 <-  box_read_excel(raw_box_id, sheet = 6,
                          col_types = "text")[-1,-1]

## Check that there are the right number/names rows and columns ####

nrow(sheet5) > 0

all(colnames(sheet5) == c('Plot ID', 'Treatment ID', 'Vegetation type', 'Leaf area index (m2/m2)', 'Growth condition', 'Aspect', 'Terrain', 'Soil texture', 'Percent sand', 'Percent silt', 'Percent clay', 'Remarks'))

# If either is FALSE, uncomment this:
# error_report[5, "bad_dim"] <- 1

## Check for missing required fields ####

anyNA(sheet5$`Plot ID`)
anyNA(sheet5$`Treatment ID`)

# If any TRUE, uncomment this:
# error_report[5, "missing_required_fields"] <- 1

## Set column types ####

sheet5_cols_typed <- set_sheet5_types(sheet5)

# If there are errors, uncomment this:
# error_report[5, "data_typing_error"] <- 1

## Update error report ####

box_write(error_report, file_name = error_report_name, dir_id = qa_box_folder_id)

## Store typed data ####

box_write(
  sheet5_cols_typed,
  "sheet5.csv",
  write_fun = readr::write_excel_csv,
  dir_id = qa_box_folder_id
)


# Sheet 6. Plants ####

sheet6 <- box_read_excel(raw_box_id, sheet = 7,
                         col_types = "text")[-1,-1]

## Check that there are the right number/names rows and columns ####

nrow(sheet6) > 0

all(colnames(sheet6) == c('Individual_ID', 'Number_of_individuals', 'Plot_ID', 'Plot_Treatment_ID', 'Individual_Treatment_ID', 'Genus', 'Specific_epithet', 'Plant social status', 'Average height (m)', 'Average DBH (cm)', 'Leaf area index (m2/m2)', 'Remarks'))

# If either is FALSE, uncomment this:
# error_report[6, "bad_dim"] <- 1

## Check for missing required fields ####

required_fields_sheet6 <- c(1, 2, 3, 4, 5, 6, 7)

check_fields(sheet6, required_fields = required_fields_sheet6)

# If any TRUE, uncomment this:
# error_report[6, "missing_required_fields"] <- 1

## Set column types ####

sheet6_cols_typed <- set_sheet6_types(sheet6)

# If there are errors, uncomment this:
# error_report[6, "data_typing_error"] <- 1

## Update error report ####

box_write(error_report, file_name = error_report_name, dir_id = qa_box_folder_id)

## Store typed data ####

box_write(
  sheet6_cols_typed,
  "sheet6.csv",
  write_fun = readr::write_excel_csv,
  dir_id = qa_box_folder_id
)


# Sheet 7. Pressure chamber WP  START HERE ####

sheet7_cols <- box_read_excel(raw_box_id,
                              sheet = 8,
                              n_max = 0,
                              col_types = "text")[, -1]

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
  )[-c(1:2), ]

# Sheet 8. Automated WP ####

sheet8_cols <- box_read_excel(raw_box_id,
                              sheet = 9,
                              n_max = 0)[, -1]

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
  )[-c(1:2), ]


# Sheet 9. Soil moisture ####

sheet9 <-
  box_read_excel(raw_box_id,
                 sheet = 10)[-1, -1]

# Sheet 10. Met data ####

sheet10  <-
  box_read_excel(raw_box_id,
                 sheet = 11)[-1, -1]
