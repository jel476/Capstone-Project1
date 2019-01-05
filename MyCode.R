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

View(april)



