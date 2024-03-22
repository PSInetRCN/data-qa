# Organization

- `admin_scripts` holds scripts for getting data from Box, updating dataset_tracking.
- `checks` holds scripts for QA checks (never modify) and detailed results of checks run on each dataset.
- `data` holds raw and processed data. Both stay out of git.
- `sfn_ingestion_scripts` holds scripts for converting SFN data to the PSInet template.
- `template_ingestion_scripts` holds scripts for QA of datasets in the PSInet template format (either from SFN or from data contributors).
- `dataset_tracking.csv` keeps track of datasets and where they are in the QA process.
- `sfn_to_template_tracking.csv` keeps track of where SFN datasets are in the process of getting converted to the PSInet template. 

# Setup

* Clone this repo.
* Download data files from Box and store them in the `data` directory. These stay *out of git*.

# Individual datasets

* Start from the "import_template" script. Work through it and modify until the checks pass.
* Save-as as "dataset_name.R" in the `individual_scripts` directory.

