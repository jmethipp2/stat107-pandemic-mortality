## Functions for cleaning the data (used in 11_DataCleaning.Rmd).


## Gives every column a short name.
## Input: df, the raw data.
## Output: the data with short column names.
rename_columns <- function(df) {
  short_names <- c("analysis_date", "year", "month", "start_date", "end_date",
                   "jurisdiction", "sex", "race_ethnicity", "age_group",
                   "all_cause", "natural_cause", "septicemia", "cancer",
                   "diabetes", "alzheimer", "flu_pneumonia",
                   "chronic_lower_resp", "other_resp", "kidney",
                   "ill_defined", "heart", "stroke", "covid_multiple",
                   "covid_underlying")
  if (ncol(df) != length(short_names)) {
    print("Error: data frame does not have 24 columns")
    return(NA)
  }
  colnames(df) <- short_names
  return(df)
}


## Removes the commas from the death counts and changes them to numbers.
## Input: df, the data; cols, the names of the count columns.
## Output: the data with those columns as numbers.
clean_counts <- function(df, cols) {
  for (col in cols) {
    without_commas <- gsub(",", "", df[, col])
    df[, col] <- as.numeric(without_commas)
  }
  return(df)
}


## Changes "M" and "F" to "Male" and "Female", and makes sex a factor.
## Input: df, the data.
## Output: the data with sex as a factor.
recode_sex <- function(df) {
  df$sex <- ifelse(df$sex == "M", "Male", df$sex)
  df$sex <- ifelse(df$sex == "F", "Female", df$sex)
  df$sex <- factor(df$sex, levels = c("Female", "Male"))
  return(df)
}


## Makes race/ethnicity a factor, and age group an ordered factor.
## Input: df, the data.
## Output: the data with both columns as factors.
set_factors <- function(df) {
  age_levels <- c("0-4 years", "5-14 years", "15-24 years", "25-34 years",
                  "35-44 years", "45-54 years", "55-64 years", "65-74 years",
                  "75-84 years", "85 years and over")
  df$age_group <- factor(df$age_group, levels = age_levels, ordered = TRUE)
  df$race_ethnicity <- factor(df$race_ethnicity)
  return(df)
}


## Counts the missing values in each column.
## Input: df, the data.
## Output: the number of missing values in each column.
count_missing <- function(df) {
  n_missing <- apply(df, MARGIN = 2, FUN = function(col) sum(is.na(col)))
  return(n_missing)
}
