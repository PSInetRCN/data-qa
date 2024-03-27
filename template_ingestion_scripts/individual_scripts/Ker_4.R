# This is a starting point for importing template datasets into PSInet.
# Identify yourself - for signing outcomes report ####

my_initials <- "RMD"

# Identify dataset ####

dataset_identifier <- "Ker_4"

is_sfn <- FALSE

source(here::here(
  "template_ingestion_scripts",
  "standardized_scripts",
  "00_set_up.R"
))

# Sheet 1. Study and site information ####

# Import

source(here::here(
  "template_ingestion_scripts",
  "standardized_scripts",
    "01_import_sheet1.R"
  )
)

# Add any needed code here until the checks pass

sheet1$longitude_wgs84
sheet1$latitude_wgs84 

# Set col types

sheet1_cols_typed <- set_col_types(sheet1, sheet1_expectations)

# Check col types
all(check_col_classes(sheet1_cols_typed, sheet1_expectations))

# Check ranges
all(check_ranges(sheet1_cols_typed, sheet1_expectations))

# Check that no required columns have nas
check_required_columns(sheet1, sheet1_expectations)

# Write csv
write.csv(sheet1_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet1.csv")
          ),
          row.names = F)

# Sheet 2. Data description ####

source(here::here(
  "template_ingestion_scripts",
  "standardized_scripts",
    "02_import_sheet2.R"
  )
)

# Add any needed code here until the last checks pass

# Set col types

sheet2_cols_typed <- set_col_types(sheet2, sheet2_expectations)

# Check col types

all(check_col_classes(sheet2_cols_typed, sheet2_expectations))

# Check ranges

all(check_ranges(sheet2_cols_typed, sheet2_expectations))

# Check required columns

check_required_columns(sheet2_cols_typed, sheet2_expectations)

# Check units

check_sheet2_units(sheet2_cols_typed)

write.csv(sheet2_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet2.csv")
          ),
          row.names = F)

# Sheet 3. Additional data availability ####

source(here::here(
  "template_ingestion_scripts",
  "standardized_scripts",
    "03_import_sheet3.R"
  )
)

# Add any needed code here until the last checks pass

# Set col types

sheet3_cols_typed <- set_col_types(sheet3, sheet3_expectations)

# Check col types

all(check_col_classes(sheet3_cols_typed, sheet3_expectations))

# Check ranges

all(check_ranges(sheet3_cols_typed, sheet3_expectations))

# Check required columns

check_required_columns(sheet3_cols_typed, sheet3_expectations)

write.csv(sheet3_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet3.csv")
          ),
          row.names = F)

# Sheet 4. Treatments ####

source(here::here(
  "template_ingestion_scripts",
  "standardized_scripts",
  "04_import_sheet4.R"
)
)

# Add any needed code here until the last checks pass

sheet4

# Set col types

sheet4_cols_typed <- set_col_types(sheet4, sheet4_expectations)

# Check col types

all(check_col_classes(sheet4_cols_typed, sheet4_expectations))

# Check ranges

all(check_ranges(sheet4_cols_typed, sheet4_expectations))

# Check required columns

check_required_columns(sheet4_cols_typed, sheet4_expectations)

write.csv(sheet4_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet4.csv")
          ),
          row.names = F)

# Sheet 5. Plots ####

source(here::here(
  "template_ingestion_scripts",
  "standardized_scripts",
    "05_import_sheet5.R"
  )
)

# Add any needed code here until the last checks pass

sheet5

sheet5 <- sheet5 |>
  mutate(plot_id = "Whole study")

# Set col types

sheet5_cols_typed <- set_col_types(sheet5, sheet5_expectations)

# Check col types

all(check_col_classes(sheet5_cols_typed, sheet5_expectations))

# Check ranges

all(check_ranges(sheet5_cols_typed, sheet5_expectations))

# Check plot treatments

check_plot_treatments(sheet4_cols_typed, sheet5_cols_typed)

# Check required columns

check_required_columns(sheet5_cols_typed, sheet5_expectations)

write.csv(sheet5_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet5.csv")
          ),
          row.names = F)

# Sheet 6. Plants ####

source(here::here(
  "template_ingestion_scripts",
  "standardized_scripts",
    "06_import_sheet6.R"
  )
)

# Add any needed code here until the last checks pass

sheet6 

# Set col types

sheet6_cols_typed <- set_col_types(sheet6, sheet6_expectations)

# Check col types

all(check_col_classes(sheet6_cols_typed, sheet6_expectations))

# Check ranges

all(check_ranges(sheet6_cols_typed, sheet6_expectations))

# Check plot IDs and treatments

check_plant_plot_treatments(sheet5_cols_typed, sheet6_cols_typed)

# Check individual treatments

check_individual_treatments(sheet4_cols_typed, sheet6_cols_typed)

# Check required columns

check_required_columns(sheet6_cols_typed, sheet6_expectations)

write.csv(sheet6_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet6.csv")
          ),
          row.names = F)

# Sheet 7. Pressure chamber WP ####

source(here::here(
  "template_ingestion_scripts",
  "standardized_scripts",
    "07_import_sheet7.R"
  )
)

# Add any needed code here until the last checks pass

sheet7

