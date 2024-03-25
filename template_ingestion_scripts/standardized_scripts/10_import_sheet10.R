
sheet10_expectations <-
  read.csv(here::here("checks", "expectations", "10_met.csv"))

# Import and add dataset_name

sheet10 <- import_sheet(dataset_path, 10, sheet10_expectations)

sheet10 <- sheet10 |>
  mutate(dataset_name = dataset_identifier, .before = 1)


sheet10_vals <- sheet10 |>
  select(4:11) |>
  is.na() |>
  rowSums()

if(any(sheet10_vals < 8)) {
sheet10 <- sheet10[which(sheet10_vals < 8), ]
}