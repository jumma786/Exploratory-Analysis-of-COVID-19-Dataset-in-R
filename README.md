# 📊 COVID-19 Data Analysis in R

## 🔍 Project Overview

This project analyzes COVID-19 patient-level data using R to explore key factors influencing mortality. The analysis focuses on **age and gender differences in death rates** and applies statistical testing to validate insights.

---

## 🎯 Objectives

* Calculate overall COVID-19 death rate
* Compare average age of deceased vs recovered patients
* Analyze gender-based mortality differences
* Perform statistical hypothesis testing (t-test)

---

## 🧾 Dataset

* Source: COVID-19 Line List Dataset
* Format: CSV file
* Contains patient-level information such as:

  * Age
  * Gender
  * Outcome (death/recovered)

---

## 🛠️ Tools & Technologies

* R Programming
* Hmisc (for descriptive statistics)
* Base R functions

---

## 📈 Key Analysis

### 1. Data Cleaning

* Converted `death` column into binary variable (`death_dummy`)
* Handled missing values using `na.rm = TRUE`

### 2. Death Rate Calculation

* Computed overall mortality rate using total deaths / total records

### 3. Age Analysis

* Compared mean age of:

  * Deceased patients
  * Surviving patients
* Applied **t-test** to check statistical significance

### 4. Gender Analysis

* Calculated death rate for:

  * Male patients
  * Female patients
* Performed **t-test** to evaluate differences

---

## 📊 Key Findings

* Older individuals have a significantly higher mortality rate
* Male patients show higher death rates compared to females
* Statistical tests confirm these differences are significant

---




## 👤 Author

Jumma Mohammad Teli
Data Analyst | Python | SQL | Power BI

GitHub: https://github.com/jumma786
