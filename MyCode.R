library(tidyr)
library(dplyr)
library(ggplot2)
library(lubridate)
library(timeDate)

# Weather data tidying, this can be factored

weather<- read.delim2(file = "KNYC.txt")

colnames(weather) <- c("1")

weather <- separate(weather, 1, c("Site","Date","Hour","Temperature","Dewpoint","RH","WindDir","Windspeed","CldFrac","MSLP","Weather","Precip","Source"), 
         sep = ",")

weather <- select(weather, Date:Temperature, Weather:Precip)

weather$Date <- as.Date(weather$Date, format = "%m/%d/%Y")

weather <- subset(weather, Date >= "2014-04-01" & Date <= "2014-09-30" )

weather$Hour <- sprintf("%02d", as.numeric(weather$Hour))

weather$Date <- ymd(weather$Date)



#holiday data tidying

holidays <- read.csv("2010-2020 Holiday Dates.csv")

holidays <- select(holidays, DAY_DATE, HOLIDAY_NAME)

holidays$DAY_DATE <- as.Date(holidays$DAY_DATE, format ="%m/%d/%Y" )

holidays$DAY_DATE <- ymd(holidays$DAY_DATE)


#uber raw data tidY

april <- read.csv("uber-raw-data-apr14.csv")

april$Date.Time <- as.POSIXct(april$Date.Time, format = "%m/%d/%Y %H:%M:%S")

april <- separate(april, Date.Time, c("Date", "Time"), sep = " ")



may <- read.csv("uber-raw-data-may14.csv")

may$Date.Time <- as.POSIXct(may$Date.Time, format = "%m/%d/%Y %H:%M:%S")

may <- separate(may, Date.Time, c("Date", "Time"), sep = " ")


june <- read.csv("uber-raw-data-jun14.csv")

june$Date.Time <- as.POSIXct(june$Date.Time, format = "%m/%d/%Y %H:%M:%S")

june <- separate(june, Date.Time, c("Date", "Time"), sep = " ")


july <- read.csv("uber-raw-data-jul14.csv")

july$Date.Time <- as.POSIXct(july$Date.Time, format = "%m/%d/%Y %H:%M:%S")

july <- separate(july, Date.Time, c("Date", "Time"), sep = " ")


august <- read.csv("uber-raw-data-aug14.csv")

august$Date.Time <- as.POSIXct(august$Date.Time, format = "%m/%d/%Y %H:%M:%S")

august <- separate(august, Date.Time, c("Date", "Time"), sep = " ")


september <- read.csv("uber-raw-data-sep14.csv")

september$Date.Time <- as.POSIXct(september$Date.Time, format = "%m/%d/%Y %H:%M:%S")

september <- separate(september, Date.Time, c("Date", "Time"), sep = " ")



uber <- april %>% 
  bind_rows(may) %>% 
  bind_rows(june) %>% 
  bind_rows(july) %>% 
  bind_rows(august) %>% 
  bind_rows(september)

uber$Hour <- format(strptime(uber$Time, "%H:%M:%S"), "%H")



uber <- uber %>% 
  group_by(Date, Hour) %>% 
  summarise(Rides = n())

uber$Date <- ymd(uber$Date)

# Compiling 

uber_weather <- left_join(uber, weather)

uber_weather <- left_join(uber_weather, holidays, by = c("Date" = "DAY_DATE"))

# Renaming columns

uber_weather <- rename(uber_weather, Holiday_Name = HOLIDAY_NAME )

uber_weather <- rename(uber_weather, Precipitation = Precip)

# Creating Holiday binary column

uber_weather$Holiday <- ifelse(is.na(uber_weather$Holiday_Name), "no", "yes")

# Creating weekend column

uber_weather$Weekend <- isWeekend(uber_weather$Date)

ggplot(uber_weather, aes(x = Date, y = Rides)) +
  geom_smooth() +
  geom_jitter(shape = ".")