sheet7 <- sheet7 |>
  mutate(time_num = as.numeric(time)) |>
  mutate(time_seconds = 60 * 60 * 24 * time_num) |>
  mutate(time_POSIX = as.POSIXct(time_seconds, origin = "1901-01-01", tz = "GMT")) |>
  mutate(time = format(time_POSIX, format = "%H:%M:%S")) |>
  select(-time_num,-time_seconds,-time_POSIX) |>
  mutate(water_potential_mean = paste0("-", water_potential_mean))

# Set col types

sheet7_cols_typed <- set_col_types(sheet7, sheet7_expectations)

# Check col types

all(check_col_classes(sheet7_cols_typed, sheet7_expectations))

# Check ranges

all(check_ranges(sheet7_cols_typed, sheet7_expectations))

# Check that all plant-plot combos match plants table

check_plant_plot_ids(sheet6_cols_typed, sheet7_cols_typed)

# Check required columns

if(sheet2_cols_typed$is_it_available[1]) {
  check_required_columns(sheet7_cols_typed, sheet7_expectations)
}

write.csv(sheet7_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet7.csv")
          ),
          row.names = F)

# Sheet 8. Automated WP ####

source(here::here(
  "template_ingestion_scripts",
  "standardized_scripts",
    "08_import_sheet8.R"
  )
)

# Add any needed code here until the last checks pass

sheet8


# Set col types

sheet8_cols_typed <- set_col_types(sheet8, sheet8_expectations)

# Check col types

all(check_col_classes(sheet8_cols_typed, sheet8_expectations))

# Check ranges

all(check_ranges(sheet8_cols_typed, sheet8_expectations))

# Check that all plant-plot combos match plants table

check_plant_plot_ids(sheet6_cols_typed, sheet8_cols_typed)

# Check required columns

if(sheet2_cols_typed$is_it_available[2]) {
  check_required_columns(sheet8_cols_typed, sheet7_expectations)
}

write.csv(sheet8_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet8.csv")
          ),
          row.names = F)

# Sheet 9. Soil moisture ####

source(here::here(
  "template_ingestion_scripts",
  "standardized_scripts",
    "09_import_sheet9.R"
  )
)

# Add any needed code here until the last checks pass

sheet9

# Set col types

sheet9_cols_typed <- set_col_types(sheet9, sheet9_expectations)

# Check col types

all(check_col_classes(sheet9_cols_typed, sheet9_expectations))

# Check ranges

all(check_ranges(sheet9_cols_typed, sheet9_expectations))

# Check that all plant-plot combos match plants table

if (any(!is.na(sheet9_cols_typed$individual_id))) {
  check_plant_plot_ids(sheet6_cols_typed, sheet9_cols_typed)
}

# Check that all plots occur in plots table

if (any(!is.na(sheet9_cols_typed$plot_id))) {
  check_plots(sheet5_cols_typed, sheet9_cols_typed)
}

# Check required columns

if(any(sheet2_cols_typed$is_it_available[3:6])) {
  check_required_columns(sheet9_cols_typed, sheet9_expectations)
}

write.csv(sheet9_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet9.csv")
          ),
          row.names = F)

# Sheet 10. Met data ####

source(here::here(
  "template_ingestion_scripts",
  "standardized_scripts",
    "10_import_sheet10.R"
  )
)

# Add any needed code here until the last checks pass

sheet10


# Set col types

sheet10_cols_typed <- set_col_types(sheet10, sheet10_expectations)

# Check col types

all(check_col_classes(sheet10_cols_typed, sheet10_expectations))

# Check ranges

all(check_ranges(sheet10_cols_typed, sheet10_expectations))

# Check required columns

if(any(sheet2_cols_typed$is_it_available[7:14])) {
  check_required_columns(sheet10_cols_typed, sheet10_expectations)
}

write.csv(sheet10_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet10.csv")
          ),
          row.names = F)

# Sheet 11 SFN codes ####

source(here::here(
  "template_ingestion_scripts",
  "standardized_scripts",
    "11_import_sheet11.R"
  )
)

# Add any needed code here until the last checks pass

# Set col types

sheet11_cols_typed <- set_col_types(sheet11, sheet11_expectations)

# Check col types

all(check_col_classes(sheet11_cols_typed, sheet11_expectations))

# Check ranges

all(check_ranges(sheet11_cols_typed, sheet11_expectations))

# Check required columns

if(is_sfn) {
  check_required_columns(sheet11_cols_typed, sheet11_expectations)
}

write.csv(sheet11_cols_typed,
          here::here(
            "data",
            "processed_psinet",
            paste0(dataset_identifier, "_sheet11.csv")
          ),
          row.names = F)

# Run all checks ####

source(here::here(
  "template_ingestion_scripts",
  "standardized_scripts",
    "12_run_all_checks.R"
  )
)

outcomes_report |>
  filter(!outcome)

flag_summary <- "Note positive WP values changed to negative"


if(all(sum(!outcomes_report$outcome, na.rm =T) == 1,
       outcomes_report[which(!outcomes_report$outcome), "check"] == "sheet10_ranges")) {
  flag_summary <- "Met values out of range"
}


write.csv(outcomes_report,
          here::here(
            "checks",
            "reports",
            paste0(dataset_identifier, "_results.csv")
          ),
          row.names = F)

# Update dataset tracking ####

source(here::here(
  "template_ingestion_scripts",
  "standardized_scripts",
    "13_update_dataset_tracking.R"
  )
)

