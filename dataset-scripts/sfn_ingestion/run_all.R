sfn_scripts <- list.files(here::here("dataset-scripts", "sfn_ingestion", "individual_scripts"), pattern = ".R", full.names = T)

purrr::map(sfn_scripts, .f = source)
