sheetX <- sheetX |> 
  mutate(date_num = as.numeric(date)) |>
  mutate(date_date = as.Date(date_num, origin = "1899-12-30")) |>
  mutate(date_f = format(date_date, format = "%Y%m%d")) |>
  mutate(date = date_f) |>
  select(-date_num, -date_date, -date_f)