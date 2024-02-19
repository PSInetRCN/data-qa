library(boxr)
library(dplyr)

source(here::here("general-scripts", "box_auth.R"))

error_list <- vector(mode = "character")

# Setup ####

dataset_identifier <- "Sturchio_1"

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

if(!(all(qa_file_names %in% qa_files$name))) {
  error_list <- c(error_list, "Cannot find .csvs on box")
}

# Load files #### 

expected_sheet_classes <- readRDS(here::here("checks", "expected_sheet_classes.Rds"))

all_sheets <- purrr::map2(qa_files$id,
                          expected_sheet_classes,
                          .f = \(x, y) box_read_csv(file_id = x,
                                                    colClasses = y)) 
names(all_sheets) = qa_files$sheet

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
  error_list <- c(error_list, "Problem with nrow")
}

if(sum(sheet_dims$cols_ok) != 10){
  error_list <- c(error_list, "Problem with ncol")
}

# Check classes #### 

get_col_classes <- function(x) {
  sapply(x, class)
}

sheet_classes <- lapply(all_sheets, get_col_classes) 

compare_sheet_classes <- function(expected_classes, actual_classes) {
  not_char <- which(actual_classes[expected_classes$character] != "character")
  not_int <- which(actual_classes[expected_classes$integer] != "integer")
  not_num <- which(actual_classes[expected_classes$numeric] != "numeric")
  
  return(c(not_char, not_int, not_num))
}

all_compares <- purrr::map2(expected_sheet_classes,
                            sheet_classes,
                          .f = compare_sheet_classes)
all_compares_lengths <- lapply(all_compares, FUN = length) |> unlist()

if(any(all_compares_lengths != 0)) {
  error_list <- c(error_list, "Col classes error")
}

# Summarize errors and update tracking#### 

if(length(error_list) == 0) {
  error_list = "All good!"
  tracking_sheet[this_dataset_row, "completed_checks_1"] <- 1
} else {
  tracking_sheet[this_dataset_row, "completed_checks_1"] <- 2
}

error_df <- data.frame(
  dataset_identifier  = dataset_identifier,
  qa_box_folder_id = qa_box_folder_id,
  errors = error_list
)

box_write(error_df, paste0(dataset_identifier, "_errors_01.csv"), dir_id = qa_box_folder_id)

# Update dataset tracking #### 

box_write(tracking_sheet, "dataset_tracking.xlsx", "230431401206")

