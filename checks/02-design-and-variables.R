library(boxr)
library(dplyr)

source(here::here("general-scripts", "box_auth.R"))

error_list <- vector(mode = "character")

# Setup ####

dataset_identifier <- "Flo_1"

tracking_sheet <- box_read_excel("1426404123641")

this_dataset_row <-
  which(tracking_sheet$dataset_name == dataset_identifier)
raw_box_id <- tracking_sheet[this_dataset_row, "raw_box_file_ID"]
qa_box_folder_id <-
  tracking_sheet[this_dataset_row, "qa_box_folder_ID"]


# Check that there is one .csv for each expected sheet ####

qa_files <- as.data.frame(box_ls(qa_box_folder_id)) |>
  filter(!grepl(".xlsx", name)) |>
  filter(!grepl("error", name)) |>
  mutate(sheet = gsub(".csv", "", name),
         file_order = c(1, 10, 2:9)) |>
  arrange(file_order)

qa_file_names <- paste0("sheet", 1:10, ".csv")

if (!(all(qa_file_names %in% qa_files$name))) {
  error_list <- c(error_list, "Cannot find .csvs on box")
}

# Load files ####

expected_sheet_classes <-
  readRDS(here::here("checks", "expected_sheet_classes.Rds"))

all_sheets <- purrr::map2(qa_files$id,
                          expected_sheet_classes,
                          .f = \(x, y) box_read_csv(file_id = x,
                                                    colClasses = y))
names(all_sheets) = qa_files$sheet

# Check required cols Sheet 1 ####

sheet1_required_cols <- c(1, 2, 3, 4, 5, 7, 8, 9, 10, 11)
if (all_sheets$sheet1$`Data publication?` != "Not published") {
  sheet1_required_cols <- c(sheet1_required_cols, 6)
}

if (any(is.na(all_sheets$sheet1[, sheet1_required_cols]))) {
  error_list <-
    c(error_list, "Sheet 1 has NA for a required variable")
}

# Check required cols Sheet 2 ####

sheet2_required_cols <- all_sheets$sheet2 |>
  select(1, 2)

if (any(is.na(sheet2_required_cols))) {
  error_list <-
    c(error_list, "Sheet 2 has NA where a variable should be specified")
}

sheet2_required_units <- all_sheets$sheet2 |>
  filter(`Is it available?`) |>
  select(Units)

if (any(is.na(sheet2_required_units))) {
  error_list <-
    c(error_list, "Sheet 2 is missing a unit specification")
}

sheet2_required_methodology <- all_sheets$sheet2 |>
  filter(`Is it available?`) |>
  filter(grepl("Plant water potential", `Data variable`)) |>
  select(`Methodology or Instrument`)

if (any(is.na(sheet2_required_methodology))) {
  error_list <- c(error_list, "Sheet 2 is missing PWP methodology")
}

sheet2_required_soildepths <- all_sheets$sheet2 |>
  filter(`Is it available?`) |>
  filter(grepl("Soil water", `Data variable`)) |>
  select(starts_with("Soil depth"))

if (any(is.na(sheet2_required_soildepths))) {
  error_list <-
    c(error_list, "Sheet 2 is missing a soil depth specification")
}

# Check required cols Sheet 3 ####

sheet3_required_cols <- all_sheets$sheet3 |>
  select(1, 2)

if (any(is.na(sheet3_required_cols))) {
  error_list <- c(error_list, "Sheet 3 is missing required cols")
}

sheet3_required_publication <- all_sheets$sheet3 |>
  filter(Availability) |>
  select(Publication)

if (any(is.na(sheet3_required_publication))) {
  error_list <-
    c(error_list,
      "Sheet 3 is missing whether or not something is published")
}

# Check requirements sheet 4 ####

sheet4_required_cols <- all_sheets$sheet4 |>
  select(1:2)

if (any(is.na(sheet4_required_cols))) {
  error_list <- c(error_list, "Sheet 4 is missing required cols")
}

sheet4_required_descriptions <- all_sheets$sheet4 |>
  filter(!(`Treatment ID` %in% c("No treatment", "Control"))) |>
  select(`Treatment description`)

if (any(is.na(sheet4_required_descriptions))) {
  error_list <-
    c(error_list, "Sheet 4 has a treatment that is not described")
}

# Check requirements Sheet 5 ####

sheet5_required_cols <- all_sheets$sheet5 |>
  select(1, 2)

if (any(is.na(sheet5_required_cols))) {
  error_list <- c(error_list, "Sheet 5 is missing required cols")
}

