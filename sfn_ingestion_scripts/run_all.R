sfn_scripts <- list.files(here::here("sfn_ingestion_scripts", "individual_scripts"), pattern = ".R", full.names = T)

purrr::map(sfn_scripts, .f = source)
