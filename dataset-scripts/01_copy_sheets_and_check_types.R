# This script is for general-purpose QA of datasets submitted using the PSInet template.

library(boxr)
library(dplyr)

source(here::here("general-scripts", "box_auth.R"))
source(here::here("general-scripts", "template-data", "qa_functions.R"))

# Setup ####

dataset_identifier <- "Flo_2"

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
                         col_types = "text")[2,-1]

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

# ## Check if there are missing fields ####
# 
# required_fields_sheet1 <- c(1, 2, 3, 4, 5, 7, 8, 9, 10, 11)
# check_fields(sheet1, required_fields_sheet1)
# 
# # If either is false, uncomment this:
# # error_report[1, "missing_required_fields"] <- 1

## Set column types ####

str(sheet1)
sheet1_cols_typed <- sheet1 |>  
  mutate(
    across(all_of(c(1,2,3,4,5,6,7,12)), (\(x) ifelse(is.na(x), NA_character_, as.character(x)))),
    across(all_of(c(8,9)), (\(x) ifelse(is.na(x), NA_integer_, as.integer(x)))),
    across(all_of(c(10,11)), (\(x) ifelse(is.na(x), NA_real_, as.numeric(x))))
  )

str(sheet1_cols_typed)

# If there are errors, uncomment this:
# error_report[1, "data_typing_error"] <- 1

## Store typed data ####

box_write(
  sheet1_cols_typed,
  "sheet1.csv",
  write_fun = readr::write_excel_csv,
  dir_id = qa_box_folder_id
)

# Sheet 2. Data description ####

sheet2 <- box_read_excel(raw_box_id, sheet = 3,
                         col_types = "text")[-1,-1]

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

# ## Check for missing required fields ####
# 
# # Missing data availability specification
# 
# # For data specified as available...
# 
# sheet2_available <- sheet2 |>
#   filter(`Is it available?` == TRUE)
# 
# anyNA(sheet2_available$Units)
# 
# anyNA(sheet2_available |>
#         filter(grepl("potential", `Data variable`)) |>
#         select(`Methodology or Instrument`))

# If any TRUE, uncomment this:
# error_report[2, "missing_required_fields"] <- 1

## Set column types ####

str(sheet2)

sheet2_cols_typed <- sheet2 |>
  mutate(`Is it available?` = as.numeric(`Is it available?`)) |>
  mutate(`Is it available?` = as.logical(`Is it available?`),
         across(all_of(c(1,3,4,5,6,9)), (\(x) ifelse(is.na(x), NA_character_, as.character(x)))),
         across(all_of(c(7,8)), (\(x) ifelse(is.na(x), NA_integer_, as.integer(x))))
  )

str(sheet2_cols_typed)

# If there are errors, uncomment this:
# error_report[2, "data_typing_error"] <- 1

## Store typed data ####

box_write(
  sheet2_cols_typed,
  "sheet2.csv",
  write_fun = readr::write_excel_csv,
  dir_id = qa_box_folder_id
)


# Sheet 3. Additional data availability ####

sheet3 <- box_read_excel(raw_box_id, sheet = 4,
                         col_types = "text")[-1,-1]

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

## Set column types ####

str(sheet3)

sheet3_cols_typed <- sheet3 |>
  mutate(across(c("Availability", "Publication"), as.numeric)) |>
  mutate(across(c("Availability", "Publication"), as.logical)) |>
  mutate(across(all_of(c(1, 3:8)), (\(x) ifelse(is.na(x), NA_character_, as.character(x)))))

str(sheet3_cols_typed)

# If there are errors, uncomment this:
# error_report[3, "data_typing_error"] <- 1

## Store typed data ####

box_write(
  sheet3_cols_typed,
  "sheet3.csv",
  write_fun = readr::write_excel_csv,
  dir_id = qa_box_folder_id
)


# Sheet 4. Treatments ####

## Check that there are the right number/names rows and columns ####

sheet4 <- box_read_excel(raw_box_id, sheet = 5,
                          col_types = "text")[-1, 2:4] |>
  filter(if_any(everything(), ~ !is.na(.)))

nrow(sheet4) > 0

all(colnames(sheet4) == c('Level of treatment', 'Treatment ID', 'Treatment description'))

# If either is FALSE, uncomment this:
# error_report[4, "bad_dim"] <- 1

## Check for missing required fields ####
# 
# # Missing data availability specification
# 
# sheet4_truevals <- sheet4 
# anyNA(sheet4_truevals$`Level of treatment`)
# anyNA(sheet4_truevals$`Treatment ID`)
# 
# # If any TRUE, uncomment this:
# # error_report[4, "missing_required_fields"] <- 1

## Set column types ####
str(sheet4)

