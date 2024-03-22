ind_scripts <- list.files(here::here("template_ingestion_scripts", "individual_scripts"), pattern = ".R", full.names = T)

purrr::map(ind_scripts, .f = source)
