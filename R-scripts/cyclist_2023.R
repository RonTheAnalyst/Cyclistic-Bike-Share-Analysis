# Install Packages and load them 

install.packages("tidyverse")
install.packages("worldmet")
install.packages("plotly")
library(tidyverse)
library(worldmet)
library(plotly)

# Step 1: Load CSV Files and Combine Data

## List all CSV files
csv_files <- list.files(pattern = "\\.csv$")

## Read all CSV files into a list of data frames
csv_list <- lapply(csv_files, read.csv)

## Combine all the data frames into one big data frame
cyclist_2023 <- do.call(rbind, csv_list)

## Check Structure of Cyclist Dataset
str(cyclist_2023)

## Saving Cyclist 2022 file into system 
write.csv(cyclist_2023,"cyclist-2023.csv", row.names = FALSE)  # Since we stored the local file in our system now we can use readr function to load dataset

## Removing csv_list and cyclist_2024 
rm(csv_list)
rm(cyclist_2023)


# Step 2: Load Cyclist-2022.csv, Data Cleaning and Formatting

## Load file 
library(readr)
cyclist_2023 <- read_csv("cyclist-2023.csv")
head(cyclist_2023)

# Checking for null values
## Columns to check
columns_to_check <- c("started_at", "ended_at", "rideable_type", "member_casual")

## Check for NA values in the specified columns
colSums(is.na(cyclist_2023[columns_to_check]))

## Formatting 'started_at' and 'ended_at' columns
cyclist_2023$started_at <- as.POSIXct(cyclist_2023$started_at, format = "%Y-%m-%d %H:%M:%S")
cyclist_2023$ended_at <- as.POSIXct(cyclist_2023$ended_at, format = "%Y-%m-%d %H:%M:%S")

str(cyclist_2023)

## Extract month name from 'started_at' and add it as a new column
cyclist_2023$month <- month.name[month(cyclist_2023$started_at)]

## Check for the month_name to confirm it's correctly added
head(cyclist_2023)


# Step 3: Calculate Total Ride Time

## Calculate the total time in seconds for each ride
cyclist_2023$Total_time_secs <- as.numeric(cyclist_2023$ended_at - cyclist_2023$started_at)

## Group by rideable type, member/casual status, and month_name, and calculate the mean ride time
Mean_Time_C23 <- cyclist_2023 %>%
  group_by(rideable_type, member_casual, month) %>%
  summarise(Mean_Ride_Time = mean(Total_time_secs/60, na.rm = TRUE))

## View summary data
head(Mean_Time_C23)

## Save Mean_Time 
write.csv(Mean_Time_C23,"Mean-ridetime-cyclist2023.csv", row.names = FALSE)


# Step 4: Plot Mean Ride Time Over Months

## Ensure months are ordered chronologically
Mean_Time_C23$month <- factor(Mean_Time_C23$month, 
                              levels = c("January", "February", "March", "April", "May","June", "July", "August", "September", "October", "November", "December"))


## Plot the mean ride time across months
ggplot(Mean_Time_C23, aes(x = month, y = Mean_Ride_Time, color = rideable_type, group = rideable_type)) +
  geom_line() +
  geom_point() +
  facet_wrap(rideable_type ~ member_casual, scales = "free") +
  labs(
    title = "Mean Ride Time Across Months by Rideable Type and Member Type",
    x = "Month",
    y = "Mean Ride Time (min)",
    color = "Rideable Type"
  ) +
  theme_minimal() +
  scale_color_brewer(palette = "Set1") +
  theme(
    axis.text.x =  element_text(angle = 45, hjust = 1),
    strip.text = element_text(size = 12),
    plot.title = element_text(hjust = 0.5, size = 16)
  )


# Step 5: Summarizing User Data

## Group by member/casual status, rideable type, and month_name, and count occurrences
Total_UserCount_Monthly <- cyclist_2023 %>%
  group_by(member_casual, rideable_type, month) %>%
  summarise(riders_count = n(), .groups = "drop")

## Define the correct order of months
month_levels <- c("January", "February", "March", "April", "May", "June", 
                  "July", "August", "September", "October", "November", "December")

## Order months for better clarity 
Total_UserCount_Monthly <- Total_UserCount_Monthly %>%
  mutate(month = factor(month, levels = month_levels)) %>%
  arrange(month)

## View the user summary
View(Total_UserCount_Monthly)

# Saving it to system 
write.csv(Total_UserCount_Monthly,"Monthly-UserCount-cyclist2023.csv", row.names = FALSE)


