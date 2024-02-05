library(boxr)
library(dplyr)

source(here::here("general-scripts", "box_auth.R"))


# Setup ####

dataset_identifier <- "Flo_1"

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
  message("Problem with nrow!")
}

if(sum(sheet_dims$cols_ok) != 10){
  message("Problem with ncol!")
}
