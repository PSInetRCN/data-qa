# This is a starting point for importing template datasets into PSInet.

library(dplyr)
library(readxl)

source(here::here("checks", "check_functions.R"))
source(here::here("dataset-scripts", "template", "import_functions.R"))

# Setup ####

dataset_tracking <- read.csv(here::here("dataset_tracking.csv"))
problems <-
  read.csv(here::here("problems.csv"), colClasses = "character")

dataset_identifier <- "Flo_1"

is_sfn <- FALSE

dataset_path <-
  here::here("data",
             "received_dat",
             "template",
             paste0(dataset_identifier, ".xlsx"))

# Sheet 1. Study and site information ####

sheet1_expectations <-
  read.csv(here::here("checks", "expectations", "01_site.csv"))

# Import and add dataset_name

sheet1 <- import_sheet(dataset_path, 1, sheet1_expectations)

sheet1 <- sheet1 |>
  mutate(
    dataset_name = dataset_identifier,
    .before = 1,
    study_description = "Single-site"
  )

# Add any needed code here until the last checks pass

# Set col types

sheet1_cols_typed <- set_col_types(sheet1, sheet1_expectations)

# Check col types

all(check_col_classes(sheet1_cols_typed, sheet1_expectations))

# Check ranges

all(check_ranges(sheet1_cols_typed, sheet1_expectations))

# Write csv

write.csv(sheet1_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet1.csv")
          ),
          row.names = F)

# Sheet 2. Data description ####

sheet2_expectations <-
  read.csv(here::here("checks", "expectations", "02_data_description.csv"))

# Import and add dataset_name

sheet2 <- import_sheet(dataset_path, 2, sheet2_expectations)

sheet2 <- sheet2 |>
  mutate(dataset_name = dataset_identifier, .before = 1)

# Add any needed code here until the last checks pass

sheet2 <- sheet2 |>
  mutate(is_it_available = ifelse(is_it_available == 1, TRUE, FALSE))

# Set col types

sheet2_cols_typed <- set_col_types(sheet2, sheet2_expectations)

# Check col types

all(check_col_classes(sheet2_cols_typed, sheet2_expectations))

# Check ranges

all(check_ranges(sheet2_cols_typed, sheet2_expectations))

write.csv(sheet2_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet2.csv")
          ),
          row.names = F)

# Sheet 3. Additional data availability ####

sheet3_expectations <-
  read.csv(here::here("checks", "expectations", "03_additional_data.csv"))

# Import and add dataset_name

sheet3 <- import_sheet(dataset_path, 3, sheet3_expectations)

sheet3 <- sheet3 |>
  mutate(dataset_name = dataset_identifier, .before = 1)

# Add any needed code here until the last checks pass

sheet3 <- sheet3 |>
  mutate(availability = ifelse(availability == 1, TRUE, FALSE))

# Set col types

sheet3_cols_typed <- set_col_types(sheet3, sheet3_expectations)

# Check col types

all(check_col_classes(sheet3_cols_typed, sheet3_expectations))

# Check ranges

all(check_ranges(sheet3_cols_typed, sheet3_expectations))

write.csv(sheet3_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet3.csv")
          ),
          row.names = F)

# Sheet 4. Treatments ####

sheet4_expectations <-
  read.csv(here::here("checks", "expectations", "04_treatments.csv"))

# Import and add dataset_name

sheet4 <- import_sheet(dataset_path, 4, sheet4_expectations)

sheet4 <- sheet4 |>
  mutate(dataset_name = dataset_identifier, .before = 1)

# Add any needed code here until the last checks pass

# Set col types

sheet4_cols_typed <- set_col_types(sheet4, sheet4_expectations)

# Check col types

all(check_col_classes(sheet4_cols_typed, sheet4_expectations))

# Check ranges

all(check_ranges(sheet4_cols_typed, sheet4_expectations))

write.csv(sheet4_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet4.csv")
          ),
          row.names = F)

# Sheet 5. Plots ####

sheet5_expectations <-
  read.csv(here::here("checks", "expectations", "05_plots.csv"))

# Import and add dataset_name

sheet5 <- import_sheet(dataset_path, 5, sheet5_expectations)

sheet5 <- sheet5 |>
  mutate(dataset_name = dataset_identifier, .before = 1)

# Add any needed code here until the last checks pass

sheet5$growth_condition <- "Naturally regenerated, unmanaged"

# Set col types

sheet5_cols_typed <- set_col_types(sheet5, sheet5_expectations)

# Check col types

all(check_col_classes(sheet5_cols_typed, sheet5_expectations))

# Check ranges

all(check_ranges(sheet5_cols_typed, sheet5_expectations))

write.csv(sheet5_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet5.csv")
          ),
          row.names = F)

# Sheet 6. Plants ####

sheet6_expectations <-
  read.csv(here::here("checks", "expectations", "06_plants.csv"))

# Import and add dataset_name

sheet6 <- import_sheet(dataset_path, 6, sheet6_expectations)

sheet6 <- sheet6 |>
  mutate(dataset_name = dataset_identifier, .before = 1)

# Add any needed code here until the last checks pass

# Set col types

sheet6_cols_typed <- set_col_types(sheet6, sheet6_expectations)

# Check col types

all(check_col_classes(sheet6_cols_typed, sheet6_expectations))

# Check ranges

