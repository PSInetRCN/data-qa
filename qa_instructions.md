# Data QA instructions


## Data intake 

1. A data contributor uploads their data to Box and fills in the form at <https://viz.datascience.arizona.edu/psinet-data-submission>. 
1. Their survey responses get sent to the `datasheet_responses` data frame in Posit Connect.
1. Within a day, Renata will be notified of their response via an emailed .Rmd from Posit Connect.
 
## Set up infrastructure

1. Renata runs `general_scripts/template_data/01_update_submission_data.R` to update `submission_survey_responses.xlsx` on Box with the survey data from Posit Connect.
1. Renata runs `general_scripts/template_data/02_add_dataset_identifiers.R` to set up the box folders for any new datasets and update `dataset_tracking.xlsx` on Box.

## Ingest data

1. For each dataset, open `dataset_scripts/01_copy_sheets_and_check_types.R` and save-as to create a new script for this dataset.
1. Modify this script to read in each sheet from the new dataset, check that it has the right dims, set the column types, and save it as a series of .csv files in box.

## Check data

1. Run `checks/01-csvs-and-types.R` for each new dataset. This checks that the expected .csv files exist and that they have the expected data types. If there are any errors they will show up in `errors_list` and will be saved to box as `errors_01.csv`. *Either update the data ingestion script or work with the authors to resolve any errors*.
1. Run `checks/02-design-and-variables.R`. This checks that the experimental design is internally consistent and that all expected data variables are provided. If there are any errors they will show up in `errors_list` and will be saved to box as `errors_02.csv`. *Either update the data ingestion script or work with the authors to resolve any errors*.

For both data checking steps: If you modify the data ingestion script to make substantive changes to the data as they come in - e.g. changing IDs, changing NAs to FALSE, etc - add these to a 'notes' data frame at the end of the data ingestion script and write this to a file named `changes.txt` on box. There is code in the data ingestion script to do this.

When the check scripts are run, `dataset_tracking.xlsx` on Box will be updated. The columns `completed_checks_1` and `completed_checks_2` will be updated to `1` if the check script runs without errors and to `2` if the check script ran with errors. 
