library(readxl)
library(tidyr)
library(dplyr)
library(openxlsx)

#### Specify site name

sfn_site <- "ESP_YUN_T1_THI" # Change this to match each site

#### Establish connections to files ####

blank_psinet_template <- lapply(
  2:11,
  FUN = function(x)
    readxl::read_xlsx(
      here::here("sfn_ingestion_scripts", "PSInet_template_SFNStudy.xlsx")
,
      sheet = x
    )
)

names(blank_psinet_template) <- paste0("sheet", 1:10)

sfn_site_md <-
  read.csv(here::here(
    "data",
    "received_dat",
    "sfn",
    "md",
    paste0(sfn_site, "_site_md.csv")
  ))

sfn_stand_md <-
  read.csv(here::here(
    "data",
    "received_dat",
    "sfn",
    "md",
    paste0(sfn_site, "_stand_md.csv")
  ))

sfn_species_md <-
  read.csv(here::here(
    "data",
    "received_dat",
    "sfn",
    "md",
    paste0(sfn_site, "_species_md.csv")
  ))

sfn_plant_md <-
  read.csv(here::here(
    "data",
    "received_dat",
    "sfn",
    "md",
    paste0(sfn_site, "_plant_md.csv")
  ))

sfn_env_md <-
  read.csv(here::here(
    "data",
    "received_dat",
    "sfn",
    "md",
    paste0(sfn_site, "_env_md.csv")
  ))

sfn_sapflow <-
  read.csv(here::here(
    "data",
    "received_dat",
    "sfn",
    "md",
    paste0(sfn_site, "_sapf_data.csv")
  ))

sfn_env <-
  read.csv(here::here(
    "data",
    "received_dat",
    "sfn",
    "md",
    paste0(sfn_site, "_env_data.csv")
  ))

sfn_wp <-
  readxl::read_xlsx(
    here::here("data", "received_dat", "sfn", "wp", paste0(sfn_site, ".xlsx")),
    sheet = 3,
    na = c("NA")
  ) 

##### Parse timestamp on sfn_wp, sfn_env

sfn_wp <- sfn_wp |>
  mutate(date = format(timestamp, "%Y%m%d"),
         time = format(timestamp, "%H:%M:%S"))

sfn_env <- sfn_env |>
  mutate(cleaned_timestamp = sub("T", " ", TIMESTAMP)) |>
  mutate(cleaned_timestamp = sub("Z", "", cleaned_timestamp)) |>
  mutate(formatted_timestamp = as.POSIXct(cleaned_timestamp, format = "%Y-%m-%d %H:%M:%S"))  |>
  mutate(
    date = format(formatted_timestamp, "%Y%m%d"),
    time = format(formatted_timestamp, "%H:%M:%S")
  )

##### New file path

site_path <-
  here::here("data", "sfn_as_psinet", paste0(sfn_site, "_as_psinet.xlsx"))

orig_psinet_template <-
  loadWorkbook(here::here("sfn_ingestion_scripts", "PSInet_template_SFNStudy.xlsx"))

filled_psinet_template <- copyWorkbook(orig_psinet_template)

#### Sheet 1 Site Metadata ####

site_md <- blank_psinet_template[[1]]

site_md$`Submitting author first name`[2] <-
  sfn_wp$contact_firstname[1]
site_md$`Submitting author last name`[2] <-
  sfn_wp$contact_lastname[1]
site_md$Institution[2] <- sfn_wp$contact_institution[1]
site_md$Email[2] <- sfn_wp$contact_email[1]
site_md$`Data publication?`[2] <-
  ifelse(is.na(sfn_site_md$si_paper[1]), "Not published",
         "Yes - as part of a scientific paper")
site_md$`Data publication DOI(s)`[2] <- sfn_site_md$si_paper
site_md$`Study type`[2] <- "Field study"
site_md$`Begin year`[2] <- NA
site_md$`End year`[2] <- NA
site_md$`Latitude (WGS84)`[2] <- unique(sfn_wp$lat)
site_md$`Longitude (WGS84)`[2] <- unique(sfn_wp$lon)
site_md$Remarks[2] <- sfn_site_md$si_remarks
site_md$Study[2] <- substr(sfn_site, 0, 7)

site_md$`Multi site study`[2] <- TRUE

writeData(filled_psinet_template, 2, site_md)

View(site_md)