sheet4_cols_typed <- sheet4 |>  
  mutate(
    across(everything(), (\(x) ifelse(is.na(x), NA_character_, as.character(x))))
  )

str(sheet4_cols_typed)

# If there are errors, uncomment this:
# error_report[4, "data_typing_error"] <- 1

## Store typed data ####

box_write(
  sheet4_cols_typed,
  "sheet4.csv",
  write_fun = readr::write_excel_csv,
  dir_id = qa_box_folder_id
)


# Sheet 5. Plots ####

sheet5 <-  box_read_excel(raw_box_id, sheet = 6,
                          col_types = "text")[-1, -1]|>
  filter(if_any(everything(), ~ !is.na(.)))

## Check that there are the right number/names rows and columns ####

nrow(sheet5) > 0

all(
  colnames(sheet5) == c(
    'Plot ID',
    'Treatment ID',
    'Vegetation type',
    'Leaf area index (m2/m2)',
    'Growth condition',
    'Aspect',
    'Terrain',
    'Soil texture',
    'Percent sand',
    'Percent silt',
    'Percent clay',
    'Remarks'
  )
)

# If either is FALSE, uncomment this:
# error_report[5, "bad_dim"] <- 1
# 
# ## Check for missing required fields ####
# 
# anyNA(sheet5$`Plot ID`)
# anyNA(sheet5$`Treatment ID`)
# 
# # If any TRUE, uncomment this:
# # error_report[5, "missing_required_fields"] <- 1

## Set column types ####

str(sheet5)

sheet5_cols_typed <-  sheet5 |>  
  mutate(
    across(all_of(c(1, 2, 3, 4, 5, 6, 7, 8, 12)), (\(x) ifelse(is.na(x), NA_character_, as.character(x)))),
    across(all_of(c(9, 10, 11)), (\(x) ifelse(is.na(x), NA_real_, as.numeric(x))))    
  )

str(sheet5_cols_typed)

# If there are errors, uncomment this:
# error_report[5, "data_typing_error"] <- 1

## Store typed data ####

box_write(
  sheet5_cols_typed,
  "sheet5.csv",
  write_fun = readr::write_excel_csv,
  dir_id = qa_box_folder_id
)


# Sheet 6. Plants ####

sheet6 <- box_read_excel(raw_box_id, sheet = 7,
                         col_types = "text")[-1, -1]

## Check that there are the right number/names rows and columns ####

nrow(sheet6) > 0

all(
  colnames(sheet6) == c(
    'Individual_ID',
    'Number_of_individuals',
    'Plot_ID',
    'Plot_Treatment_ID',
    'Individual_Treatment_ID',
    'Genus',
    'Specific_epithet',
    'Plant social status',
    'Average height (m)',
    'Average DBH (cm)',
    'Leaf area index (m2/m2)',
    'Remarks'
  )
)

# If either is FALSE, uncomment this:
# error_report[6, "bad_dim"] <- 1
# # 
# # ## Check for missing required fields ####
# # 
# # required_fields_sheet6 <- c(1, 2, 3, 4, 5, 6, 7)
# # 
# # check_fields(sheet6, required_fields = required_fields_sheet6)
# 
# # If any TRUE, uncomment this:
# # error_report[6, "missing_required_fields"] <- 1

## Set column types ####

str(sheet6)

sheet6_cols_typed <-  sheet6 |>  
  mutate(
    across(all_of(c(1, 3, 4, 5, 6, 7, 8, 12)), (\(x) ifelse(is.na(x), NA_character_, as.character(x)))),
    across(all_of(c(9, 10, 11)), (\(x) ifelse(is.na(x), NA_real_, as.numeric(x)))),
    across(all_of(c(2)), (\(x) ifelse(is.na(x), NA_integer_, as.integer(x))))    
  )


str(sheet6_cols_typed)

# If there are errors, uncomment this:
# error_report[6, "data_typing_error"] <- 1


## Store typed data ####

box_write(
  sheet6_cols_typed,
  "sheet6.csv",
  write_fun = readr::write_excel_csv,
  dir_id = qa_box_folder_id
)


# Sheet 7. Pressure chamber WP ####

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
  )[-c(1:2),]  |>
  filter(if_any(everything(), ~ !is.na(.)))


# These warnings are expected:
# Warning messages:
# 1: Expecting date in E1 / R1C5: got 'Time'
# 2: Expecting date in E2 / R2C5: got 'Enter the time of data collection in HH:MM:SS format. If the precise timestamp is not known,  enter 06:00:00 for "predawn" and 12:00:00 for "midday".

## Check that there are the right number/names rows and columns ####

