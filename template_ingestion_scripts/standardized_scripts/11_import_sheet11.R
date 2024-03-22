
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
