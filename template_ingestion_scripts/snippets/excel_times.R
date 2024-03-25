sheetX <- sheetX |>
  mutate(time_num = as.numeric(time)) |>
  mutate(time_seconds = 60 * 60 * 24 * time_num) |>
  mutate(time_POSIX = as.POSIXct(time_seconds, origin = "1901-01-01", tz = "GMT")) |>
  mutate(time = format(time_POSIX, format = "%H:%M:%S")) |>
  select(-time_num,-time_seconds,-time_POSIX) 