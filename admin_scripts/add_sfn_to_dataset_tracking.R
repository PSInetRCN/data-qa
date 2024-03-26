library(dplyr)

dataset_tracking <- read.csv(here::here("dataset_tracking.csv")) |>
  mutate(source = "PSInet")

sfn_to_template <- read.csv(here::here("sfn_to_template_tracking.csv"))

sfn_to_add <- mutate(sfn_to_template,
                          response_ID = row_number() * -1) |>
 # filter(next_step == "template qa") |>
  mutate(latest_status = ifelse(next_step == "template qa", "to template", "need more info"),
         updated_by = "RMD",
         updated_at = as.character(Sys.time()),
         source = "SFN") |>
  filter(!(response_ID %in% dataset_tracking$response_ID)) |>  
  select(response_ID, dataset_name, latest_status, source, updated_at, updated_by) 


updated_dataset_tracking <- bind_rows(dataset_tracking, sfn_to_add)

write.csv(updated_dataset_tracking, here::here("dataset_tracking.csv"), row.names = F)
