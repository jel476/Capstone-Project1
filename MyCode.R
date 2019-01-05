library(tidyr)
library(dplyr)
library(ggplot2)

weather<- read.delim2(file = "KNYC.txt")

colnames(weather) <- c("1")

weather <- separate(weather, 1, c("Site","Date","Hour","Temperature","Dewpoint","RH","WindDir","Windspeed","CldFrac","MSLP","Weather","Precip","Source"), 
         sep = ",")

weather <- select(weather, Date:Temperature, Weather:Precip)

weather$Date <- as.Date(weather$Date, format = "%m/%d/%Y")

weather <- subset(weather, Date >= "2014-04-01" & Date <= "2014-09-30" )


View(weather)

