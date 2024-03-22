
sheet4_expectations <-
  read.csv(here::here("checks", "expectations", "04_treatments.csv"))

# Import and add dataset_name

sheet4 <- import_sheet(dataset_path, 4, sheet4_expectations)

sheet4 <- sheet4 |>
  mutate(dataset_name = dataset_identifier, .before = 1)
