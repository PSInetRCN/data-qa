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

## Check if there are missing fields ####

required_fields_sheet1 <- c(1, 2, 3, 4, 5, 7, 8, 9, 10, 11)
check_fields(sheet1, required_fields_sheet1)


## Set column types ####

sheet1_cols_typed <- set_sheet1_types(sheet1)

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


## Set column types ####

sheet2_cols_typed <- set_sheet2_types(sheet2)

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

## Check for missing required fields ####

# Missing data availability specification
anyNA(sheet3$Availability)

## Set column types ####

sheet3_cols_typed <- set_sheet3_types(sheet3)



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


## Check for missing required fields ####

# Missing data availability specification

sheet4_truevals <- sheet4 |>
  filter(if_any(everything(), ~ !is.na(.)))

anyNA(sheet4_truevals$`Level of treatment`)
anyNA(sheet4_truevals$`Treatment ID`)

## Set column types ####

sheet4_cols_typed <- set_sheet4_types(sheet4_truevals)

## Store typed data ####

box_write(
  sheet4_cols_typed,
  "sheet4.csv",
  write_fun = readr::write_excel_csv,
  dir_id = qa_box_folder_id
)


# Sheet 5. Plots ####

sheet5 <-  box_read_excel(raw_box_id, sheet = 6,
                          col_types = "text")[-1, -1]

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

## Check for missing required fields ####

anyNA(sheet5$`Plot ID`)
anyNA(sheet5$`Treatment ID`)

## Set column types ####

sheet5_cols_typed <- set_sheet5_types(sheet5)

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

## Check for missing required fields ####

required_fields_sheet6 <- c(1, 2, 3, 4, 5, 6, 7)

check_fields(sheet6, required_fields = required_fields_sheet6)

## Set column types ####

sheet6_cols_typed <- set_sheet6_types(sheet6)

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
  )[-c(1:2),]

# These warnings are expected:
# Warning messages:
# 1: Expecting date in E1 / R1C5: got 'Time'
# 2: Expecting date in E2 / R2C5: got 'Enter the time of data collection in HH:MM:SS format. If the precise timestamp is not known,  enter 06:00:00 for "predawn" and 12:00:00 for "midday".

## Check that there are the right number/names rows and columns ####

sheet7_truevals <- sheet7 |>
  filter(if_any(everything(), ~ !is.na(.)))

if (sheet2$`Is it available?`[1] == 1) {
  nrow(sheet7_truevals) > 0
} else {
  nrow(sheet7_truevals) == 0
}

all(
  colnames(sheet7_truevals) == c(
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


## Check for missing required fields ####

if (sheet2$`Is it available?`[1] == 1) {
  required_fields_sheet7 = c(1, 2, 3, 4, 5, 7)
  check_fields(sheet7_truevals, required_fields_sheet7)
  
}

## Set column types ####

sheet7_cols_typed <-  sheet7_truevals |>
  mutate(across(where(is.character), (\(x) ifelse(x == "NA", NA, x)))) |>
  mutate(across(all_of(c(1, 2, 5, 6)), (
    \(x) ifelse(is.na(x), NA_character_, as.character(x))
  )),
  across(all_of(c(7, 8, 9)), (\(x) ifelse(
    is.na(x), NA_real_, as.numeric(x)
  )))) |>
  mutate(Date = as.Date(Date, format = "%Y%m%d")) |>
  mutate(Time = format(Time, "%H:%M:%S"))

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
  )[-c(1:2),]


## Check that there are the right number/names rows and columns ####

sheet8_truevals <- sheet8 |>
  filter(if_any(everything(), ~ !is.na(.)))

if (sheet2$`Is it available?`[2] == 1) {
  nrow(sheet8_truevals) > 0
} else {
  nrow(sheet8_truevals) == 0
}

all(
  colnames(sheet8_truevals) == c(
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


## Check for missing required fields ####

if (sheet2$`Is it available?`[2] == 1) {
  required_fields_sheet8 = c(1, 2, 3, 4, 5, 7)
  
  check_fields(sheet8_truevals, required_fields_sheet8)
}

## Set column types ####

sheet8_cols_typed <-  sheet8_truevals |>
  mutate(across(where(is.character), (\(x) ifelse(x == "NA", NA, x)))) |>
  mutate(across(all_of(c(1, 2, 5, 6)), (
    \(x) ifelse(is.na(x), NA_character_, as.character(x))
  )),
  across(all_of(c(7, 8, 9)), (\(x) ifelse(
    is.na(x), NA_real_, as.numeric(x)
  )))) |>
  mutate(Date = as.Date(Date, format = "%Y%m%d")) |>
  mutate(Time = format(Time, "%H:%M:%S"))

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
  )[-c(1:2),]


## Check that there are the right number/names rows and columns ####

sheet9_truevals <- sheet9 |>
  filter(if_any(everything(), ~ !is.na(.)))

if (sum(sheet2$`Is it available?`[3:6] == 1) > 0) {
  nrow(sheet9_truevals) > 0
} else {
  nrow(sheet9_truevals) == 0
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

## Check for missing required fields ####

# Missing data availability specification

if (sum(sheet2$`Is it available?`[3:6] == 1) > 0) {
  required_fields_sheet9 = c(2, 3, 4)
  check_fields(sheet9_truevals, required_fields_sheet9)
  
}


## Set column types ####

sheet9_cols_typed <-  sheet9_truevals |>
  mutate(across(where(is.character), (\(x) ifelse(x == "NA", NA, x)))) |>
  mutate(across(all_of(c(1, 2)), (
    \(x) ifelse(is.na(x), NA_character_, as.character(x))
  )),
  across(all_of(c(5:16)), (\(x) ifelse(
    is.na(x), NA_real_, as.numeric(x)
  )))) |>
  mutate(Date = as.character(Date))


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
  )[-c(1:2),]

sheet10_truevals <- sheet10 |>
  filter(if_any(everything(), ~ !is.na(.)))

## Check that there are the right number/names rows and columns ####

if (sum(sheet2$`Is it available?`[7:14] == 1) > 0) {
  nrow(sheet10_truevals) > 0
} else {
  nrow(sheet10_truevals) == 0
}

all(
  colnames(sheet10_truevals) == c(
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


## Check for missing required fields ####

# Missing data availability specification

if (sum(sheet2$`Is it available?`[7:14] == 1) > 0) {
  required_fields_sheet10 = c(1,2)
  check_fields(sheet10_truevals, required_fields_sheet10)
}

## Set column types ####

sheet10_cols_typed <-  sheet10_truevals |>
  mutate(across(where(is.character), (\(x) ifelse(x == "NA", NA, x)))) |>
  mutate(across(all_of(c(2:10)), (\(x) ifelse(
    is.na(x), NA_real_, as.numeric(x)
  )))) |>
  mutate(Date = as.character(Date),
         Time = as.character(Time))


## Store typed data ####

box_write(
  sheet10_cols_typed,
  "sheet10.csv",
  write_fun = readr::write_excel_csv,
  dir_id = qa_box_folder_id
)