#### Sheet 2 Data Description ####

data_desc <- blank_psinet_template[[2]]

# Pressure chamber
data_desc$`Is it available?`[2] <-
  any("chamber-bagged" %in% sfn_wp$method,
      "chamber-unbagged" %in% sfn_wp$method)
if (data_desc$`Is it available?`[2]) {
  data_desc$`Methodology or Instrument`[2] <- unique(sfn_wp$method)
  
}

# Psychrometer
data_desc$`Is it available?`[3] <- "psychometer" %in% sfn_wp$method

if (data_desc$`Is it available?`[3]) {
  data_desc$`Methodology or Instrument`[3] <- unique(sfn_wp$method)
  
}

# Soil water content shallow
data_desc$`Is it available?`[4] <-
  "swc_shallow" %in% colnames(sfn_env)

if (data_desc$`Is it available?`[4]) {
  data_desc$`Soil depth - start (cm)`[4] <-
    sfn_env_md$env_swc_shallow_depth
  data_desc$`Soil depth - end (cm)`[4] <-
    sfn_env_md$env_swc_shallow_depth
  data_desc$Units[4] <- "cm3/cm3 (volumetric)"
  
}


# Soil water content deep
data_desc$`Is it available?`[5] <- "swc_deep" %in% colnames(sfn_env)

if (data_desc$`Is it available?`[5]) {
  data_desc$`Soil depth - start (cm)`[5] <-
    sfn_env_md$env_swc_deep_depth
  data_desc$`Soil depth - end (cm)`[5] <-
    sfn_env_md$env_swc_deep_depth
  data_desc$Units[5] <- "cm3/cm3 (volumetric)"
  
}

# Soil water potential not collected
data_desc$`Is it available?`[6:7] <- FALSE


# Precipitation
data_desc$`Is it available?`[8] <- "precip" %in% colnames(sfn_env)

if (data_desc$`Is it available?`[8]) {
  data_desc$`Sensor location`[8] <- sfn_env_md$env_precip[1]
}

# Relative humidity
data_desc$`Is it available?`[9] <- "rh" %in% colnames(sfn_env)

if (data_desc$`Is it available?`[9]) {
  data_desc$`Sensor location`[9] <- sfn_env_md$env_rh[1]
}


# Vapor pressure deficit
data_desc$`Is it available?`[10] <- "vpd" %in% colnames(sfn_env)

if (data_desc$`Is it available?`[10]) {
  data_desc$`Sensor location`[10] <- sfn_env_md$env_vpd[1]
}

# Air temperature
data_desc$`Is it available?`[11] <- "ta" %in% colnames(sfn_env)

if (data_desc$`Is it available?`[11]) {
  data_desc$`Sensor location`[11] <- sfn_env_md$env_ta[1]
}

# PPFD
data_desc$`Is it available?`[12] <- "ppfd_in" %in% colnames(sfn_env)

if (data_desc$`Is it available?`[12]) {
  data_desc$`Sensor location`[12] <- sfn_env_md$env_ppfd_in[1]
}


# Incident shortwave radiation
data_desc$`Is it available?`[13] <- "sw_in" %in% colnames(sfn_env)

if (data_desc$`Is it available?`[13]) {
  data_desc$`Sensor location`[13] <- sfn_env_md$env_sw_in[1]
}


# Net radiation
data_desc$`Is it available?`[14] <- "netrad" %in% colnames(sfn_env)

if (data_desc$`Is it available?`[14]) {
  data_desc$`Sensor location`[14] <- sfn_env_md$env_netrad[1]
}

# Windspeed
data_desc$`Is it available?`[15] <- "ws" %in% colnames(sfn_env)

if (data_desc$`Is it available?`[15]) {
  data_desc$`Sensor location`[15] <- sfn_env_md$env_ws[1]
}

writeData(filled_psinet_template, 3, data_desc)

#### Sheet 3 Additional datasets ####

data_avail <- blank_psinet_template[[3]]

data_avail$Availability[7] <- TRUE
data_avail$Publication[7] <- TRUE
data_avail$Network[7] <- "SAPFLUXNET"
data_avail$`Network or database ID`[7] <- sfn_site
data_avail$Remarks[7] <- "Imported from SAPFLUXNET"

writeData(filled_psinet_template, 4, data_avail)

#### Sheet 4 Treatments ####

unique(sfn_wp$pl_treatment)

