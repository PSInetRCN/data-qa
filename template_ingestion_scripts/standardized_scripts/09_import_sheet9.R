
sheet9_expectations <-
  read.csv(here::here("checks", "expectations", "09_soil.csv"))

# Import and add dataset_name

sheet9 <- import_sheet(dataset_path, 9, sheet9_expectations)

sheet9 <- sheet9 |>
  mutate(dataset_name = dataset_identifier, .before = 1)

sheet9_vals <- sheet9[,6:17] |> is.na() |> rowSums()

if(any(sheet9_vals < 12)) {
  sheet9 <- sheet9[ which(sheet9_vals < 12), ]
}