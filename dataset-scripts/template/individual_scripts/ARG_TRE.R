# This is a starting point for importing template datasets into PSInet.
# Identify yourself - for signing outcomes report ####

my_initials <- "RMD"

# Identify dataset ####

dataset_identifier <- "ARG_TRE"

is_sfn <- TRUE

if (is_sfn) {
  dataset_path <-
    here::here("data",
               "sfn_as_psinet",
               paste0(dataset_identifier, "_as_psinet.xlsx"))
} else {
  dataset_path <-
    here::here("data",
               "received_dat",
               "template",
               paste0(dataset_identifier, ".xlsx"))
}
# Import things ####

library(dplyr)
library(readxl)

source(here::here("checks", "check_functions.R"))
source(here::here("checks", "check_design_functions.R"))
source(here::here("dataset-scripts", "template", "import_functions.R"))

dataset_tracking <- read.csv(here::here("dataset_tracking.csv"))

# Sheet 1. Study and site information ####

sheet1_expectations <-
  read.csv(here::here("checks", "expectations", "01_site.csv"))

# Import and add dataset_name

sheet1 <- import_sheet(dataset_path, 1, sheet1_expectations)

sheet1 <- sheet1 |>
  mutate(
    dataset_name = dataset_identifier,
    .before = 1,
    study_description = "Single-site",
    data_publication = "Yes - as part of a scientific paper"
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
  mutate(sensor_location = ifelse(
    grepl("Clearing", sensor_location),
    "Clearing (< 1 km away)",
    sensor_location
  ))

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

sheet5$vegetation_type <- "4 Deciduous broadleaf forests"

# Set col types

sheet5_cols_typed <- set_col_types(sheet5, sheet5_expectations)

# Check col types

all(check_col_classes(sheet5_cols_typed, sheet5_expectations))

# Check ranges

all(check_ranges(sheet5_cols_typed, sheet5_expectations))

# Check plot treatments

check_plot_treatments(sheet4_cols_typed, sheet5_cols_typed)

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

sheet6 <- sheet6 |>
  mutate(plot_id = "Whole study")

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
  mutate(plot_id = "Whole study")

# Set col types

sheet7_cols_typed <- set_col_types(sheet7, sheet7_expectations)

# Check col types

all(check_col_classes(sheet7_cols_typed, sheet7_expectations))

# Check ranges

all(check_ranges(sheet7_cols_typed, sheet7_expectations))

# Check that all plant-plot combos match plants table

check_plant_plot_ids(sheet6_cols_typed, sheet7_cols_typed)

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

# Set col types

sheet8_cols_typed <- set_col_types(sheet8, sheet8_expectations)

# Check col types

all(check_col_classes(sheet8_cols_typed, sheet8_expectations))

# Check ranges

all(check_ranges(sheet8_cols_typed, sheet8_expectations))


# Check that all plant-plot combos match plants table

check_plant_plot_ids(sheet6_cols_typed, sheet8_cols_typed)

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
  mutate(plot_id = "Whole study")

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

# Run all checks and add to problems report ####

outcomes_report <-
  read.csv(here::here("checks", "checks_outcomes_template.csv"))

outcomes_report$dataset_name <- dataset_identifier
outcomes_report$generated_by <- my_initials
outcomes_report$generated_at <- as.character(Sys.time())

outcomes_vect <- vector(mode = "logical",
                        length = nrow(outcomes_report))
names(outcomes_vect) <- outcomes_report$check
outcomes_vect['sheet1_classes'] <-
  all(check_col_classes(sheet1_cols_typed, sheet1_expectations))
outcomes_vect['sheet1_ranges'] <-
  all(check_ranges(sheet1_cols_typed, sheet1_expectations))
outcomes_vect['sheet2_classes'] <-
  all(check_col_classes(sheet2_cols_typed, sheet2_expectations))
outcomes_vect['sheet2_ranges'] <-
  all(check_ranges(sheet2_cols_typed, sheet2_expectations))
outcomes_vect['sheet3_classes'] <-
  all(check_col_classes(sheet3_cols_typed, sheet3_expectations))
outcomes_vect['sheet3_ranges'] <-
  all(check_ranges(sheet3_cols_typed, sheet3_expectations))
outcomes_vect['sheet4_classes'] <-
  all(check_col_classes(sheet4_cols_typed, sheet4_expectations))
outcomes_vect['sheet4_ranges'] <-
  all(check_ranges(sheet4_cols_typed, sheet4_expectations))
outcomes_vect['sheet5_classes'] <-
  all(check_col_classes(sheet5_cols_typed, sheet5_expectations))
outcomes_vect['sheet5_ranges'] <-
  all(check_ranges(sheet5_cols_typed, sheet5_expectations))
outcomes_vect['sheet5_plot_treatments_match'] <-
  check_plot_treatments(sheet4_cols_typed, sheet5_cols_typed)
outcomes_vect['sheet6_classes'] <-
  all(check_col_classes(sheet6_cols_typed, sheet6_expectations))
outcomes_vect['sheet6_ranges'] <-
  all(check_ranges(sheet6_cols_typed, sheet6_expectations))
outcomes_vect['sheet6_plot_ids_match'] <-
  check_plots(sheet5_cols_typed, sheet6_cols_typed)
outcomes_vect['sheet6_plant_plot_treatments_match'] <-
  check_plant_plot_treatments(sheet5_cols_typed, sheet6_cols_typed)
outcomes_vect['sheet6_plant_treatments_match'] <-
  check_individual_treatments(sheet4_cols_typed, sheet6_cols_typed)
outcomes_vect['sheet7_classes'] <-
  all(check_col_classes(sheet7_cols_typed, sheet7_expectations))
outcomes_vect['sheet7_ranges'] <-
  all(check_ranges(sheet7_cols_typed, sheet7_expectations))
outcomes_vect['sheet7_plant_ids_match'] <-
  ifelse(any(!is.na(sheet7_cols_typed$water_potential_mean)),
         check_plants(sheet6_cols_typed, sheet7_cols_typed),
         NA)
outcomes_vect['sheet7_plot_ids_match'] <-
  ifelse(any(!is.na(sheet7_cols_typed$water_potential_mean)),
         check_plots(sheet5_cols_typed, sheet7_cols_typed),
         NA)
outcomes_vect['sheet7_plant_plot_ids_match'] <-
  ifelse(any(!is.na(sheet7_cols_typed$water_potential_mean)),
         check_plant_plot_ids(sheet6_cols_typed, sheet7_cols_typed),
         NA)
outcomes_vect['sheet8_classes'] <-
  all(check_col_classes(sheet8_cols_typed, sheet8_expectations))
outcomes_vect['sheet8_ranges'] <-
  all(check_ranges(sheet8_cols_typed, sheet8_expectations))
outcomes_vect['sheet8_plant_ids_match'] <-
  ifelse(any(!is.na(sheet8_cols_typed$water_potential_mean)),
         check_plants(sheet6_cols_typed, sheet8_cols_typed),
         NA)
outcomes_vect['sheet8_plot_ids_match'] <-
  ifelse(any(!is.na(sheet8_cols_typed$water_potential_mean)),
         check_plots(sheet5_cols_typed, sheet8_cols_typed),
         NA)
outcomes_vect['sheet8_plant_plot_ids_match'] <-
  ifelse(any(!is.na(sheet8_cols_typed$water_potential_mean)),
         check_plant_plot_ids(sheet6_cols_typed, sheet8_cols_typed),
         NA)
outcomes_vect['sheet9_classes'] <-
  all(check_col_classes(sheet9_cols_typed, sheet9_expectations))
outcomes_vect['sheet9_ranges'] <-
  all(check_ranges(sheet9_cols_typed, sheet9_expectations))
outcomes_vect['sheet9_plant_ids_match'] <-
  ifelse(any(!is.na(sheet9_cols_typed$individual_id)),
         check_plants(sheet6_cols_typed, sheet9_cols_typed),
         NA)
outcomes_vect['sheet9_plot_ids_match'] <-
  ifelse(any(!is.na(sheet9_cols_typed$plot_id)),
         check_plots(sheet5_cols_typed, sheet9_cols_typed),
         NA)
outcomes_vect['sheet9_plant_plot_ids_match'] <-
  ifelse(all(any(
    !is.na(sheet9_cols_typed$individual_id)
  ),
  any(!is.na(
    sheet9_cols_typed$plot_id
  ))),
  check_plant_plot_ids(sheet6_cols_typed, sheet9_cols_typed),
  NA)
outcomes_vect['sheet10_classes'] <-
  all(check_col_classes(sheet10_cols_typed, sheet10_expectations))
outcomes_vect['sheet10_ranges'] <-
  all(check_ranges(sheet10_cols_typed, sheet10_expectations))
outcomes_vect['sheet11_classes'] <-
  all(check_col_classes(sheet11_cols_typed, sheet11_expectations))
outcomes_vect['sheet11_ranges'] <-
  all(check_ranges(sheet11_cols_typed, sheet11_expectations))
outcomes_vect['data_promised'] <-
  check_data_promised(
    sheet2_cols_typed,
    sheet7_cols_typed,
    sheet8_cols_typed,
    sheet9_cols_typed,
    sheet10_cols_typed
  )

outcomes_report$outcome <- outcomes_vect

# Make plans to resolve any outstanding failed checks

outcomes_report |>
  filter(!outcome)

outcomes_report$remarks[which(outcomes_report$check == "sheet10_ranges")] <- "Windspeed of 69 meters per second."

write.csv(outcomes_report,
          here::here(
            "checks",
            "reports",
            paste0(dataset_identifier, "_results.csv")
          ),
          row.names = F)

# Update dataset_tracking ####

dataset_tracking[which(dataset_tracking$dataset_name == dataset_identifier), "updated_by"] <-
  my_initials
dataset_tracking[which(dataset_tracking$dataset_name == dataset_identifier), "updated_at"] <-
  as.character(Sys.time())
dataset_tracking[which(dataset_tracking$dataset_name == dataset_identifier), "latest_status"] <-
  ifelse(any(!(outcomes_report$outcome), na.rm = T),
         "imported WITH FLAGS",
         "imported NO FLAGS")

write.csv(dataset_tracking,
          here::here("dataset_tracking.csv"),
          row.names = F)
