## Functions for making the plots 


## Plots the number of deaths in each month, with a line at March 2020.
## Input: df, the processed data; cause, a death count column; title, the plot title.
## Output: a plot of deaths by month.
plot_monthly_deaths <- function(df, cause = "all_cause",
                                title = "Deaths per month") {
  totals <- monthly_totals(df, cause)
  plot(totals$time_index, totals$deaths,
       col = "#115577", pch = 16,
       main = title,
       xlab = "Month (1 = January 2019)",
       ylab = "Number of deaths")
  abline(v = 15, col = "red", lty = 2)
}


## Short names for the groups, so they fit on the plots.
race_labels <- c("Hispanic", "Am. Indian", "Asian", "Black", "White", "Other")
age_labels  <- c("0-4", "5-14", "15-24", "25-34", "35-44", "45-54",
                 "55-64", "65-74", "75-84", "85+")


## Plots the percent change from 2019 to 2020 as a heatmap, with one row for each group and one column for each cause.
## Input: df, the processed data; causes, death count columns; cause_labels, names for the causes; group_var, a factor column; group_labels, names for the groups; title, the plot title; flip, TRUE to put the groups in columns instead of rows.
## Output: a heatmap of percent changes.
plot_change_matrix <- function(df, causes, cause_labels, group_var,
                               group_labels, title, flip = FALSE) {
  pct <- percent_change_table(df, causes, group_var)
  rownames(pct) <- group_labels
  colnames(pct) <- cause_labels
  if (flip) {
    pct <- t(pct)
  }
  par(mar = c(5.1, 4.1, 4.1, 4.1))
  plot(pct, main = title, xlab = "", ylab = "")
  par(mar = c(5.1, 4.1, 4.1, 2.1))
}


## Plots the percent change from 2019 to 2020 as a heatmap of race/ethnicity by age group.
## Input: df, the processed data; cause, a death count column; title, the plot title.
## Output: a heatmap of percent changes.
plot_race_age_heatmap <- function(df, cause, title) {
  ages <- levels(df$age_group)
  pct  <- matrix(NA, nrow = length(race_labels), ncol = length(ages))
  rownames(pct) <- race_labels
  colnames(pct) <- age_labels
  
  for (a in 1:length(ages)) {
    df_age   <- df[df$age_group == ages[a], ]
    pct[, a] <- percent_change(df_age, cause, "race_ethnicity")$pct_change
  }
  par(mar = c(5.1, 4.1, 4.1, 4.1))
  plot(pct, main = title, xlab = "Age group", ylab = "")
  par(mar = c(5.1, 4.1, 4.1, 2.1))
}


## Plots boxplots of monthly deaths before and during the pandemic.
## Input: df, the processed data; cause, a death count column; title, the plot title.
## Output: two boxplots, one for each period.
plot_period_boxplot <- function(df, cause = "all_cause",
                                title = "Deaths per month by period") {
  totals <- monthly_totals(df, cause)
  period <- factor(ifelse(totals$time_index >= 15, "Pandemic", "Pre-pandemic"),
                   levels = c("Pre-pandemic", "Pandemic"))
  boxplot(totals$deaths ~ period,
          col = "#115577", border = "black",
          main = title,
          xlab = "Period", ylab = "Number of deaths")
}