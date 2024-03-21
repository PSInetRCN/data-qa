check_plot_treatments <- function(sheet4, sheet5) {
  
  plot_treatments <-
    sheet4 |>
    filter(level_of_treatment %in% c("Whole study", "Stand/plot/transect", "Site"))
  
  if(nrow(plot_treatments) == 0) {
    plot_treatments <- data.frame(treatment_id = "No treatment")
  }
  
  all(sheet5$treatment_id %in% plot_treatments$treatment_id, na.rm = FALSE)
  
}

check_individual_treatments <- function(sheet4, sheet6) {
  
  individual_treatments <-
    sheet4 |>
    filter(level_of_treatment %in% c("Individual", "Site"))
  
  if(nrow(individual_treatments) == 0) {
    individual_treatments <- data.frame(treatment_id = "No treatment")
  }
  
  all(sheet6$individual_treatment_id %in% individual_treatments$treatment_id, na.rm = FALSE)
}

check_plant_plot_treatments <- function(sheet5, sheet6) {
  
  plant_plot_combos <- sheet6 |>
    select(plot_id, plot_treatment_id) |>
    distinct() |>
    arrange(plot_id) |>
    rename(treatment_id = plot_treatment_id)
  
  plot_plot_combos <- sheet5 |>
    select(plot_id, treatment_id) |>
    distinct() |>
    arrange(plot_id)
  
  all.equal(plant_plot_combos, plot_plot_combos)
  
}

check_plant_plot_ids <- function(sheet6, data_sheet) {
  
  sheet6_combos <- sheet6 |>
    select(plot_id, individual_id) |>
    distinct() |>
    arrange(plot_id, individual_id) |>
    mutate(in_sheet_6 = TRUE)
  
  data_sheet_combos <- data_sheet |> 
    select(plot_id, individual_id) |>
    distinct() |>
    arrange(plot_id, individual_id) |>
    left_join(sheet6_combos, by = c("plot_id", "individual_id"))
  
  all(data_sheet_combos$in_sheet_6, na.rm = T)
  
}

check_plots <- function(sheet5, data_sheet) {
  
  valid_plot_ids <- unique(sheet5$plot_id)
  
  all(data_sheet$plot_id %in% valid_plot_ids)
  
}


check_plants <- function(sheet6, data_sheet) {
  
  valid_plant_ids <- unique(sheet6$individual_id)
  
  all(data_sheet$individual_id %in% valid_plant_ids)
  
}

check_data_promised <- function(data_avail, wp_pc, wp_au, sm, metdat, detail = FALSE) {
  
  data_avail <- data_avail |>
    mutate(expected_not_provided = is_it_available)
  
  if(data_avail$is_it_available[1]) {
    if(any(!is.na(wp_pc$water_potential_mean))) {
      data_avail$expected_not_provided[1] <- FALSE
    }
  }
  
  if(data_avail$is_it_available[2]) {
    if(any(!is.na(wp_au$water_potential_mean))) {
      data_avail$expected_not_provided[2] <- FALSE
    }
  }
  
  if(data_avail$is_it_available[3]) {
    if(any(!is.na(sm$swc_mean_shallow))) {
      data_avail$expected_not_provided[3] <- FALSE
    }
  }
  
  if(data_avail$is_it_available[4]) {
    if(any(!is.na(sm$swc_mean_deep))) {
      data_avail$expected_not_provided[4] <- FALSE
    }
  }
  
  
  if(data_avail$is_it_available[5]) {
    if(any(!is.na(sm$swp_mean_shallow))) {
      data_avail$expected_not_provided[5] <- FALSE
    }
  }
  
  if(data_avail$is_it_available[6]) {
    if(any(!is.na(sm$swp_mean_deep))) {
      data_avail$expected_not_provided[6] <- FALSE
    }
  }
  
  
  if(data_avail$is_it_available[7]) {
    if(any(!is.na(metdat$precipitation_mm))) {
      data_avail$expected_not_provided[7] <- FALSE
    }
  }
  if(data_avail$is_it_available[8]) {
    if(any(!is.na(metdat$relative_humidity_percent))) {
      data_avail$expected_not_provided[8] <- FALSE
    }
  }
  if(data_avail$is_it_available[9]) {
    if(any(!is.na(metdat$vapor_pressure_deficit_k_pa))) {
      data_avail$expected_not_provided[9] <- FALSE
    }
  }
  if(data_avail$is_it_available[10]) {
    if(any(!is.na(metdat$air_temperature_c))) {
      data_avail$expected_not_provided[10] <- FALSE
    }
  }
  if(data_avail$is_it_available[11]) {
    if(any(!is.na(metdat$photosynthetically_active_radiation_ppfd_mumol_photon_m_2_s_1))) {
      data_avail$expected_not_provided[11] <- FALSE
    }
  }
  if(data_avail$is_it_available[12]) {
    if(any(!is.na(metdat$incident_shortwave_radiation))) {
      data_avail$expected_not_provided[12] <- FALSE
    }
  }
  if(data_avail$is_it_available[13]) {
    if(any(!is.na(metdat$net_radiation_m_s_1))) {
      data_avail$expected_not_provided[13] <- FALSE
    }
  } 
  if(data_avail$is_it_available[14]) {
    if(any(!is.na(metdat$windspeed_m_s))) {
      data_avail$expected_not_provided[14] <- FALSE
    }
  }
  
  if(detail) {
    return(data_avail |>
             select(data_variable,
                    expected_not_provided))
  }
  
  return(all(!data_avail$expected_not_provided))
  
}
