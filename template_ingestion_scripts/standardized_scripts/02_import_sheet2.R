
sheet2_expectations <-
  read.csv(here::here("checks", "expectations", "02_data_description.csv"))

# Import and add dataset_name

sheet2 <- import_sheet(dataset_path, 2, sheet2_expectations)

sheet2 <- sheet2 |>
  mutate(dataset_name = dataset_identifier, .before = 1,
         sensor_location = ifelse(grepl("Clearing", sensor_location),
                                  "Clearing",
                                  sensor_location)) 
