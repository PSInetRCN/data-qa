source(here::here("template_ingestion_scripts", "snippets", "to_dd.R"))

sheet1 <- sheet1 |>
  mutate(latitude_wgs84 = to_dd(substr(latitude_wgs84, 1,2),
                                substr(latitude_wgs84, 4,5),
                                substr(latitude_wgs84, 7,8),
                                dir = "N"),
         longitude_wgs84 = to_dd(substr(longitude_wgs84, 1,2),
                                 substr(longitude_wgs84, 4,5),
                                 substr(longitude_wgs84, 7,8),
                                 dir = "W"))

sheet1 <- sheet1 |>
  tidyr::separate_wider_position(
    latitude_wgs84,
    widths = c(
      lat_deg = 2,
      drop1 = 1,
      lat_min = 2,
      drop2 = 1,
      lat_sec = 4,
      drop3 = 2,
      lat_dir = 1
    ),
    cols_remove = F
  ) |>
  select(-drop1, -drop2, -drop3) |>
  tidyr::separate_wider_position(
    longitude_wgs84,
    widths = c(
      lon_deg = 3,
      drop1 = 1,
      lon_min = 2,
      drop2 = 1,
      lon_sec = 4,
      drop3 = 2,
      lon_dir = 1
    ),
    cols_remove = F
  ) |>
  select(-drop1, -drop2, -drop3) |>
  mutate(
    latitude_wgs84 = as.numeric(lat_deg) +
      (as.numeric(lat_min) / 60) +
      (as.numeric(lat_sec) / 3600),
    longitude_wgs84 = -1 *
      (as.numeric(lon_deg) +
         (as.numeric(lon_min) / 60) +
         (as.numeric(lon_sec) / 3600))
  ) |>
  select(-c(
    lon_deg,
    lon_min,
    lon_sec,
    lat_deg,
    lat_min,
    lat_sec,
    lon_dir,
    lat_dir
  ))