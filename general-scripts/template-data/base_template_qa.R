library(boxr)
library(dplyr)

source(here::here("general-scripts", "box_auth.R"))

#' This script is for general-purpose QA of datasets submitted using the PSInet template.
#'

dataset_identifier <- 9
raw_box_id <- 1418283786880

# load each sheet into a data frame ####

## Sheet 1. Study and site information ####

sheet1 <- box_read_excel(raw_box_id, sheet = 2,
                         col_types = "text")[2,-1]


## Sheet 2. Data description ####

sheet2 <- box_read_excel(raw_box_id, sheet = 3,
                         col_types = "text")[-1,-1]

## Sheet 3. Additional data availability ####

sheet3 <- box_read_excel(raw_box_id, sheet = 4,
                         col_types = "text")[-1,-1]

## Sheet 4. Treatments ####

sheet4 <-  box_read_excel(raw_box_id, sheet = 5,
                          col_types = "text")[-1, 2:4]

## Sheet 5. Plots ####

sheet5 <-  box_read_excel(raw_box_id, sheet = 6,
                          col_types = "text")[-1, -1]

## Sheet 6. Plants ####

sheet6 <- box_read_excel(raw_box_id, sheet = 7,
                         col_types = "text")[-1, -1]

## Sheet 7. Pressure chamber WP ####

sheet7_cols <- box_read_excel(raw_box_id,
                              sheet = 8,
                              n_max = 0,
                              col_types = "text")[,-1]

sheet7 <-
  box_read_excel(
    raw_box_id,
    sheet = 8,
    col_names = colnames(sheet7_cols),
    col_types = c(
      "skip",
      "text",
      "text",
      "text",
      "date",
      "text",
      "text",
      "text",
      "text",
      "text"
    )
  )[-c(1:2),]

## Sheet 8. Automated WP ####

sheet8_cols <- box_read_excel(raw_box_id,
                              sheet = 9,
                              n_max = 0)[,-1]

sheet8 <-
  box_read_excel(
    raw_box_id,
    sheet = 9,
    col_names = colnames(sheet8_cols),
    col_types = c(
      "skip",
      "text",
      "text",
      "text",
      "date",
      "text",
      "text",
      "text",
      "text",
      "text"
    )
  )[-c(1:2),]


## Sheet 9. Soil moisture ####

sheet9 <-
  box_read_excel(
    raw_box_id,
    sheet = 10)[-1,-1]

## Sheet 10. Met data ####

sheet10  <-
  box_read_excel(
    raw_box_id,
    sheet = 11)[-1,-1]

# perform QA level checks on each data frame
# flag errors