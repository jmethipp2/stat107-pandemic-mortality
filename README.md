# Excess Deaths in the U.S. During the COVID-19 Pandemic

## Files

- `data/cdc_monthly_mortality.csv`: the raw data, "AH Monthly Provisional
  Counts of Deaths for Select Causes of Death by Sex, Age, and Race and
  Hispanic Origin" from the CDC (downloaded from healthdata.gov).
- `00_requirements.R`: installs and loads the package we use (`plot.matrix`).
- `01_funct_DataCleaning.R`: functions for cleaning the data.
- `02_funct_DataProcessing.R`: functions for creating new variables and
  comparing deaths with 2019.
- `03_funct_Plots.R`: functions for making the plots.
- `11_DataCleaning.Rmd`: cleans the raw data and saves `12_DataSaving.RData`.
- `12_DataSaving.RData`: the clean data.
- `21_DataProcessing.Rmd`: creates new variables, compares deaths with 2019,
  and saves `22_DataSaving.RData`.
- `22_DataSaving.RData`: the processed data.
- `31_DataVisualization.Rmd`: plots and summary statistics, with explanations
  of what they show.
- `FinalReport.Rmd`: our report.
- `FinalReport.pdf`: the knitted report.

## How to reproduce our results

1. Download this repository and keep all files in the same folder, with the
   data file inside the `data` folder.
2. Open `00_requirements.R` in RStudio and click Source to install and load
   the package.
3. Knit `11_DataCleaning.Rmd`. This creates `12_DataSaving.RData`.
4. Knit `21_DataProcessing.Rmd`. This creates `22_DataSaving.RData`.
5. Knit `31_DataVisualization.Rmd` to make the plots.
6. Knit `FinalReport.Rmd` to make `FinalReport.pdf`. Knitting to PDF needs
   TinyTeX, which can be installed by running `install.packages("tinytex")`
   and then `tinytex::install_tinytex()`.
