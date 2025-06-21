# 🚲 Cyclistic Bike-Share Data Analysis (2021–2024)

Welcome to a comprehensive, end-to-end case study focused on uncovering key behavioral insights from Cyclistic's ride-share program in Chicago. This project dives into millions of ride records across four years (2021–2024) to identify data-driven strategies that increase annual membership and enhance user experience.

---

## 📌 Project Context & Motivation

This project was inspired by the **Google Data Analytics Capstone**, which uses Cyclistic (a fictional brand based on real Divvy data) as a business case. Though Cyclistic is fictional, all datasets are real and sourced from Divvy’s public bike-share system in Chicago.

📊 The central goal? **To help Cyclistic convert more casual riders into annual members** using deep insights from behavioral, seasonal, and weather-driven usage trends.

---

## 💼 Business Problem Statement

Cyclistic’s marketing team believes that casual riders could be converted into annual members. The challenge lies in understanding:

* How do casual and member riders differ in usage patterns?
* What factors (weather, timing, weekends, bike types) influence ride behavior?
* What strategies could nudge casual riders toward membership?

---

## 📂 Data Sources

| Dataset                     | Description                                                                                   |
| --------------------------- | --------------------------------------------------------------------------------------------- |
| Divvy Trip Data (2021–2024) | Publicly available trip logs from Chicago's Divvy system. Over 20M rows cleaned and analyzed. |
| NOAA Weather Data           | Hourly weather records (temperature, wind, humidity) from Midway Airport Station.             |

> ⬇️ **Raw datasets were \~1GB. Final processed datasets (\~10MB total) are included in the `Dataset` folder.**

* 🔗 **[Raw Dataset](https://divvy-tripdata.s3.amazonaws.com/index.html)**

---

## 🛠️ Tools & Skills Used

* **R (tidyverse, ggplot2, lubridate)** – Cleaning, wrangling, aggregation, visualization
* **Tableau** – Interactive dashboards
* **Google Sheets** – Planning & presentation
* **SQL (optional)** – For internal practice queries
* **Business Strategy** – Behavior modeling, campaign design

---

## 🔍 Analysis Highlights (2021–2024)

### 1️⃣ Usage Trends

* **Peak casual ridership**: July (except 2024)
* **Weekday vs. Weekend**: Members dominate weekdays, casuals dominate weekends
* **Electric bikes**: Surging among members in 2024 
* **Docked bikes**: Discontinued after 2023

### 2️⃣ Mean Ride Time

* Casual riders take **longer rides** than members across all bike types.
* Seasonal trends: Ride duration increases in summer.

### 3️⃣ Time Interval Patterns

* Members ride steadily from **6 AM–8 PM**, peaking at **4–6 PM**.
* Casual riders prefer **noon to evening**, with increasing late-night rides.

### 4️⃣ Weather Impact

* Highest ride volumes occur between **20–29°C**.
* Dropoff observed beyond **30°C** and below **5°C**.
* Humidity over 80% or wind above 6 m/s sharply reduces ridership.

---

## 📈 Tableau Dashboard Overview

* 🔗 **[Video Walkthrough (Google Drive)](https://drive.google.com/file/d/1bbQvFRJ6trD9dfYsgzhKXg4Z4KxpQUa9/view?usp=sharing)**
* 🔗 **[Tableau](https://public.tableau.com/views/CyclisticTheWayofLife_17400687878700/CyclisticRideTrends?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)**

| Dashboard            | Features                                                           |
| -------------------- | ------------------------------------------------------------------ |
| Heat Map             | Day-wise ride count + filters by user type, bike type, month, year |
| Ride Time Trends     | Line plots across months by membership & bike                      |
| Time Interval Charts | Time of day usage patterns                                         |
| Weather Graphs       | Impact of temperature, humidity, and wind on rides                 |

---

## 💡 Business Strategy Summary

### 🎯 Campaign 1: Convert Casual to Member via Summer Nudge

* **Target Months**: April–August
* **Action**: Show ride summaries (distance, CO2 saved, money spent) → then give **8% membership discount or 8% + free branded gloves**.
* **Why it works**: Uses psychological ownership and nudge theory.

### 🌍 Campaign 2: Tourist & Student Market

* **Tourist Pass**: Offered at airports (June–Sept)
* **Student Promo**: Aug–Sept membership discount via college ID verification

### 🏋️‍♂️ Campaign 3: January Fitness Challenge

* **Challenge**: 20-minute daily rides (Jan 1–31)
* **Reward**: Discounted membership + “Cyclistic Fit” badge
* **CSR Angle**: 50% profits from Fitness Pass go to public school development

---

## 🗂️ Project Structure

```
Cyclistic-Bike-Share-Analysis/
│
├── Dataset/
│   ├── Daily Trends.csv
│   ├── Mean Ride Time.csv
│   ├── Monthly Rider Count.csv
│   ├── Time Range Analysis.csv
│   ├── Weekday Mean.csv
│   └── Weather.csv
│
├── R Code/
│   ├── cyclist-2021.R
│   ├── cyclist-2022.R
│   ├── cyclist-2023.R
│   ├── cyclist-2024.R
│   └── merge.R
│
├── Dashboard/
│   ├── Tableau Dashboard Screenshot.jpg
│   └── Walkthrough Video.mp4 (link below)
│
├── Report/
│   ├── Full Report (PDF)
│   └── 10-Minute Summary (PDF)
```

---

## 📎 Key Links

* 📘 **[Full Report](https://drive.google.com/file/d/1fN34FFa4RSH2AJX2jWp9xAJYI0lxEYzl/view?usp=sharing)**
* 🎥 **[Dashboard Walkthrough Video](https://drive.google.com/file/d/1bbQvFRJ6trD9dfYsgzhKXg4Z4KxpQUa9/view?usp=sharing)**

---

## 🚀 How to Use This Repository

1. Clone or download the repo.
2. Explore the `Dataset` folder for CSV insights.
3. Review the `R-scripts` to understand the full analytical workflow (note: scripts are non-runnable unless raw data is locally available).
4. View Tableau screenshots/video for interactive visuals.
5. Read `Report` for business case + final strategy.

---

## 👤 About the Author

I'm **Rohan Jha**, an aspiring data analyst with a background in Physics and a strong focus on user behavior, pattern recognition, and decision science. This project is a reflection of both my analytical thinking and narrative-driven insight development.

> *“This report isn't just about bike rides. It's about behavioral data, design thinking, and reshaping how urban mobility is understood.”*

If you found value here, feel free to ⭐ star this repo or connect!

---
