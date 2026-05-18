# =============================================================
# Exploratory Analysis of COVID-19 Line List Data
# Author: Jumma Mohammad Teli
# Description: Statistical analysis of age and gender effects on
#              COVID-19 mortality using a patient-level line list.
# =============================================================

# ---- Setup ---------------------------------------------------
# Note: rm(list = ls()) is intentionally omitted — clearing a
# collaborator's environment is generally considered bad practice.
# Restart your R session for a clean state instead.

# Install packages if missing
required_packages <- c("Hmisc", "ggplot2")
new_packages <- required_packages[!(required_packages %in% installed.packages()[, "Package"])]
if (length(new_packages)) install.packages(new_packages)

library(Hmisc)    # describe()
library(ggplot2)  # visualisations

# ---- Load data -----------------------------------------------
# Relative path — assumes the CSV sits alongside this script.
# In RStudio: Session -> Set Working Directory -> To Source File Location
data <- read.csv("COVID19_line_list_data.csv", stringsAsFactors = FALSE)

# Drop empty trailing columns that come from the source CSV
data <- data[, colSums(is.na(data) | data == "") < nrow(data)]

# Quick summary of every variable
describe(data)


# ---- Feature engineering -------------------------------------
# The 'death' column is a mix of "0", "1", and actual dates for
# deceased patients. Treat anything other than "0" as a death.
data$death_dummy <- as.integer(data$death != "0")

# Overall death rate
death_rate <- sum(data$death_dummy) / nrow(data)
cat(sprintf("Overall death rate: %.2f%%\n", death_rate * 100))


# ---- Age analysis --------------------------------------------
# Hypothesis: deceased patients are older than survivors
dead  <- subset(data, death_dummy == 1)
alive <- subset(data, death_dummy == 0)

mean_age_dead  <- mean(dead$age,  na.rm = TRUE)
mean_age_alive <- mean(alive$age, na.rm = TRUE)

cat(sprintf("Mean age (deceased): %.1f\n", mean_age_dead))
cat(sprintf("Mean age (survivors): %.1f\n", mean_age_alive))

# Welch's two-sample t-test, 99% confidence
age_test <- t.test(alive$age, dead$age,
                   alternative = "two.sided",
                   conf.level = 0.99)
print(age_test)
# Interpretation: p-value is effectively 0, so we reject the null
# hypothesis. Age has a statistically significant effect on mortality.


# ---- Gender analysis -----------------------------------------
# Hypothesis: gender has no effect on death rate
men   <- subset(data, gender == "male")
women <- subset(data, gender == "female")

male_death_rate   <- mean(men$death_dummy,   na.rm = TRUE)
female_death_rate <- mean(women$death_dummy, na.rm = TRUE)

cat(sprintf("Male death rate:   %.2f%%\n", male_death_rate * 100))
cat(sprintf("Female death rate: %.2f%%\n", female_death_rate * 100))

# t-test (quick approximation for a binary outcome)
gender_t <- t.test(men$death_dummy, women$death_dummy,
                   alternative = "two.sided",
                   conf.level = 0.99)
print(gender_t)

# More formally correct: two-proportion z-test
gender_prop <- prop.test(
  x = c(sum(men$death_dummy, na.rm = TRUE),
        sum(women$death_dummy, na.rm = TRUE)),
  n = c(sum(!is.na(men$death_dummy)),
        sum(!is.na(women$death_dummy)))
)
print(gender_prop)
# Interpretation: p-value ~ 0.002 < 0.05, so the difference in death
# rates between men and women is statistically significant.


# ---- Visualisations ------------------------------------------
# 1. Age distribution by outcome
plot_data <- data[!is.na(data$age), ]
plot_data$outcome <- factor(plot_data$death_dummy,
                            levels = c(0, 1),
                            labels = c("Survived", "Deceased"))

p1 <- ggplot(plot_data, aes(x = age, fill = outcome)) +
  geom_histogram(position = "identity", alpha = 0.6, bins = 30) +
  labs(title = "Age distribution by outcome",
       x = "Age", y = "Number of patients", fill = "Outcome") +
  theme_minimal()
ggsave("age_distribution.png", p1, width = 8, height = 5, dpi = 150)

# 2. Death rate by gender
gender_summary <- data.frame(
  gender = c("Male", "Female"),
  death_rate = c(male_death_rate, female_death_rate) * 100
)
p2 <- ggplot(gender_summary, aes(x = gender, y = death_rate, fill = gender)) +
  geom_col(width = 0.6) +
  geom_text(aes(label = sprintf("%.1f%%", death_rate)), vjust = -0.5) +
  labs(title = "COVID-19 death rate by gender",
       x = NULL, y = "Death rate (%)") +
  theme_minimal() +
  theme(legend.position = "none")
ggsave("death_rate_by_gender.png", p2, width = 6, height = 5, dpi = 150)

cat("\nPlots saved: age_distribution.png, death_rate_by_gender.png\n")