if (sheet2$`Is it available?`[1] == 1) {
  nrow(sheet7) > 0
} else {
  nrow(sheet7) == 0
}

all(
  colnames(sheet7) == c(
    'Individual_ID',
    'Plot_ID',
    'Date',
    'Time',
    'Organ',
    'Canopy position',
    'Water potential mean',
    'Water potential SD',
    'Water potential n'
  )
)

# If either is FALSE, uncomment this:
# error_report[7, "bad_dim"] <- 1
# 
# ## Check for missing required fields ####
# 
# if (sheet2$`Is it available?`[1] == 1) {
#   required_fields_sheet7 = c(1, 2, 3, 4, 5, 7)
#   check_fields(sheet7_truevals, required_fields_sheet7)
#   
# }
# 
# # If any TRUE, uncomment this:
# # error_report[7, "missing_required_fields"] <- 1

## Set column types ####

str(sheet7)

sheet7_cols_typed <-  sheet7 |>
  mutate(across(where(is.character), (\(x) ifelse(x == "NA", NA_character_, x)))) |>
  mutate(across(c(1,2,5,6), as.character)) |>
  mutate(across(all_of(c(7, 8, 9)), (\(x) ifelse(
    is.na(x), NA_real_, as.numeric(x)
  )))) |>
  mutate(Date = as.Date(Date, format = "%Y%m%d")) |>
  mutate(Time = format(Time, "%H:%M:%S"))

str(sheet7_cols_typed)

# If there are errors, uncomment this:
# error_report[7, "data_typing_error"] <- 1

## Store typed data ####

box_write(
  sheet7_cols_typed,
  "sheet7.csv",
  write_fun = readr::write_excel_csv,
  dir_id = qa_box_folder_id
)

# Sheet 8. Automated WP ####

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
  )[-c(1:2),]  |>
  filter(if_any(everything(), ~ !is.na(.)))


## Check that there are the right number/names rows and columns ####

if (sheet2$`Is it available?`[2] == 1) {
  nrow(sheet8) > 0
} else {
  nrow(sheet8) == 0
}

all(
  colnames(sheet8) == c(
    'Individual_ID',
    'Plot_ID',
    'Date',
    'Time',
    'Organ',
    'Canopy position',
    'Water potential mean',
    'Water potential SD',
    'Water potential n'
  )
)

# If either is FALSE, uncomment this:
# error_report[8, "bad_dim"] <- 1
# 
# ## Check for missing required fields ####
# 
# if (sheet2$`Is it available?`[2] == 1) {
#   required_fields_sheet8 = c(1, 2, 3, 4, 5, 7)
#   
#   check_fields(sheet8_truevals, required_fields_sheet8)
# }
# 
# # If any TRUE, uncomment this:
# # error_report[8, "missing_required_fields"] <- 1

## Set column types ####

str(sheet8)

sheet8_cols_typed <-  sheet8 |>
  mutate(across(where(is.character), (\(x) ifelse(x == "NA", NA, x)))) |>
  mutate(across(all_of(c(1, 2, 5, 6)), (
    \(x) ifelse(is.na(x), NA_character_, as.character(x))
  )),
  across(all_of(c(7, 8, 9)), (\(x) ifelse(
    is.na(x), NA_real_, as.numeric(x)
  )))) |>
  mutate(Date = as.Date(Date, format = "%Y%m%d")) |>
  mutate(Time = format(Time, "%H:%M:%S"))

str(sheet8_cols_typed)

# If there are errors, uncomment this:
# error_report[8, "data_typing_error"] <- 1


## Store typed data ####

box_write(
  sheet8_cols_typed,
  "sheet8.csv",
  write_fun = readr::write_excel_csv,
  dir_id = qa_box_folder_id
)

# Sheet 9. Soil moisture ####

sheet9_cols <- box_read_excel(raw_box_id,
                              sheet = 10,
                              n_max = 0,
                              col_types = "text")[,-1]

sheet9 <-
  box_read_excel(
    raw_box_id,
    sheet = 10,
    col_names = colnames(sheet9_cols),
    col_types = c(
      "skip",
      "text",
      "text",
      "date",
      "text",
      "text",
      "text",
      "text",
      "text",
      "text",
      "text",
      "text",
      "text",
      "text",
      "text",
      "text",
      "text"
    )
  )[-c(1:2),] |>
  filter(if_any(everything(), ~ !is.na(.)))



## Check that there are the right number/names rows and columns ####

if (sum(sheet2$`Is it available?`[3:6] == 1) > 0) {
  nrow(sheet9) > 0
} else {
  nrow(sheet9) == 0
}

