# 📂 List all monthly CSV files for 2021 in the working directory
csv_files <- list.files(pattern = "\\.csv$")

# 📊 Read each CSV file into a list of data frames
csv_list <- lapply(csv_files, read.csv)

# 🔄 Merge all 12 monthly data frames into a single dataset for 2021
cyclist_2021 <- do.call(rbind, csv_list)

# 🔍 Check dataset structure (column names, data types, sample values)
str(cyclist_2021)

# 💾 Save the merged dataset for further analysis
write.csv(cyclist_2021, "cyclist-2021.csv", row.names = FALSE)

# 🛠 Free up memory by removing temporary objects
rm(csv_list, cyclist_2021)



# 📂 Load the merged 2021 dataset
library(readr)
cyclist_2021 <- read_csv("cyclist-2021.csv")

# 🛠 Define key columns to check for missing values
columns_to_check <- c("started_at", "ended_at", "rideable_type", "member_casual")

# ⚠️ Count missing values in critical columns
colSums(is.na(cyclist_2021[columns_to_check]))

# ⏳ Convert timestamps to datetime format for time-based analysis
cyclist_2021$started_at <- as.POSIXct(cyclist_2021$started_at, format = "%Y-%m-%d %H:%M:%S")
cyclist_2021$ended_at <- as.POSIXct(cyclist_2021$ended_at, format = "%Y-%m-%d %H:%M:%S")

# 📅 Extract month name from timestamps for monthly trend analysis
cyclist_2021$month <- month.name[month(cyclist_2021$started_at)]

# ✅ Verify formatting and month extraction
str(cyclist_2021)



# ⏳ Calculate total ride duration in seconds for each trip
cyclist_2021$Total_time_secs <- as.numeric(cyclist_2021$ended_at - cyclist_2021$started_at)

# 📊 Calculate average ride time (in minutes) grouped by bike type, user type, and month
Mean_Time_C21 <- cyclist_2021 %>%
  group_by(rideable_type, member_casual, month) %>%
  summarise(Mean_Ride_Time = mean(Total_time_secs / 60, na.rm = TRUE))  # Convert seconds to minutes

# 🔍 Preview the calculated mean ride times
head(Mean_Time_C21)

# 💾 Save the mean ride time summary to a CSV file
write.csv(Mean_Time_C21, "Mean-ridetime-cyclist2021.csv", row.names = FALSE)



# 📅 Define the correct chronological order for months
month_levels <- c("January", "February", "March", "April", "May", "June", 
                  "July", "August", "September", "October", "November", "December")

# 🔄 Convert 'month' to a factor to ensure correct ordering
Mean_Time_C21 <- Mean_Time_C21 %>%
  mutate(month = factor(month, levels = month_levels)) %>%
  arrange(month)

# 📈 Plot mean ride time trend across months
ggplot(Mean_Time_C21, aes(x = month, y = Mean_Ride_Time, color = rideable_type, group = rideable_type)) +
  geom_line() +                          # Line plot to show trends
  geom_point() +                         # Points to highlight data values
  facet_wrap(rideable_type ~ member_casual, scales = "free") +  # Separate plots for each user type & bike type
  labs(
    title = "Mean Ride Time Across Months by Rideable Type and Member Type",
    x = "Month",
    y = "Mean Ride Time (min)",
    color = "Rideable Type"
  ) +
  theme_minimal() +                      # Apply a clean theme
  scale_color_brewer(palette = "Set1") + # Use a visually appealing color palette
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate x-axis labels for readability
    strip.text = element_text(size = 12),               # Adjust facet label size
    plot.title = element_text(hjust = 0.5, size = 16)   # Center-align the title
  )




# 📊 Group data by user type, bike type, and month to count rides
Total_UserCount_Monthly <- cyclist_2021 %>%
  group_by(member_casual, rideable_type, month) %>%
  summarise(riders_count = n(), .groups = "drop")

# 📅 Order months correctly for better readability
Total_UserCount_Monthly <- Total_UserCount_Monthly %>%
  mutate(month = factor(month, levels = month_levels)) %>%
  arrange(month)

# 🔍 View summarized data
head(Total_UserCount_Monthly)

# 💾 Save the summarized dataset
write.csv(Total_UserCount_Monthly, "Monthly-UserCount-cyclist2021.csv", row.names = FALSE)



# 📊 Plot bar graph showing user counts per month and bike type
ggplot(Total_UserCount_Monthly, aes(x = month, y = riders_count, fill = member_casual)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~ rideable_type, scales = "free", ncol = 1) +
  scale_y_continuous(
    breaks = seq(0, 250000, 25000),
    minor_breaks = seq(0, 250000, 5000),
    labels = scales::comma
  ) +
  scale_fill_manual(values = c("member" = "#a1b4f4", "casual" = "#F4E1A1")) +
  labs(
    title = "Monthly User Count by Rideable Type and Membership Type",
    x = "Month",
    y = "Total User Count",
    fill = "Membership Type"
  ) +
  theme_minimal() +
  theme(
    panel.grid.major = element_line(color = "grey80", linewidth = 0.8),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )



# 📅 Extract the day from 'started_at' and store it in a new 'Date' column
cyclist_2021 <- cyclist_2021 %>%
  mutate(Date = format(started_at, "%d"))

# 🔄 Convert 'Date' column to numeric for analysis
cyclist_2021$Date <- as.numeric(cyclist_2021$Date)

# 📊 Group by user type, date, month, and bike type to count daily rides
Daily_Trend <- cyclist_2021 %>%
  group_by(member_casual, Date, month, rideable_type) %>%
  summarise(total_rides = n(), .groups = "drop")

# 📅 Ensure months are correctly ordered for clarity
Daily_Trend <- Daily_Trend %>%
  mutate(month = factor(month, levels = month_levels)) %>%
  arrange(month)

# 💾 Save the summarized daily ride data for further analysis
write.csv(Daily_Trend, "Daily-Trend-cyclist2021.csv", row.names = FALSE)




# 📅 Extract the day of the week from 'started_at' (e.g., Mon, Tue, Wed)
cyclist_2021 <- cyclist_2021 %>%
  mutate(Day = wday(started_at, label = TRUE, abbr = TRUE))

# 📊 Count total rides per weekday, grouped by user type, bike type, and month
Weekday_UserCount <- cyclist_2021 %>%
  group_by(Day, member_casual, rideable_type, Date, month) %>%
  summarise(
    count = n(),
    .groups = "drop"
  )

# 📊 Calculate the average number of rides per weekday across the dataset
Weekday_mean_Usercount <- Weekday_UserCount %>%
  group_by(Day, month, member_casual, rideable_type) %>%
  summarise(
    mean_count = mean(count, na.rm = TRUE),
    .groups = "drop"
  )

# 🎯 Round off mean values for better readability
Weekday_mean_Usercount$mean_count <- round(Weekday_mean_Usercount$mean_count)

# 📅 Ensure months are ordered correctly for better visualization
Weekday_mean_Usercount <- Weekday_mean_Usercount %>%
  mutate(month = factor(month, levels = month_levels)) %>%
  arrange(month)

# 🔍 Check dataset structure after processing
head(Weekday_mean_Usercount)

# 💾 Save the weekday analysis data for further visualization
write.csv(Weekday_mean_Usercount, "Weekday_mean-cyclist2021.csv", row.names = FALSE)





# ⏳ Extract hour from 'started_at' and categorize into time intervals
cyclist_2021 <- cyclist_2021 %>%
  mutate(
    Hour = hour(started_at),  # Extract hour from timestamp
    Time_Range = case_when(
      Hour >= 0 & Hour < 2  ~ "0-2",
      Hour >= 2 & Hour < 4  ~ "2-4",
      Hour >= 4 & Hour < 6  ~ "4-6",
      Hour >= 6 & Hour < 8  ~ "6-8",
      Hour >= 8 & Hour < 10 ~ "8-10",
      Hour >= 10 & Hour < 12 ~ "10-12",
      Hour >= 12 & Hour < 14 ~ "12-14",
      Hour >= 14 & Hour < 16 ~ "14-16",
      Hour >= 16 & Hour < 18 ~ "16-18",
      Hour >= 18 & Hour < 20 ~ "18-20",
      Hour >= 20 & Hour < 22 ~ "20-22",
      Hour >= 22 & Hour < 24 ~ "22-24"
    )
  )

# 📊 Group by time range, user type, month, and bike type to count rides
Time_range <- cyclist_2021 %>%
  group_by(Time_Range, member_casual, month, rideable_type) %>%
  summarise(count = n(), .groups = "drop")

# ⏳ Define the correct order for time intervals
time_levels <- c("0-2", "2-4", "4-6", "6-8", "8-10", "10-12", 
                 "12-14", "14-16", "16-18", "18-20", "20-22", "22-24")

# 🔄 Convert 'Time_Range' into an ordered factor for proper arrangement
Time_range <- Time_range %>%
  mutate(Time_Range = factor(Time_Range, levels = time_levels, ordered = TRUE)) %>%
  arrange(Time_Range)

# 📅 Order 'month' correctly for better visualization
Time_range <- Time_range %>%
  mutate(month = factor(month, levels = month_levels)) %>%
  arrange(month)

# 🔍 Check dataset structure after processing
head(Time_range)

# 💾 Save the processed time range dataset for analysis
write.csv(Time_range, "TimeInterval-cyclist2021.csv", row.names = FALSE)

# 💾 Save the updated cyclist dataset with time intervals
write.csv(cyclist_2021, "cyclist-2021-v2.csv", row.names = FALSE)




# 🌍 Get a list of available NOAA weather stations
stations <- getMeta()

