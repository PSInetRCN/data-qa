
sheet1_expectations <-
  read.csv(here::here("checks", "expectations", "01_site.csv"))

# Import and add dataset_name

sheet1 <- import_sheet(dataset_path, 1, sheet1_expectations)

sheet1 <- sheet1 |>
  mutate(
    dataset_name = dataset_identifier,
    .before = 1)

if(!is_sfn) {
  sheet1$study <- dataset_identifier
  sheet1$multi_site <- FALSE
}