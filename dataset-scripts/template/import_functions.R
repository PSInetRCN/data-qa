set_col_types <- function(sheet, sheet_expectations) {
  sheet |>
    mutate(across(all_of(
      which(sheet_expectations$Type == "character")
    ), (
      \(x) ifelse(is.na(x), NA_character_, as.character(x))
    )),
    across(all_of(
      which(sheet_expectations$Type == "integer")
    ), (
      \(x) ifelse(is.na(x), NA_integer_, as.integer(x))
    )),
    across(all_of(
      which(sheet_expectations$Type == "logical")
    ), (\(x) ifelse(
      is.na(x), NA, as.logical(x)
    ))),
    across(all_of(
      which(sheet_expectations$Type == "numeric")
    ), (
      \(x) ifelse(is.na(x), NA_real_, as.numeric(x))
    )))
  
}

import_sheet <-
  function(template_path,
           sheet_number,
           sheet_expectations) {
    sheets_ranges <- data.frame(
      sheet = 1:11,
      sheet_to_read = 2:12,
      sheet_ranges = c("B3:P3",
                       "B3:J16",
                       "B3:I15",
                       "2:4",
                       "2:13",
                       rep(NA, 6)),
      range_is_explicit = c(T,
                            T,
                            T,
                            F,
                            F,
                            rep(NA, 6))
    )
    
    toread <-
      sheets_ranges[which(sheets_ranges$sheet == sheet_number),]
    
    if (toread$range_is_explicit[1]) {
      imported_sheet <-
        readxl::read_xlsx(
          dataset_path,
          sheet = toread$sheet_to_read[1],
          range = toread$sheet_ranges[1],
          col_names = sheet_expectations$Cleaned_column_name[-1],
          col_types = "text"
        )
    } else {
      colnums <-
        strsplit(toread$sheet_ranges[1], ":") |>  unlist() |> as.numeric()
      
      imported_sheet <-
        readxl::read_xlsx(
          dataset_path,
          sheet = toread$sheet_to_read[1],
          range = cell_limits(ul = c(3, colnums[1]),
                              lr = c(NA, colnums[2])),
          col_names = sheet_expectations$Cleaned_column_name[-1],
          col_types = "text"
        )
    }
    
    colnames(imported_sheet) <-
      sheet_expectations$Cleaned_column_name[-1]
    
    imported_sheet
  }
