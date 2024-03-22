library(pins)
library(boxr)
library(dplyr)

source(here::here("general-scripts", "box_auth.R"))

submission_form_responses <- board_connect() |> 
  pin_read("renatadiaz/parsed_datasheet_responses") 

submission_data_so_far <- box_read_excel("1426293112360", sheet = 1)

submission_data_updated <- submission_data_so_far |>
  mutate(response_ID = as.numeric(response_ID)) |>
  bind_rows(submission_form_responses |> filter(!(response_ID %in% submission_data_so_far$response_ID)))

box_write(submission_data_updated, "submission_survey_responses.xlsx", dir_id = "230431401206")
