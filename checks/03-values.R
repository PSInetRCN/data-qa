library(boxr)
library(dplyr)

source(here::here("general-scripts", "box_auth.R"))
source(here::here("general-scripts", "check_email.R"))


error_list <- vector(mode = "character")

# Setup ####

dataset_identifier <- "Flo_2"

tracking_sheet <- box_read_excel("1426404123641")

this_dataset_row <-
  which(tracking_sheet$dataset_name == dataset_identifier)
raw_box_id <- tracking_sheet[this_dataset_row, "raw_box_file_ID"]
qa_box_folder_id <-
  tracking_sheet[this_dataset_row, "qa_box_folder_ID"]


# Check that there is one .csv for each expected sheet ####

qa_files <- as.data.frame(box_ls(qa_box_folder_id)) |>
  filter(!grepl(".xlsx", name)) |>
  filter(!grepl("error", name)) |>
  filter(!grepl("changes.txt", name)) |>
  mutate(sheet = gsub(".csv", "", name),
         file_order = c(1, 10, 2:9)) |>
  arrange(file_order)

qa_file_names <- paste0("sheet", 1:10, ".csv")

if (!(all(qa_file_names %in% qa_files$name))) {
  error_list <- c(error_list, "Cannot find .csvs on box")
}

# Load files ####

expected_sheet_classes <-
  readRDS(here::here("checks", "expected_sheet_classes.Rds"))

all_sheets <- purrr::map2(qa_files$id,
                          expected_sheet_classes,
                          .f = \(x, y) box_read_csv(file_id = x,
                                                    colClasses = y))
names(all_sheets) = qa_files$sheet

# Check values Sheet 1 ####

sheet1 <- all_sheets$sheet1

if(!(check_email(sheet1$Email[1]))) {
  error_list <- c(error_list, "Email provided is not valid")
}

if(sheet1$`End year` < sheet1$`Begin year`) {
  error_list <- c(error_list, "End year precedes begin year")
}

if(!(check_in_range(sheet1$`Begin year`, data_ranges$year))) {
  error_list <- c(error_list, "Begin year is not valid")
}

if(!(check_in_range(sheet1$`End year`, data_ranges$year))) {
  error_list <- c(error_list, "End year is not valid")
}

if(!(check_in_range(sheet1$`Latitude (WGS84)`, data_ranges$lat))) {
  error_list <- c(error_list, "Lat is not valid")
}

if(!(check_in_range(sheet1$`Longitude (WGS84)`, data_ranges$long))) {
  error_list <- c(error_list, "Long is not valid")
}

# Check values Sheet 2 ####

sheet2 <- all_sheets$sheet2

# No checks at present.

# Check values Sheet 3 #### 

sheet3 <- all_sheets$sheet3

# No checks at present.

# Check values Sheet 4 ####

sheet4 <- all_sheets$sheet4

# No checks at present.

# Check values Sheet 5 ####

sheet5 <- all_sheets$sheet5

if(!(check_in_range(sheet5$`Percent clay`, data_ranges$percents))){
  error_list <- c(error_list, "Percent clay not a percent")
}