if (any(!(
  all_sheets$sheet5$`Treatment ID` %in% all_sheets$sheet4$`Treatment ID`
))) {
  error_list <-
    c(error_list,
      "Plot(s) have a treatment not defined in the treatment table")
}

# Check requirements Sheet 6 ####

sheet6_required_cols <- all_sheets$sheet6 |>
  select(1, 2, 3, 4, 5, 6, 7)

if (any(is.na(sheet6_required_cols))) {
  error_list <- c(error_list, "Sheet 6 is missing required cols")
}

if (any(!(
  all_sheets$sheet6$Plot_Treatment_ID %in% all_sheets$sheet4$`Treatment ID`
))) {
  error_list <-
    c(error_list,
      "A plot in the plant table has a treatment not defined in the treatment table")
}

if (any(
  !(
    all_sheets$sheet6$Individual_Treatment_ID %in% all_sheets$sheet4$`Treatment ID`
  )
)) {
  error_list <-
    c(
      error_list,
      "An individual in the plant table has a treatment not defined in the treatment table"
    )
}

sheet5_plot_treatments <- all_sheets$sheet5 |>
  select(`Plot ID`, `Treatment ID`) |>
  mutate(in_sheet_5 = T)

sheet6_plot_treatments <- all_sheets$sheet6 |>
  select(Plot_ID, Plot_Treatment_ID) |>
  distinct() |>
  left_join(
    sheet5_plot_treatments,
    by = c("Plot_ID" = "Plot ID",
           "Plot_Treatment_ID" = "Treatment ID")
  )

if (any(is.na(sheet6_plot_treatments$in_sheet_5))) {
  error_list <-
    c(error_list,
      "Plants table has a plot-treatment combination not in the Plots table")
}

if (any(!(all_sheets$sheet5$`Plot ID` %in% all_sheets$sheet6$Plot_ID))) {
  error_list <-
    c(error_list,
      "Plot(s) defined in the Plots table do not show up in the Plants table")
}

if (any(!(
  all_sheets$sheet4$`Treatment ID` %in% c(
    all_sheets$sheet6$Plot_Treatment_ID,
    all_sheets$sheet6$Individual_Treatment_ID
  )
))) {
  error_list <-
    c(
      error_list,
      "Treatment(s) defined in the Treatments table do not show up in the Plants table"
    )
}


sheet6_plants_plots <- all_sheets$sheet6 |>
  select(Individual_ID, Plot_ID) |>
  distinct() |>
  mutate(in_sheet6 = T)

# Check requirements Sheet 7 ####

if (all_sheets$sheet2$`Is it available?`[1]) {
  sheet7_required_cols <- all_sheets$sheet7 |>
    select(1, 2, 3, 4, 5, 7, 8, 9) |>
    summarise(across(everything(), .fns = \(x) all(is.na(x))))
  
  if (any(sheet7_required_cols[1,])) {
    error_list <-
      c(error_list, "Sheet 7 is missing a required variable")
  }
  
  if (any(!(
    all_sheets$sheet7$Individual_ID %in% all_sheets$sheet6$Individual_ID
  ))) {
    error_list <-
      c(error_list,
        "Sheet 7 contains an Individual not listed in the Plants table")
  }
  
  if (any(!(all_sheets$sheet7$Plot_ID %in% all_sheets$sheet5$`Plot ID`))) {
    error_list <-
      c(error_list,
        "Sheet 7 contains a Plot not listed in the Plots table")
  }
  
  sheet7_plants_plots <- all_sheets$sheet7 |>
    select(Individual_ID, Plot_ID) |>
    distinct() |>
    left_join(sheet6_plants_plots)
  
  if (any(!(sheet7_plants_plots$in_sheet6))) {
    error_list <-
      c(error_list,
        "Sheet 7 contains a Plant-Plot combo not in the Plants table")
  }
}


# Check requirements Sheet 8 ####

if (all_sheets$sheet2$`Is it available?`[2]) {
  sheet8_required_cols <- all_sheets$sheet8 |>
    select(1, 2, 3, 4, 5, 7, 8, 9) |>
    summarise(across(everything(), .fns = \(x) all(is.na(x))))
  
  if (any(sheet8_required_cols[1,])) {
    error_list <-
      c(error_list, "Sheet 8 is missing a required variable")
  }
  
  if (any(!(
    (all_sheets$sheet8$Individual_ID) %in% all_sheets$sheet6$Individual_ID
  ))) {
    error_list <-
      c(error_list,
        "Sheet 8 contains an Individual not listed in the Plants table")
  }
  
  if (any(!((all_sheets$sheet8$Plot_ID) %in% all_sheets$sheet5$`Plot ID`))) {
    error_list <-
      c(error_list,
        "Sheet 8 contains a Plot not listed in the Plots table")
  }
  
  sheet8_plants_plots <- all_sheets$sheet8 |>
    select(Individual_ID, Plot_ID) |>
    distinct() |>
    left_join(sheet6_plants_plots)
  
  if (any(!(sheet8_plants_plots$in_sheet6))) {
    error_list <-
      c(error_list,
        "Sheet 8 contains a Plant-Plot combo not in the Plants table")
  }
}