treatments <- blank_psinet_template[[4]][1:2, ]

treatments$`Level of treatment`[2] <- "Whole study" # may want to update this to "Whole site"
treatments$`Treatment ID`[2] <- "No treatment"

writeData(filled_psinet_template, 5, treatments)


#### Sheet 5 Plots ####

plots <- blank_psinet_template[[5]]
vegtype_key <- read.csv(here::here("sfn_ingestion_scripts", "vegtype_key.csv"))
gc_key <- read.csv(here::here("sfn_ingestion_scripts", "growth_condition_key.csv"))
terrain_key <- read.csv(here::here("sfn_ingestion_scripts", "terrain_key.csv"))

plots$`Plot ID`[2] <- substr(sfn_site, 9, nchar(sfn_site))
plots$`Treatment ID`[2] <- "No treatment"
plots$`Vegetation type`[2] <- vegtype_key[which(vegtype_key$sfn == sfn_site_md$si_igbp[1]), "psi"]
plots$`Growth condition`[2] <- gc_key[which(gc_key$sfn == sfn_stand_md$st_growth_condition[1]), "psi"]
plots$Aspect[2] <- sfn_stand_md$st_aspect[1]
plots$Terrain[2] <- terrain_key[which(terrain_key$sfn == sfn_stand_md$st_terrain[1]), "psi"]
plots$`Soil texture`[2] <- tolower(sfn_stand_md$st_soil_texture[1])
plots$`Percent sand`[2] <- sfn_stand_md$st_sand_perc[1]
plots$`Percent silt`[2] <- sfn_stand_md$st_silt_perc[1]
plots$`Percent clay`[2] <- sfn_stand_md$st_clay_perc[1]

writeData(filled_psinet_template, 6, plots)


#### Sheet 6 Plants ####

unique(sfn_wp$pl_name)

plants <- blank_psinet_template[[6]]

sfn_individuals <- sfn_wp |>
  select(pl_name,
         pl_treatment,
         pl_species,
         pl_height,
         pl_dbh,
         remarks) |>
  distinct() |>
  separate(col = pl_species, into = c("genus", "species"), sep = " ") |>
  mutate(remarks = ifelse(is.na(pl_treatment), remarks, paste0(remarks, "; ", pl_treatment))) 

matched_plants <-
  data.frame(
    Individual_ID = sfn_individuals$pl_name,
    Number_of_individuals = ifelse(all(sfn_wp$aggregation_level == "tree level"), 1, NA),
    Plot_ID = plots$`Plot ID`[2],
    Plot_Treatment_ID = plots$`Treatment ID`[2],
    Individual_Treatment_ID = "No treatment",
    Genus = sfn_individuals$genus,
    Specific_epithet = sfn_individuals$species,
    `Plant social status` = NA,
    `Average height (m)` = sfn_individuals$pl_height,
    `Average DBH (cm)` = sfn_individuals$pl_dbh,
    `Leaf area index (m2/m2)` = NA,
    Remarks = sfn_individuals$remarks
  )

writeData(
  filled_psinet_template,
  7,
  matched_plants,
  startCol = 2,
  startRow = 3,
  colNames = F
)

View(matched_plants)

#### Sheets 7 and 8 Plant water potential ####

wp_dat <- blank_psinet_template[[7]]

##### Sheet 7 #####

if (any("chamber-bagged" %in% sfn_wp$method,
        "chamber-unbagged" %in% sfn_wp$method)) {
  pc_dat <- sfn_wp |>
    filter(method != "psychometer")
  
  pc_wp_dat <- pc_dat |>
    select(pl_name,
           date,
           time,
           organ,
           canopy_position,
           `Ψ`,
           `Ψ SE`,
           `Ψ N`) |>
    mutate(Plot_ID = plots$`Plot ID`[2], .before = date) |> # Or "Whole study"
    rename(
      Individual_ID = pl_name,
      Date = date,
      Time = time,
      Organ = organ,
      `Canopy position` = canopy_position,
      `Water potential mean` = `Ψ`,
      `Water potential SE` = `Ψ SE`,
      `Water potential N` = `Ψ N`
    ) |>
    mutate(
      `Water potential SD` = sqrt(`Water potential N`) * `Water potential SE`,
      .after = `Water potential mean`, Organ = ifelse(Organ == "twig", "twig/leaf cluster", Organ)
    ) |>
    select(-`Water potential SE`)
  
  writeData(
    filled_psinet_template,
    8,
    pc_wp_dat,
    startCol = 2,
    startRow = 3,
    colNames = F
  )
  
  
}