# 🌦️ Import weather data for CHICAGO MIDWAY INTL ARPT (Station Code: 725340-14819)
weather_2021 <- importNOAA(year = 2021, code = "725340-14819")

# 🔍 View the first few rows of the dataset
View(weather_2021)

# 💾 Save the extracted weather data for further analysis
write.csv(weather_2021, "chicago_2021.csv", row.names = FALSE)




# 🔑 Create a common join key by rounding timestamps to the nearest hour
cyclist_2021 <- cyclist_2021 %>%
  mutate(join_key = floor_date(started_at, unit = "hour"))

weather_2021 <- weather_2021 %>%
  mutate(join_key = floor_date(date, unit = "hour"))

# 🎯 Select only necessary weather columns for merging
weather_cols <- c("join_key", "air_temp", "RH", "ws")
chicago_weather <- weather_2021 %>% select(all_of(weather_cols))

# 🔗 Perform a left join to integrate weather data into ride dataset
cyclist_2021 <- left_join(cyclist_2021, chicago_weather, by = "join_key")

# 🗑️ Remove the temporary join_key column (not needed after merging)
cyclist_2021 <- cyclist_2021 %>% select(-join_key)

# 🔍 Check dataset structure after merging
str(cyclist_2021)





# 🔍 Checking for missing values in weather-related columns
colSums(is.na(cyclist_2021))

# 🔎 Filtering dataset to see rows where air temperature is missing
filtered_air_temp <- subset(cyclist_2021, is.na(air_temp))

# 👀 View missing temperature data
View(filtered_air_temp)

# 📊 Grouping missing air_temp values by date, month, and hour
temp_null <- filtered_air_temp %>%
  group_by(Date, air_temp, month, Hour) %>%
  summarise(count = n(), .groups = "drop")

# 📜 Print summary of missing data
print(temp_null)

# 🗑️ Removing rows where air temperature is missing
cyclist_2021 <- subset(cyclist_2021, !is.na(air_temp))





# 🏷️ Extract year from 'started_at' column
cyclist_2021$year <- year(cyclist_2021$started_at)

# 📊 Aggregating data for weather-based analysis
weather <- cyclist_2021 %>%
  group_by(Date, Hour, month, year, rideable_type, member_casual, air_temp, RH, ws) %>%
  summarise(Riders_count = n(), .groups = "drop")

# 📏 Rounding values for better visualization
weather <- weather %>%
  mutate(
    month = factor(month, levels = month_levels),
    air_temp = round(air_temp),
    RH = round(RH),
    ws = round(ws))%>%
  arrange(month)

# 💾 Save cleaned weather dataset
write.csv(weather,"cyclist-2021-weather.csv", row.names = FALSE)



# 🔍 Grouping ride count by temperature
weather_summary <- weather %>%
  group_by(air_temp, rideable_type, member_casual) %>%
  summarise(total_rides = sum(Riders_count), .groups = "drop")

# 📊 Line Chart: Temperature vs. Ride Count
p <- ggplot(weather_summary, aes(x = air_temp, y = total_rides, colour = member_casual, group = member_casual)) +
  geom_line() +
  geom_point() +
  facet_wrap(~ rideable_type + member_casual) +
  labs(
    title = "Impact of Temperature on Ridership",
    x = "Air Temperature (°C)",
    y = "Total Rides",
    colour = "User Type"
  ) +
  theme_minimal()

ggplotly(p)  # Interactive plot



# 🔍 Grouping ride count by relative humidity
weather_summaryRH <- weather %>%
  group_by(RH, rideable_type, member_casual) %>%
  summarise(total_rides = sum(Riders_count), .groups = "drop")

# 📊 Line Chart: Humidity vs. Ride Count
K <- ggplot(weather_summaryRH, aes(x = RH, y = total_rides, colour = member_casual, group = member_casual)) +
  geom_line() +
  geom_point() +
  facet_wrap(~ rideable_type + member_casual) +
  labs(
    title = "Impact of Humidity on Ridership",
    x = "Relative Humidity (%)",
    y = "Total Rides",
    colour = "User Type"
  ) +
  theme_minimal()

ggplotly(K)  # Interactive plot




# 🔍 Grouping ride count by wind speed
weather_summaryws <- weather %>%
  group_by(ws, rideable_type, member_casual) %>%
  summarise(total_rides = sum(Riders_count), .groups = "drop")

# 📊 Line Chart: Wind Speed vs. Ride Count
j <- ggplot(weather_summaryws, aes(x = ws, y = total_rides, colour = member_casual, group = member_casual)) +
  geom_line() +
  geom_point() +
  facet_wrap(~ rideable_type + member_casual) +
  labs(
    title = "Impact of Wind Speed on Ridership",
    x = "Wind Speed (m/s)",
    y = "Total Rides",
    colour = "User Type"
  ) +
  theme_minimal()

ggplotly(j)  # Interactive plot


