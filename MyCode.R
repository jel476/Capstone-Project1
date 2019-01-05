library(tidyr)
library(dplyr)
library(ggplot2)

# Weather data tidying

weather<- read.delim2(file = "KNYC.txt")

colnames(weather) <- c("1")

weather <- separate(weather, 1, c("Site","Date","Hour","Temperature","Dewpoint","RH","WindDir","Windspeed","CldFrac","MSLP","Weather","Precip","Source"), 
         sep = ",")

weather <- select(weather, Date:Temperature, Weather:Precip)

weather$Date <- as.Date(weather$Date, format = "%m/%d/%Y")

weather <- subset(weather, Date >= "2014-04-01" & Date <= "2014-09-30" )


#holiday data tidying

holidays <- read.csv("2010-2020 Holiday Dates.csv")

holidays <- select(holidays, 1:4)

holidays$DAY_DATE <- as.Date(holidays$DAY_DATE, format ="%m/%d/%Y" )


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

View(uber)
