veg_types <- read.csv(here::here("general-scripts", "veg_types.csv"))
veg_types <- veg_types |>
  mutate(number = substr(Name, 1, 2),
         Type = trimws(substr(Name, 3, nchar(Name))))|>
  mutate(Type = tolower(Type))

veg_types2 <- read.csv(here::here("general-scripts", "veg_types2.csv"))

veg_types2 <- veg_types2 |>
  tidyr::separate_wider_delim(Type, delim = ":", names = c("Type", "Description"), too_few = "align_start") |>
  mutate(Type = tolower(Type))

veg_types2$Type[1] <- "barren"

veg_types3 <- left_join(veg_types, veg_types2)

write.csv(veg_types3, here::here("general-scripts", "veg_types_use.csv"))