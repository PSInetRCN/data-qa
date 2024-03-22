
sheet8_expectations <-
  read.csv(here::here("checks", "expectations", "08_automated.csv"))

# Import and add dataset_name

sheet8 <- import_sheet(dataset_path, 8, sheet8_expectations)

sheet8 <- sheet8 |>
  mutate(dataset_name = dataset_identifier, .before = 1)
