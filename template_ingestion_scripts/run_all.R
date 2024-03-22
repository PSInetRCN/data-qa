ind_scripts <- list.files(here::here("dataset-scripts", "template", "individual_scripts"), pattern = ".R", full.names = T)

purrr::map(ind_scripts, .f = source)
