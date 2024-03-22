
sheet9_expectations <-
  read.csv(here::here("checks", "expectations", "09_soil.csv"))

# Import and add dataset_name

sheet9 <- import_sheet(dataset_path, 9, sheet9_expectations)

sheet9 <- sheet9 |>
  mutate(dataset_name = dataset_identifier, .before = 1)
