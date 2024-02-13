library(pins)
library(boxr)
library(dplyr)

source(here::here("general-scripts", "box_auth.R"))
submission_form_responses <- board_connect() |> 
  pin_read("renatadiaz/datasheet_responses") |>
  dplyr::select(response_ID, response, question_id) |>
  tidyr::pivot_wider(id_cols = response_ID, names_from = question_id, values_from = response)

tracking_data_so_far <- box_read_excel("1358111922570", sheet = 1)

template_submissions <- box_ls("242669643766")

head(submission_form_responses)