##### Sheet 8 #####

if ("psychometer" %in% sfn_wp$method) {
  psyc_dat <- sfn_wp |>
    filter(method == "psychometer")
  
  psyc_wp_dat <- psyc_dat |>
    select(pl_name,
           date,
           time,
           organ,
           canopy_position,
           `Ψ`,
           `Ψ SE`,
           `Ψ N`) |>
    mutate(Plot_ID = plots$`Plot ID`[2], .after = pl_code) |> # Or "Whole study"
    rename(
      Individual_ID = pl_name,
      Date = date,
      Time = time,
      Organ = organ,
      `Canopy position` = canopy_position,
      `Water potential mean` = `Ψ`,
      `Water potential SE` = `Ψ SE`,
      `Water potential N` = `Ψ N`
    ) |>
    mutate(
      `Water potential SD` = sqrt(`Water potential N`) * `Water potential SE`,
      .after = `Water potential mean`, Organ = ifelse(Organ == "twig", "twig/leaf cluster", Organ)
    ) |>
    select(-`Water potential SE`)
  
  writeData(
    filled_psinet_template,
    9,
    psyc_wp_dat,
    startCol = 2,
    startRow = 3,
    colNames = F
  )
  
  
}

#### Sheet 9 Soil moisture data ####

if (any(data_desc$`Is it available?`[4:5])) {
  sm_dat <- blank_psinet_template[[9]][FALSE,-1] |>
    mutate(
      SWC_mean_shallow = as.numeric(SWC_mean_shallow),
      SWC_mean_deep = as.numeric(SWC_mean_deep)
    )
  
  swc_col_table <- data.frame(swc_shallow = numeric(),
                              swc_deep = numeric())
  
  swc_dat <- sfn_env |>
    bind_rows(swc_col_table) |>
    rename(
      Date = date,
      Time = time,
      SWC_mean_shallow = swc_shallow,
      SWC_mean_deep = swc_deep
    ) |>
    bind_rows(sm_dat) |>
    select(colnames(sm_dat)) |>
    mutate(Plot_ID = plots$`Plot ID`[2])
  
  writeData(
    filled_psinet_template,
    10,
    swc_dat,
    startCol = 2,
    startRow = 3,
    colNames = F
  )
  
}
#### Sheet 10 Met data ####

if (any(data_desc$`Is it available?`[8:15])) {
  met_dat <- blank_psinet_template[[10]][FALSE,-1] |>
    mutate(across(3:10, as.numeric),
           across(1:2, as.character))
  
  possible_met_dat_cnames <- sfn_env_md[FALSE, ] |>
    select(
      c(
        "env_precip",
        "env_rh",
        "env_vpd",
        "env_ta",
        "env_ppfd_in",
        "env_sw_in",
        "env_netrad",
        "env_ws"
      )
    ) |>
    rename_with(~ gsub("env_", "", .x), everything()) |>
    mutate(across(everything(), as.numeric))
  
  sfn_met_dat <- sfn_env |>
    bind_rows(possible_met_dat_cnames) |>
    rename(
      Date = date,
      Time = time,
      `Precipitation (mm)` = precip,
      `Relative humidity (%)` = rh,
      `Vapor pressure deficit (kPa)` = vpd,
      `Air temperature (C)` = ta,
      `Photosynthetically active radiation (PPFD) (µmolPhoton m-2 s-1)` = ppfd_in,
      `Incident shortwave radiation` = sw_in,
      `Net radiation (m s-1)` = netrad,
      `Windspeed (m/s)` = ws
    ) |>
    bind_rows(met_dat) |>
    select(colnames(met_dat))
  
  writeData(
    filled_psinet_template,
    11,
    sfn_met_dat,
    startCol = 2,
    startRow = 3,
    colNames = F
  )
  
  
}

## Sheet 11 SFN codes ####

sfn_codes <- sfn_wp |>
  select(pl_name, pl_code, measured_sfn) |>
  distinct()

writeData(
  filled_psinet_template,
  13,
  sfn_codes,
  startCol = 1,
  startRow = 1,
  colNames = T
)


saveWorkbook(filled_psinet_template, site_path, overwrite = T)
