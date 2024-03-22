# Run all checks and add to problems report ####

outcomes_report <-
  read.csv(here::here("checks", "checks_outcomes_template.csv"))

outcomes_report$dataset_name <- dataset_identifier
outcomes_report$generated_by <- my_initials
outcomes_report$generated_at <- as.character(Sys.time())

outcomes_vect <- vector(mode = "logical",
                        length = nrow(outcomes_report))
names(outcomes_vect) <- outcomes_report$check
outcomes_vect['sheet1_classes'] <-
  all(check_col_classes(sheet1_cols_typed, sheet1_expectations))
outcomes_vect['sheet1_ranges'] <-
  all(check_ranges(sheet1_cols_typed, sheet1_expectations))
outcomes_vect['sheet1_required_cols'] <- 
  check_required_columns(sheet1_cols_typed, sheet1_expectations)
outcomes_vect['sheet2_classes'] <-
  all(check_col_classes(sheet2_cols_typed, sheet2_expectations))
outcomes_vect['sheet2_ranges'] <-
  all(check_ranges(sheet2_cols_typed, sheet2_expectations))
outcomes_vect['sheet2_required_cols'] <- 
  check_required_columns(sheet2_cols_typed, sheet2_expectations)
outcomes_vect['sheet2_units'] <- 
  check_sheet2_units(sheet2_cols_typed)
outcomes_vect['sheet3_classes'] <-
  all(check_col_classes(sheet3_cols_typed, sheet3_expectations))
outcomes_vect['sheet3_ranges'] <-
  all(check_ranges(sheet3_cols_typed, sheet3_expectations))
outcomes_vect['sheet3_required_cols'] <- 
  check_required_columns(sheet3_cols_typed, sheet3_expectations)
outcomes_vect['sheet4_classes'] <-
  all(check_col_classes(sheet4_cols_typed, sheet4_expectations))
outcomes_vect['sheet4_ranges'] <-
  all(check_ranges(sheet4_cols_typed, sheet4_expectations))
outcomes_vect['sheet4_required_cols'] <- 
  check_required_columns(sheet4_cols_typed, sheet4_expectations)
outcomes_vect['sheet5_classes'] <-
  all(check_col_classes(sheet5_cols_typed, sheet5_expectations))
outcomes_vect['sheet5_ranges'] <-
  all(check_ranges(sheet5_cols_typed, sheet5_expectations))
outcomes_vect['sheet5_plot_treatments_match'] <-
  check_plot_treatments(sheet4_cols_typed, sheet5_cols_typed)
outcomes_vect['sheet5_required_cols'] <- 
  check_required_columns(sheet5_cols_typed, sheet5_expectations)
outcomes_vect['sheet6_classes'] <-
  all(check_col_classes(sheet6_cols_typed, sheet6_expectations))
outcomes_vect['sheet6_ranges'] <-
  all(check_ranges(sheet6_cols_typed, sheet6_expectations))
outcomes_vect['sheet6_plot_ids_match'] <-
  check_plots(sheet5_cols_typed, sheet6_cols_typed)
outcomes_vect['sheet6_plant_plot_treatments_match'] <-
  check_plant_plot_treatments(sheet5_cols_typed, sheet6_cols_typed)
outcomes_vect['sheet6_plant_treatments_match'] <-
  check_individual_treatments(sheet4_cols_typed, sheet6_cols_typed)
outcomes_vect['sheet6_required_cols'] <- 
  check_required_columns(sheet6_cols_typed, sheet6_expectations)
outcomes_vect['sheet7_classes'] <-
  all(check_col_classes(sheet7_cols_typed, sheet7_expectations))
outcomes_vect['sheet7_ranges'] <-
  all(check_ranges(sheet7_cols_typed, sheet7_expectations))
outcomes_vect['sheet7_plant_ids_match'] <-
  ifelse(sheet2_cols_typed$is_it_available[1],
         check_plants(sheet6_cols_typed, sheet7_cols_typed),
         NA)
outcomes_vect['sheet7_plot_ids_match'] <-
  ifelse(sheet2_cols_typed$is_it_available[1],
         check_plots(sheet5_cols_typed, sheet7_cols_typed),
         NA)
