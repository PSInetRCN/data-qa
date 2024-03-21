
if (is_sfn) {
  dataset_path <-
    here::here("data",
               "sfn_as_psinet",
               paste0(dataset_identifier, "_as_psinet.xlsx"))
} else {
  dataset_path <-
    here::here("data",
               "received_dat",
               "template",
               paste0(dataset_identifier, ".xlsx"))
}
# Import things ####

library(dplyr)
library(readxl)

source(here::here("checks", "check_functions.R"))
source(here::here("checks", "check_design_functions.R"))
source(here::here("dataset-scripts", "template", "import_functions.R"))

dataset_tracking <- read.csv(here::here("dataset_tracking.csv"))