all(
  colnames(sheet9) == c(
    'Individual_ID',
    'Plot_ID',
    'Date',
    'Time',
    'SWC_mean_shallow',
    'SWC_sd_shallow',
    'SWC_n_shallow',
    'SWC_mean_deep',
    'SWC_sd_deep',
    'SWC_n_deep',
    'SWP_mean_shallow',
    'SWP_sd_shallow',
    'SWP_n_shallow',
    'SWP_mean_deep',
    'SWP_sd_deep',
    'SWP_n_deep'
  )
)

# If either is FALSE, uncomment this:
# error_report[9, "bad_dim"] <- 1

## Check for missing required fields ####
# 
# # Missing data availability specification
# 
# if (sum(sheet2$`Is it available?`[3:6] == 1) > 0) {
#   required_fields_sheet9 = c(2, 3, 4)
#   check_fields(sheet9_truevals, required_fields_sheet9)
#   
# }
# # If any missing fields, uncomment this:
# # error_report[9, "missing_required_fields"] <- 1

## Set column types ####

str(sheet9)

sheet9_cols_typed <-  sheet9 |>
  mutate(across(where(is.character), (\(x) ifelse(x == "NA", NA, x)))) |>
  mutate(across(all_of(c(1, 2)), (
    \(x) ifelse(is.na(x), NA_character_, as.character(x))
  )),
  across(all_of(c(5:16)), (\(x) ifelse(
    is.na(x), NA_real_, as.numeric(x)
  )))) |>
  mutate(Date = as.character(Date))

str(sheet9_cols_typed)

# If there are errors, uncomment this:
# error_report[9, "data_typing_error"] <- 1


## Store typed data ####

box_write(
  sheet9_cols_typed,
  "sheet9.csv",
  write_fun = readr::write_excel_csv,
  dir_id = qa_box_folder_id
)


# Sheet 10. Met data ####

sheet10_cols <- box_read_excel(raw_box_id,
                               sheet = 11,
                               n_max = 0,
                               col_types = "text")[,-1]

sheet10 <-
  box_read_excel(
    raw_box_id,
    sheet = 11,
    col_names = colnames(sheet10_cols),
    col_types = c(
      "skip",
      "date",
      "date",
      "text",
      "text",
      "text",
      "text",
      "text",
      "text",
      "text",
      "text"
    )
  )[-c(1:2),] |>
  filter(if_any(everything(), ~ !is.na(.)))


## Check that there are the right number/names rows and columns ####

if (sum(sheet2$`Is it available?`[7:14] == 1) > 0) {
  nrow(sheet10) > 0
} else {
  nrow(sheet10) == 0
}

all(
  colnames(sheet10) == c(
    'Date',
    'Time',
    'Precipitation (mm)',
    'Relative humidity (%)',
    'Vapor pressure deficit (kPa)',
    'Air temperature (C)',
    'Photosynthetically active radiation (PPFD) (µmolPhoton m-2 s-1)',
    'Incident shortwave radiation',
    'Net radiation (m s-1)',
    'Windspeed (m/s)'
  )
)

# If either is FALSE, uncomment this:
# error_report[10, "bad_dim"] <- 1
# 
# ## Check for missing required fields ####
# 
# # Missing data availability specification
# 
# if (sum(sheet2$`Is it available?`[7:14] == 1) > 0) {
#   required_fields_sheet10 = c(1,2)
#   check_fields(sheet10_truevals, required_fields_sheet10)
# }
# 
# # If any missing fields, uncomment this:
# # error_report[10, "missing_required_fields"] <- 1

## Set column types ####

str(sheet10)

sheet10_cols_typed <-  sheet10 |>
  mutate(across(where(is.character), (\(x) ifelse(x == "NA", NA, x)))) |>
  mutate(across(all_of(c(2:10)), (\(x) ifelse(
    is.na(x), NA_real_, as.numeric(x)
  )))) |>
  mutate(Date = as.character(Date),
         Time = as.character(Time))

str(sheet10_cols_typed)

# If there are errors, uncomment this:
# error_report[10, "data_typing_error"] <- 1

## Store typed data ####

box_write(
  sheet10_cols_typed,
  "sheet10.csv",
  write_fun = readr::write_excel_csv,
  dir_id = qa_box_folder_id
)


## Update error report ####

box_write(error_report, file_name = error_report_name, dir_id = qa_box_folder_id)

## Update tally sheet ####

tally_sheet <- read.csv(here::here("dataset-scripts", "01_copy_sheets_and_check_types_tally.csv"))
tally_sheet <- rbind(tally_sheet,
                     data.frame(dataset_identifier = dataset_identifier,
                                date = Sys.Date(),
                                custom_changes = F))
write.csv(tally_sheet, here::here("dataset-scripts", "01_copy_sheets_and_check_types_tally.csv"), row.names = F)

