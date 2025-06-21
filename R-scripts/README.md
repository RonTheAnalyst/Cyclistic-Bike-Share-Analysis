# 📂 R Code – Cyclistic Data Preprocessing & Analysis Scripts

This folder contains the R scripts used to process, clean, and summarize the Cyclistic bike-share dataset (2021–2024) as part of an exploratory and strategic analytics project. These scripts are designed for reproducibility and analytical transparency, not plug-and-play execution.

---

## 📌 Purpose of These Scripts

Each script was custom-built to:

- Merge monthly datasets for each year
- Clean time-based and categorical variables
- Engineer new features (hour, day, month, weekday)
- Generate aggregated CSVs for:
  - 📆 Monthly and Daily trends
  - 🕒 Mean Ride Time
  - ⏰ Time-of-Day Usage Patterns
  - 🌦 Weather impact analysis (NOAA data)
  - 📊 Weekday usage behavior

---

## 📁 File Structure

### 1️⃣ **Year-wise Scripts** (`cyclistic_2021.R`, `2022.R`, etc.)
Each script:
- Reads monthly raw CSVs from the working directory
- Merges and cleans data
- Adds timestamp columns (e.g., hour, month, weekday)
- Performs summary aggregations
- Saves cleaned and summarized CSVs into the `/Dataset/` folder

> ⚠ These scripts are not directly executable without restructuring paths and placing original CSVs in the working directory.

---

### 2️⃣ **`merge.R`**
This script merges all the individual yearly summary CSVs (for each category like `Mean Ride Time`, `Time Range`, etc.) into unified, multi-year CSV files with a `Year` column added.

> ✅ Useful for multi-year analysis in Tableau or statistical comparisons.

---

## 🧠 How to Use (Manually or Partially)

If you're reviewing this project:
- You **don't need to run these scripts** to understand the insights.
- The **final processed datasets are already included** in the `/Dataset/` folder.
- You can explore insights via the Tableau Dashboard or 10-min Summary PDF.

If you're replicating:
- Place your monthly CSVs in a local folder
- Run scripts one by one after installing dependencies

---

## 📦 Dependencies Used

You’ll need the following R packages:

```r
library(tidyverse)
library(lubridate)
library(weathercan)
library(plotly)
```

## 📌 Note
This is not production-grade code, but analytical code written for a real-world business case scenario with clarity and structure. Feel free to reuse logic with minor edits for your own datasets.

---
