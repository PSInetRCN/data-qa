
sheet6_expectations <-
  read.csv(here::here("checks", "expectations", "06_plants.csv"))

# Import and add dataset_name

sheet6 <- import_sheet(dataset_path, 6, sheet6_expectations)

sheet6 <- sheet6 |>
  mutate(dataset_name = dataset_identifier, .before = 1)