outcomes_vect['sheet7_plant_plot_ids_match'] <-
  ifelse(sheet2_cols_typed$is_it_available[1],
         check_plant_plot_ids(sheet6_cols_typed, sheet7_cols_typed),
         NA)
outcomes_vect['sheet7_required_cols'] <- 
  ifelse(sheet2_cols_typed$is_it_available[1],
         check_required_columns(sheet7_cols_typed, sheet7_expectations),
         NA)
outcomes_vect['sheet8_classes'] <-
  all(check_col_classes(sheet8_cols_typed, sheet8_expectations))
outcomes_vect['sheet8_ranges'] <-
  all(check_ranges(sheet8_cols_typed, sheet8_expectations))
outcomes_vect['sheet8_plant_ids_match'] <-
  ifelse(sheet2_cols_typed$is_it_available[2],
         check_plants(sheet6_cols_typed, sheet8_cols_typed),
         NA)
outcomes_vect['sheet8_plot_ids_match'] <-
  ifelse(sheet2_cols_typed$is_it_available[2],
         check_plots(sheet5_cols_typed, sheet8_cols_typed),
         NA)
outcomes_vect['sheet8_plant_plot_ids_match'] <-
  ifelse(sheet2_cols_typed$is_it_available[2],
         check_plant_plot_ids(sheet6_cols_typed, sheet8_cols_typed),
         NA)
outcomes_vect['sheet8_required_cols'] <- 
  ifelse(sheet2_cols_typed$is_it_available[2],
         check_required_columns(sheet8_cols_typed, sheet8_expectations),
         NA)
outcomes_vect['sheet9_classes'] <-
  all(check_col_classes(sheet9_cols_typed, sheet9_expectations))
outcomes_vect['sheet9_ranges'] <-
  all(check_ranges(sheet9_cols_typed, sheet9_expectations))
outcomes_vect['sheet9_plant_ids_match'] <-
  ifelse(any(!is.na(sheet9_cols_typed$individual_id)),
         check_plants(sheet6_cols_typed, sheet9_cols_typed),
         NA)
outcomes_vect['sheet9_plot_ids_match'] <-
  ifelse(any(!is.na(sheet9_cols_typed$plot_id)),
         check_plots(sheet5_cols_typed, sheet9_cols_typed),
         NA)
outcomes_vect['sheet9_plant_plot_ids_match'] <-
  ifelse(all(any(
    !is.na(sheet9_cols_typed$individual_id)
  ),
  any(!is.na(
    sheet9_cols_typed$plot_id
  ))),
  check_plant_plot_ids(sheet6_cols_typed, sheet9_cols_typed),
  NA)
outcomes_vect['sheet9_required_cols'] <- 
  ifelse(any(sheet2_cols_typed$is_it_available[3:6]),
         check_required_columns(sheet9_cols_typed, sheet9_expectations),
         NA)
outcomes_vect['sheet10_classes'] <-
  all(check_col_classes(sheet10_cols_typed, sheet10_expectations))
outcomes_vect['sheet10_ranges'] <-
  all(check_ranges(sheet10_cols_typed, sheet10_expectations))
outcomes_vect['sheet10_required_cols'] <- 
  ifelse(any(sheet2_cols_typed$is_it_available[7:14]),
    check_required_columns(sheet10_cols_typed, sheet10_expectations),
    NA)
outcomes_vect['sheet11_classes'] <-
  all(check_col_classes(sheet11_cols_typed, sheet11_expectations))
outcomes_vect['sheet11_ranges'] <-
  all(check_ranges(sheet11_cols_typed, sheet11_expectations))
outcomes_vect['sheet11_required_cols'] <- 
  ifelse(is_sfn,
         check_required_columns(sheet11_cols_typed, sheet11_expectations),
         NA)
outcomes_vect['data_promised'] <-
  check_data_promised(
    sheet2_cols_typed,
    sheet7_cols_typed,
    sheet8_cols_typed,
    sheet9_cols_typed,
    sheet10_cols_typed
  )

outcomes_report$outcome <- outcomes_vect

