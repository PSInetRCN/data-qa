library(boxr)
library(dplyr)

source(here::here("general-scripts", "box_auth.R"))


# Setup ####

dataset_identifier <- "Keen_1"

tracking_sheet <- box_read_excel("1426404123641")

this_dataset_row <-
  which(tracking_sheet$dataset_name == dataset_identifier)
raw_box_id <- tracking_sheet[this_dataset_row, "raw_box_file_ID"]
qa_box_folder_id <-
  tracking_sheet[this_dataset_row, "qa_box_folder_ID"]


# Check that there is one .csv for each expected sheet #### 

qa_files <- as.data.frame(box_ls(qa_box_folder_id)) |>
  filter(!grepl(".xlsx", name)) |>
  mutate(sheet = gsub(".csv", "", name))

qa_file_names <- paste0("sheet", 1:10, ".csv")

if(!(all(qa_file_names %in% qa_files$name))) {
  message("Cannot find .csvs on box!")
}

# Load files #### 

all_sheets <- lapply(qa_files$id, box_read_csv)

names(all_sheets) <- qa_files$sheet

# Check dims ####

get_sheet_dims <- function(sheet) {
  
  data.frame(n_rows = nrow(sheet),
             n_cols = ncol(sheet))
  
}


expected_sheet_dims <- read.csv(here::here("checks", "expected_sheet_dims.csv"))

sheet_dims <- lapply(all_sheets, get_sheet_dims) |>
  bind_rows(.id = "sheet") |>
  left_join(expected_sheet_dims) |>
  rowwise() |>
  mutate(rows_ok = n_rows >= min_rows && n_rows <= max_rows,
         cols_ok = n_cols == expected_cols)

if(sum(sheet_dims$rows_ok) != 10) {
  message("Problem with nrow!")
}

if(sum(sheet_dims$cols_ok) != 10){
  message("Problem with ncol!")
}





# Classes #### 

get_sheet_types <- function(sheet) {
  sapply(sheet, class)
}

sheet_classes <- lapply(all_sheets, get_sheet_types)

sheet_classes$sheet1[12] <- "character"
sheet_classes$sheet1[6] <- "character"
sheet_classes$sheet2[5] <- "character"
sheet_classes$sheet2[7:8] <- "numeric"
sheet_classes$sheet2[9] <- "character"
sheet_classes$sheet3[2:3] <- "logical"
sheet_classes$sheet3[4:8] <- "character"

# Pick up here setting the expected classes for the sheets
# Then save those as an object
# Then create a check loading each .csv with the types set and check for errors

sheet_classed <- box_read_csv(qa_files$id[1], colClasses = sheet_classes$sheet1)
str(sheet_classed)