# Step 6: Plot Monthly User Counts 

## Plot bar graph showing user counts for each month and rideable type
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


# Step 7: Daily Ride Trends

## Extract day from 'started_at' and store in a new 'date' column
cyclist_2023 <- cyclist_2023 %>%
  mutate(Date = format(started_at, "%d"))

## Convert 'date' to numeric
cyclist_2023$Date <- as.numeric(cyclist_2023$Date)

## Group by member/casual, date, and month_name, and count rides per day
Daily_Trend <- cyclist_2023 %>%
  group_by(member_casual, Date, month, rideable_type) %>%
  summarise(total_rides = n(), .groups = "drop")

# Ensure month are correctly formatted 

## Define the correct order of months
month_levels <- c("January", "February", "March", "April", "May", "June", 
                  "July", "August", "September", "October", "November", "December")

## Arrange the data by month_name
Daily_Trend <- Daily_Trend %>%
  mutate(month = factor(month, levels = month_levels)) %>%
  arrange(month)

# Save Daily Trend
write.csv(Daily_Trend,"Daily-Trend-cyclist2023.csv", row.names = FALSE)


# Step 8: Extract Day from 'started_at' column using wday function
cyclist_2023 <- cyclist_2023 %>%
  mutate(Day = wday(started_at, label = TRUE, abbr = TRUE))

## Check the resulting dataset
str(cyclist_2023)

## Find the daily user count for each day of the week on a monthly basis
Weekday_UserCount <- cyclist_2023 %>%
  group_by(Day, member_casual, rideable_type, Date, month) %>%
  summarise(
    count = n(),
    .groups = "drop"
  )

## Calculate the mean weekday user_count 
Weekday_mean_Usercount <- Weekday_UserCount %>%
  group_by(Day, month, member_casual, rideable_type) %>%
  summarise(
    mean_count = mean(count, na.rm = TRUE),
    .groups = "drop"
  )
Weekday_mean_Usercount$mean_count <- round(Weekday_mean_Usercount$mean_count)

## Order Month correctly
Weekday_mean_Usercount <- Weekday_mean_Usercount %>%
  mutate(month = factor(month, levels = month_levels)) %>%
  arrange(month)


str(Weekday_mean_Usercount)

write.csv(Weekday_mean_Usercount, "Weekday_mean-cyclist2023.csv", row.names = FALSE)