# Check requirements Sheet 9 ####

sheet2_required_soildepths <- all_sheets$sheet2 |>
  filter(`Is it available?`) |>
  filter(grepl("Soil water", `Data variable`)) |>
  select(`Data variable`)

if (nrow(sheet2_required_soildepths) > 0) {
  sheet9_cols_expanded <-
    data.frame(sheet9_col = colnames(all_sheets$sheet9)[5:16],
               sheet9_colnum = 5:16) |>
    group_by_all() |>
    mutate(
      sheet9_prefix = ifelse(grepl("C", sheet9_col), "SWC", "SWP"),
      sheet9_suffix = ifelse(grepl("deep", sheet9_col), "deep", "shallow")
    ) |>
    ungroup()
  
  sheet2_sheet9_key <-
    data.frame(sheet2_names = all_sheets$sheet2$`Data variable`[which(grepl("Soil ", all_sheets$sheet2$`Data variable`))]) |>
    mutate(
      sheet9_prefix = c("SWC", "SWC", "SWP", "SWP"),
      sheet9_suffix = c("shallow", "deep", "shallow", "deep")
    )
  
  sheet9_required_sm_cols <- sheet2_required_soildepths |>
    left_join(sheet2_sheet9_key, by = c("Data variable" = "sheet2_names")) |>
    left_join(sheet9_cols_expanded)
  
  sheet9_required_cols <- all_sheets$sheet9 |>
    select(c(2, 3, 4, sheet9_required_sm_cols$sheet9_colnum)) |>
    summarize(across(everything(), .fn = \(x) all(is.na(x))))
  
  if (any(is.na(sheet9_required_cols[1,]))) {
    error_list <-
      c(error_list, "Soil water data is missing an expected variable")
  }
  
  if (any(!(na.omit(all_sheets$sheet9$Plot_ID) %in% all_sheets$sheet5$`Plot ID`))) {
    error_list <-
      c(error_list,
        "Soil water data has a Plot ID not listed in Plots table")
  }
  
  if (any(!(
    na.omit(all_sheets$sheet9$Individual_ID) %in% all_sheets$sheet6$Individual_ID
  ))) {
    error_list <-
      c(error_list,
        "Soil water data has an Individual ID not listed in Plants table")
  }
}

# Check requirements Sheet 10 ####

sheet2_required_met <- all_sheets$sheet2[7:14, ] |>
  filter(`Is it available?`)

if (nrow(sheet2_required_met) > 0) {
  sheet2_sheet10_key <- data.frame(
    sheet2_col = all_sheets$sheet2$`Data variable`[7:14],
    sheet10_col = colnames(all_sheets$sheet10)[3:10],
    sheet10_coln = 3:10
  )
  
  sheet10_required_met_cols <- sheet2_required_met |>
    left_join(sheet2_sheet10_key, by = c("Data variable" = "sheet2_col"))
  
  sheet10_required_cols <- all_sheets$sheet10 |>
    select(1, 2, sheet10_required_met_cols$sheet10_coln) |>
    summarize(across(everything(), .fn = \(x) all(is.na(x))))
  
  if (any(sheet10_required_cols[1, ])) {
    error_list <-
      c(error_list, "Sheet 10 is missing an expected variable")
  }
  
  sheet10_no_na_cols <- all_sheets$sheet10 |>
    select(Date, Time) |>
    summarize(across(everything(), .fn = \(x) any(is.na(x))))
  
  if (any(sheet10_no_na_cols[1, ])) {
    error_list <- c(error_list, "Sheet 10 has an NA date or time")
  }
  
}

# Summarize error list ####

if(length(error_list) == 0) {
  error_list = "All good!"
}

error_df <- data.frame(
  dataset_identifier  = dataset_identifier,
  qa_box_folder_id = qa_box_folder_id,
  errors = error_list
)
box_write(error_df, paste0(dataset_identifier, "_errors_02.csv"), dir_id = qa_box_folder_id)
