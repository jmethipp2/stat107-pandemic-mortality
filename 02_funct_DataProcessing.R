## Functions for processing the data (used in 21_DataProcessing.Rmd).


## The causes of death we use. covid_multiple is left out because it overlaps with covid_underlying.
cause_cols <- c("septicemia", "cancer", "diabetes", "alzheimer",
                "flu_pneumonia", "chronic_lower_resp", "other_resp",
                "kidney", "ill_defined", "heart", "stroke",
                "covid_underlying")


## Adds the new variables: unnatural, neuro_total, other_natural, period and time_index.
## Input: df, the clean data.
## Output: the data with the five new columns.
add_derived_variables <- function(df) {
  df$unnatural   <- df$all_cause - df$natural_cause
  df$neuro_total <- df$alzheimer + df$stroke

  listed_total     <- apply(df[, cause_cols], MARGIN = 1, FUN = sum)
  df$other_natural <- df$natural_cause - listed_total

  is_pandemic <- (df$year == 2020 & df$month >= 3) | (df$year == 2021)
  df$period   <- factor(ifelse(is_pandemic, "Pandemic", "Pre-pandemic"),
                        levels = c("Pre-pandemic", "Pandemic"))

  df$time_index <- (df$year - 2019) * 12 + df$month
  return(df)
}


## Compares deaths from one cause in a year with the same months of 2019, for all rows or for each group of a factor.
## Input: df, the data; cause, a death count column; group_var, a factor column or "none"; year, the year to compare; max_month, the last month.
## Output: a table with deaths in 2019, deaths in the year, excess deaths and percent change for each group.
percent_change <- function(df, cause, group_var = "none", year = 2020,
                           max_month = 12) {
  df <- df[df$month <= max_month, ]

  if (group_var == "none") {
    groups <- "All"
    group_values <- rep("All", nrow(df))
  } else {
    groups <- levels(df[, group_var])
    group_values <- df[, group_var]
  }

  deaths_2019    <- rep(NA, length(groups))
  deaths_compare <- rep(NA, length(groups))
  for (g in 1:length(groups)) {
    in_group          <- (group_values == groups[g])
    deaths_2019[g]    <- sum(df[in_group & df$year == 2019, cause])
    deaths_compare[g] <- sum(df[in_group & df$year == year, cause])
  }

  excess <- deaths_compare - deaths_2019
  result <- data.frame(group = groups,
                       deaths_2019 = deaths_2019,
                       deaths_compare = deaths_compare,
                       excess = excess,
                       pct_change = round(100 * excess / deaths_2019, 1))
  return(result)
}


## Runs percent_change() for several causes and keeps only the percent changes.
## Input: df, the data; causes, death count columns; group_var, year and max_month as in percent_change().
## Output: a matrix of percent changes (rows = groups, columns = causes).
percent_change_table <- function(df, causes, group_var = "none", year = 2020,
                                 max_month = 12) {
  first  <- percent_change(df, causes[1], group_var, year, max_month)
  result <- matrix(NA, nrow = nrow(first), ncol = length(causes))
  rownames(result) <- first$group
  colnames(result) <- causes

  for (c_ind in 1:length(causes)) {
    changes <- percent_change(df, causes[c_ind], group_var, year, max_month)
    result[, c_ind] <- changes$pct_change
  }
  return(result)
}


## Adds up deaths from one cause for each month, for all rows or for one group.
## Input: df, the data; cause, a death count column; group_var, a factor column or "none"; level, the group to keep (e.g. "Hispanic").
## Output: a table with time_index, year, month and deaths.
monthly_totals <- function(df, cause, group_var = "none", level = "none") {
  if (group_var != "none") {
    df <- df[df[, group_var] == level, ]
  }
  months <- 1:max(df$time_index)
  deaths <- rep(NA, length(months))
  for (m in months) {
    deaths[m] <- sum(df[df$time_index == m, cause])
  }
  result <- data.frame(time_index = months,
                       year = 2019 + (months - 1) %/% 12,
                       month = (months - 1) %% 12 + 1,
                       deaths = deaths)
  return(result)
}
