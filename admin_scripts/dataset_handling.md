# Handling of sites

# Straightforward

These datasets have 1 water potential file, 1 met file, and no
treatments:

ARG_MAZ, ARG_TRE, BRA_CAM, BRA_CAX_CON, CHE_LOT_NOR, ESP_ALT_ARM,
ESP_RIN, ESP_RON_PIL, FRA_FON, FRA_PUE, ISR_YAT_YAT, PRT_LEZ_ARN,
PRT_MIT, THA_KHU, USA_DUK_HAR, USA_MOR_SF

# True experiments

These have multiple “Stands” with distinct experimental treatments. Some
of these stands have their own met data as well.

## AUS_CAN

There are three WP files (each with matching met data files) described
as stands in a “planted experiment”. The met data files mostly overlap.
The plant treatments (all the same within each WP file) are
“Monoculture” and “Mixture”.

Suggestion: Treat this as a true experiment. We can handle this in post
by *allowing met data to have an associated Plot ID*. Most met data will
be associated with “Whole study” but some will be associated with
specific plots.

The “Monoculture”/“Mixture” labels wouldn’t ordinarily scan as
treatments to me, but given that the site is described as an experiment
I lean towards treating them as plot-level treatments.

## AUS_RIC_EUC

There are two WP files and only one met file (corresponding to one of
the WP files). The treatments (all the same within each WP file) are
“ambient”, and “elevated co2”.

Suggestion: Again treat this as a true experiment. Only report met data
for the “plot” with met data reported.

Treat “ambient” and “elevated Co2” as plot-level treatments.

## ESP_SAN

There are 4 WP files all with their own, non-overlapping, met data. The
sites have distinct experimental treatments (45% and 100% water needs).

Suggestion: Again, a true experiment with plot-level met data. Treat
water manipulations as plot-level treatments.

## SEN_SOU

There are 3 WP files with non-overlapping met data. There are no
treatments listed, but the site names are suspicious (“IRR”, “POS”,
“PRE”) making me think these *might* be plot-level treatments of “Irr”,
“Post”, and “Pre” something? Otherwise this belongs with the last group
(either 3 totally distinct sites or 3 plots with their own met data,
below)

# Distinct stands with treatments, but not “Experimental”

## ESP_TIL

There are 3 WP files all with their own, non-overlapping, met data.

The “Treatments” listed include “NA” and “understorey”; the three files
correspond to mixed, all-canopy, and monoculture stand descriptions.

Suggestion: Set all treatments to NA and put plot descriptions under
“Remarks”.

Since we are allowing plots their own met data, we could link these as
plots within a larger site at no cost. Or we could treat them as each
individual studies.

## ESP_YUN

There are 3 WP files each with their own, distinct, met data. 2 files
have all NA treatments and one has “Thinning”.

Suggestion: put “Thinning” in Remarks and set all treatments to NA.

Again, this could be 3 distinct sites or 3 plots with their own met
data.

# Either distinct sites or plots with plot-level met data

## ESP_VAL

There are 2 WP files with non-overlapping met data and no treatments.

This could either be 2 distinct sites, or 2 plots (with plot-level met
data) within a larger site.

## The rest of these also match this pattern:

GBR_GUI_ST1, GBR_GUI_ST2, GBR_GUI_ST3, GUF_GUY_ST2, GUF_GUY_ST2_BIS