## Group times into the specified ranges
cyclist_2023 <- cyclist_2023 %>%
  mutate(
    Hour = hour(started_at),  # Extract hour from 'started_at'
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

## Check the resulting dataset
str(cyclist_2023)

## Group by Time_Range, member_casual, and rideable_type, then count users
Time_range <- cyclist_2023 %>%
  group_by(Time_Range, member_casual, month, rideable_type) %>%   # Adding Month in v2 
  summarise(count = n(), .groups = "drop")

##  Define the correct order for Time_Range levels
time_levels <- c("0-2", "2-4", "4-6", "6-8", "8-10", "10-12", 
                 "12-14", "14-16", "16-18", "18-20", "20-22", "22-24")

## Convert Time_Range to a factor with specified levels
Time_range <- Time_range %>%
  mutate(Time_Range = factor(Time_Range, levels = time_levels, ordered = TRUE)) %>%
  arrange(Time_Range)

## Order Month correctly
Time_range <- Time_range %>%
  mutate(month = factor(month, levels = month_levels)) %>%
  arrange(month)

## View the resulting dataset
str(Time_range)

write.csv(Time_range,"TimeInterval-cyclist2023.csv", row.names = FALSE)

write.csv(cyclist_2023, "cyclist-2023-v2.csv", row.names = FALSE)


# Step 10: Extracting Chicago hourly weather data using world met

## Get a list of available NOAA stations
stations <- getMeta()

## Importing the data of CHICAGO MIDWAY INTL ARPT
weather_2023 <- importNOAA(year = 2023, code = "725340-14819")

## View the Data
View(weather_2023)

## Save it on system 
write.csv(weather_2023,"chicago.csv", row.names = FALSE)


# Step 11: Joining the weather data into cyclist dataset using left join

## Create join_key for both datasets
cyclist_2023 <- cyclist_2023 %>%
  mutate(join_key = floor_date(started_at, unit = "hour"))

weather_2023 <- weather_2023 %>%
  mutate(join_key = floor_date(date, unit = "hour"))

## Select the necessary weather columns along with join_key
weather_cols <- c("join_key", "air_temp", "RH", "ws")
chicago_weather <- weather_2023 %>% select(all_of(weather_cols))

## Perform the left join on join_key
cyclist_2023 <- left_join(cyclist_2023, chicago_weather, by = "join_key")

## Remove the join_key column if it's not needed in the final result
cyclist_2023 <- cyclist_2023 %>% select(-join_key)

## View the dataset
View(cyclist_2023)


# Step 12: Quick cleaning of the updated dataset if necessary 

## Checking for the null values specifically for the weather column
colSums(is.na(cyclist_2023))

## Filtering the dataset to see null values in temp (didn't run)
filtered_air_temp <- subset(cyclist_2023, is.na(air_temp))

View(filtered_air_temp)

## Grouping the dataset to actually for what date or time we don't have air_temp
null <- filtered_air_temp %>%
  group_by(Date, air_temp, month, Hour) %>%   # Adding Month in v2 
  summarise(count = n(), .groups = "drop")
print(null)

## Removing Those 17 hrs data from the dataset 
cyclist_2023 <- subset(cyclist_2023, !is.na(air_temp))


# Ready to do EDA on weather parameters
hist(cyclist_2023$air_temp, main="Temperature Distribution", xlab="Temperature (°C)", col="lightblue", breaks=30)

hist(cyclist_2023$RH, main="RH Distribution", xlab="Relative Humidity", col="lightblue", breaks=30)

hist(cyclist_2023$ws, main="Wind Speed Distribution", xlab="ws (m/s)", col="lightblue", breaks=30)

## Checking the null values for windspeed column (didn't run)
filtered_w <- subset(cyclist_2023, is.na(ws))

filtered_ws <- filtered_w %>% 
  group_by(Date,Hour,month,ws) %>%
  summarise(count = n (), .groups = "drop")
View (filtered_ws)  ## Since there only an hour in a whole where we don't have wind-speed data we can neglect it

colSums(is.na(cyclist_2023))

cyclist_Weather2023 <- cyclist_2023

write.csv(cyclist_Weather2023,"cyclist-2023(weather)-v3.csv",row.names = FALSE)

rm(cyclist_2023)
rm(chicago_weather)
rm(filtered_air_temp) # didn't run after this
rm(filtered_prec)
rm(filtered_prec_2,filtered_w,filtered_ws,null,stations,weath_2023,weather_2023,cyclist_2023_dt)## till here


# Step 13: Starting With weather analytics 

## Extracting the year from Started_at column 
cyclist_Weather2023$year <- year(cyclist_Weather2023$started_at)

## Extracting the data that could be the part of EDA 
weather <- cyclist_Weather2023 %>%
  group_by(Date,Hour,month,year,rideable_type,member_casual,air_temp,RH,ws) %>%
  summarise(Riders_count = n(), .groups = "drop")
View(weather)

weather <- weather %>%
  mutate(
    month = factor(month, levels = month_levels),
    air_temp = round(air_temp),
    RH = round(RH),
    ws = round(ws,2) ) %>%
  arrange(month)
write.csv(weather,"cyclist-2023-weather.csv", row.names = FALSE)

## Trying to Visualise how the user count differ with differing temp
weather_summary <- weather %>%
  group_by(air_temp, rideable_type,member_casual) %>%
  summarise(total_rides = sum(Riders_count), .groups = "drop")

p <- ggplot(weather_summary, aes(x = air_temp, y = total_rides, colour = member_casual)) +
  geom_point() +
  facet_wrap(~ rideable_type + member_casual) +
  theme_minimal()


ggplotly(p)

avgtemp <- weather %>%
  group_by(month)%>%
  summarise(avg=mean(air_temp), .groups = "drop")

View(avgtemp)

## For relative humidity
weather_summaryRH <- weather %>%
  group_by(RH, rideable_type,member_casual) %>%
  summarise(total_rides = sum(Riders_count), .groups = "drop")

K <- ggplot(weather_summaryRH, aes(x = RH, y = total_rides, colour = member_casual)) +
  geom_point() +
  facet_wrap(~ rideable_type + member_casual) +
  theme_minimal()

ggplotly(K)


## For windspeed
weather_summaryws <- weather %>%
  
  group_by(ws, rideable_type,member_casual) %>%
  summarise(total_rides = sum(Riders_count), .groups = "drop")

j <- ggplot(weather_summaryws, aes(x = ws, y = total_rides, colour = member_casual)) +
  geom_point() +
  facet_wrap(~ rideable_type + member_casual) +
  theme_minimal()

ggplotly(j)


colSums(is.na(cyclist_Weather2023))