all(check_ranges(sheet6_cols_typed, sheet6_expectations))

write.csv(sheet6_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet6.csv")
          ),
          row.names = F)

# Sheet 7. Pressure chamber WP ####

sheet7_expectations <-
  read.csv(here::here("checks", "expectations", "07_pressure_chamber.csv"))

# Import and add dataset_name

sheet7 <- import_sheet(dataset_path, 7, sheet7_expectations)

sheet7 <- sheet7 |>
  mutate(dataset_name = dataset_identifier, .before = 1)

# Add any needed code here until the last checks pass

sheet7 <- sheet7 |>
  mutate(time_num = as.numeric(time)) |>
  mutate(time_seconds = 60 * 60 * 24 * time_num) |>
  mutate(time_POSIX = as.POSIXct(time_seconds, origin = "1901-01-01", tz = "GMT")) |>
  mutate(time = format(time_POSIX, format = "%H:%M:%S")) |>
  select(-time_num,-time_seconds,-time_POSIX)

# Set col types

sheet7_cols_typed <- set_col_types(sheet7, sheet7_expectations)

# Check col types

all(check_col_classes(sheet7_cols_typed, sheet7_expectations))

# Check ranges

all(check_ranges(sheet7_cols_typed, sheet7_expectations))

write.csv(sheet7_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet7.csv")
          ),
          row.names = F)

# Sheet 8. Automated WP ####

sheet8_expectations <-
  read.csv(here::here("checks", "expectations", "08_automated.csv"))

# Import and add dataset_name

sheet8 <- import_sheet(dataset_path, 8, sheet8_expectations)

sheet8 <- sheet8 |>
  mutate(dataset_name = dataset_identifier, .before = 1)

# Add any needed code here until the last checks pass

sheet8 <- sheet8 |>
  mutate(time_num = as.numeric(time)) |>
  mutate(time_seconds = 60 * 60 * 24 * time_num) |>
  mutate(time_POSIX = as.POSIXct(time_seconds, origin = "1901-01-01", tz = "GMT")) |>
  mutate(time = format(time_POSIX, format = "%H:%M:%S")) |>
  select(-time_num,-time_seconds,-time_POSIX)

# Set col types

sheet8_cols_typed <- set_col_types(sheet8, sheet8_expectations)

# Check col types

all(check_col_classes(sheet8_cols_typed, sheet8_expectations))

# Check ranges

all(check_ranges(sheet8_cols_typed, sheet8_expectations))

write.csv(sheet8_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet8.csv")
          ),
          row.names = F)

# Sheet 9. Soil moisture ####

sheet9_expectations <-
  read.csv(here::here("checks", "expectations", "09_soil.csv"))

# Import and add dataset_name

sheet9 <- import_sheet(dataset_path, 9, sheet9_expectations)

sheet9 <- sheet9 |>
  mutate(dataset_name = dataset_identifier, .before = 1)

# Add any needed code here until the last checks pass

sheet9 <- sheet9 |>
  mutate(date_num = as.numeric(date)) |>
  mutate(date_date = as.Date(date_num, origin = "1899-12-30")) |>
  mutate(date_f = format(date_date, format = "%Y%m%d")) |>
  mutate(date = date_f) |>
  select(-date_num,-date_date,-date_f)

# Set col types

sheet9_cols_typed <- set_col_types(sheet9, sheet9_expectations)

# Check col types

all(check_col_classes(sheet9_cols_typed, sheet9_expectations))

# Check ranges

all(check_ranges(sheet9_cols_typed, sheet9_expectations))

write.csv(sheet9_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet9.csv")
          ),
          row.names = F)

# Sheet 10. Met data ####

sheet10_expectations <-
  read.csv(here::here("checks", "expectations", "10_met.csv"))

# Import and add dataset_name

sheet10 <- import_sheet(dataset_path, 10, sheet10_expectations)

sheet10 <- sheet10 |>
  mutate(dataset_name = dataset_identifier, .before = 1)

# Add any needed code here until the last checks pass

# Set col types

sheet10_cols_typed <- set_col_types(sheet10, sheet10_expectations)

# Check col types

all(check_col_classes(sheet10_cols_typed, sheet10_expectations))

# Check ranges

all(check_ranges(sheet10_cols_typed, sheet10_expectations))

write.csv(sheet10_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet10.csv")
          ),
          row.names = F)

# Sheet 11 SFN codes ####

sheet11_expectations <-
  read.csv(here::here("checks", "expectations", "11_codes.csv"))

if (is_sfn) {
  # Import and add dataset_name
  
  sheet11 <- import_sheet(dataset_path, 11, sheet11_expectations)
  
  sheet11 <- sheet11 |>
    mutate(dataset_name = dataset_identifier, .before = 1)
  
} else {
  sheet11 <- data.frame(pl_name = NA_character_,
                        pl_code = NA_character_,
                        measured_sfn = NA)
}

sheet11 <- sheet11 |>
  mutate(dataset_name = dataset_identifier, .before = 1)

# Add any needed code here until the last checks pass

# Set col types

sheet11_cols_typed <- set_col_types(sheet11, sheet11_expectations)

# Check col types

all(check_col_classes(sheet11_cols_typed, sheet11_expectations))

# Check ranges

all(check_ranges(sheet11_cols_typed, sheet11_expectations))

write.csv(sheet11_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet11.csv")
          ),
          row.names = F)
