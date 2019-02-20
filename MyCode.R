library(tidyr)
library(dplyr)
library(ggplot2)
library(lubridate)
library(timeDate)
library(hrbrthemes)
library(formattable)
library(viridis)

# Weather data tidying

weather<- read.delim2(file = "KNYC.txt")

colnames(weather) <- c("1")

weather <- separate(weather, 1, c("Site","Date","Hour","Temperature","Dewpoint","RH","WindDir","Windspeed","CldFrac","MSLP","Weather","Precip","Source"), 
         sep = ",")

weather <- select(weather, Date:Temperature, Weather:Precip)

weather$Date <- as.Date(weather$Date, format = "%m/%d/%Y")

weather1 <- subset(weather, Date >= "2014-04-01" & Date <= "2014-09-30")

weather1$Hour <- sprintf("%02d", as.numeric(weather1$Hour))

weather1$Date <- ymd(weather1$Date)



weather2 <- subset(weather, Date >= "2015-01-01" & Date <= "2015-06-30")

weather2$Hour <- sprintf("%02d", as.numeric(weather2$Hour))

weather2$Date <- ymd(weather2$Date)


weather3 <- rbind(weather1, weather2)


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



early2015 <- read.csv("uber-raw-data-janjune.csv")

early2015 <- separate(early2015, Pickup_date, c("Date", "Time"), sep = " ")

early2015 <- early2015[order(early2015$Date, early2015$Time),]




uber <- april %>% 
  bind_rows(may) %>% 
  bind_rows(june) %>% 
  bind_rows(july) %>% 
  bind_rows(august) %>% 
  bind_rows(september) %>% 
  bind_rows(early2015)



uber$Hour <- format(strptime(uber$Time, "%H:%M:%S"), "%H")


uber <- uber %>% 
  group_by(Date, Hour) %>% 
  summarise(Rides = n())

uber$Date <- ymd(uber$Date)


# Compiling 

uber_weather <- left_join(uber, weather3)


uber_weather <- left_join(uber_weather, holidays, by = c("Date" = "DAY_DATE"))



# Renaming columns

uber_weather <- rename(uber_weather, Holiday_Name = HOLIDAY_NAME )

uber_weather <- rename(uber_weather, Precipitation = Precip)

# Creating Holiday binary column

uber_weather$Holiday <- ifelse(is.na(uber_weather$Holiday_Name), "no", "yes")

# Creating weekend column

uber_weather$Weekend <- isWeekend(uber_weather$Date)




#find out where combinations of precipitation should be changed to


aggregate(uber_weather[,3], list(uber_weather$Weather), mean)

# change the combinations to singular based on the results 

uber_weather$Weather <- uber_weather$Weather %>% 
  gsub(pattern = "-FZRA BR", replacement = "-FZRA") %>% 
  gsub(pattern = "-RA BR", replacement = "-RA") %>% 
  gsub(pattern = "-RA FG", replacement = "FG") %>% 
  gsub(pattern = "-SN BR", replacement = "-SN") %>% 
  gsub(pattern = "-SN FZFG", replacement = "-SN") %>% 
  gsub(pattern = "+RA BR", replacement = "+RA") %>% 
  gsub(pattern = "\\++RA", replacement = "+RA") %>% 
  gsub(pattern = "\\+RA FG", replacement = "+RA") %>% 
  gsub(pattern = "RA FG", replacement = "RA") %>% 
  gsub(pattern = "SN FG", replacement = "FG") %>% 
  gsub(pattern = "SN FZFG", replacement = "SN") %>% 
  gsub(pattern = "UP BR", replacement = "UP")


# Adding variables of different fromats of dates for visualization

uber_weather<-uber_weather%>%
  mutate(weekday=factor(weekdays(Date, T),levels = rev(c("Mon", "Tue", "Wed", "Thu","Fri", "Sat", "Sun"))))%>%
  mutate(year=format(Date,'%Y'))%>%
  mutate(month=format(Date, '%b')) %>% 
  mutate(week=as.numeric(format(Date,"%W")))


uber_weather$month = factor(uber_weather$month, levels = month.abb)

uber_weather <- uber_weather %>% 
  group_by(year, month) %>% 
  mutate(monthly_average = mean(Rides))


uber_weather$Temperature <- as.numeric(as.character(uber_weather$Temperature))

uber_weather$temp_ranges <- cut(uber_weather$Temperature, breaks=c(0,9,19,29,39,49,59,69,79,89,99), labels=c("0-9","10-19","20-29","30-39",
                                                                                                           "40-49","50-59","60-69",
                                                                                                           "70-79","80-89","90-99"))
uber_weather$Precipitation <- as.numeric(as.character(uber_weather$Precipitation)) 



#log column for normal data transformation

uber_weather <- uber_weather %>% 
  mutate(logvalues = log10(Rides))

ggplot(uber_weather, aes(logvalues))+
  geom_histogram()






#Data Visualization

uber_weather2014 <- subset(uber_weather, year == 2014)
uber_weather2015 <- subset(uber_weather, year == 2015)

## heat map

  
ggplot(uber_weather, aes(x = week, y = weekday, fill = Rides)) +
  viridis::scale_fill_viridis(name="Uber Rides",
                              option = 'C',
                              direction = 1,
                              na.value = "grey93") +
  geom_tile(color = 'white', size = 0.1) +
  facet_wrap('year', ncol = 1) +
  scale_x_continuous(
    expand = c(0, 0),
    breaks = seq(1, 52, length = 12),
    labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
               "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")) +
  theme_ipsum_rc(plot_title_family = 'Slabo 27px')




ggplot(uber_weather2014, aes(x = week, y = weekday, fill = Rides)) +
  viridis::scale_fill_viridis(name="Uber Rides",
                              option = 'C',
                              direction = 1,
                              na.value = "grey93") +
  geom_tile(color = 'white', size = 0.1) +
  facet_wrap('year', ncol = 1) +
  scale_x_continuous(
    expand = c(0, 0),
    breaks = seq(1, 52, length = 12),
    labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
               "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")) +
  theme_ipsum_rc(plot_title_family = 'Slabo 27px')

ggplot(uber_weather2015, aes(x = week, y = weekday, fill = Rides)) +
  viridis::scale_fill_viridis(name="Uber Rides",
                              option = 'C',
                              direction = 1,
                              na.value = "grey93") +
  geom_tile(color = 'white', size = 0.1) +
  facet_wrap('year', ncol = 1) +
  scale_x_continuous(
    expand = c(0, 0),
    breaks = seq(1, 52, length = 12),
    labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
               "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")) +
  theme_ipsum_rc(plot_title_family = 'Slabo 27px')


##Smooth

ggplot(uber_weather, aes(Date, Rides)) +
  geom_smooth() +
  geom_jitter(shape=".")

ggplot(uber_weather2014, aes(Date, Rides)) +
  geom_smooth() +
  geom_jitter(shape=".")

ggplot(uber_weather2015, aes(Date, Rides)) +
  geom_smooth() +
  geom_jitter(shape=".")

##Bar graph

ggplot(uber_weather, aes(x = month, y = monthly_average)) +
  geom_bar(stat = "identity") 
  

ggplot(uber_weather2014, aes(month, monthly_average)) +
  geom_bar(stat = "identity") 

  

ggplot(uber_weather2015, aes(month, monthly_average)) +
  geom_bar(stat = "identity") 




##Boxplot

ggplot(uber_weather, aes(x = year, y = Rides)) +
geom_boxplot()

ggplot(uber_weather2014, aes(month, Rides)) +
  geom_boxplot()

ggplot(uber_weather2015, aes(month, Rides)) +
  geom_boxplot()



ggplot(uber_weather, aes(x = Weather, y = Rides)) +
  geom_boxplot()

ggplot(uber_weather2014, aes(Weather, Rides)) +
  geom_boxplot()

ggplot(uber_weather2015, aes(Weather, Rides)) +
  geom_boxplot()



ggplot(uber_weather, aes(x = temp_ranges, y = Rides)) +
  geom_boxplot()

ggplot(uber_weather2014, aes(temp_ranges, Rides)) +
  geom_boxplot()

ggplot(uber_weather2015, aes(temp_ranges, Rides)) +
  geom_boxplot()

## Linear graph
ggplot(uber_weather, aes(Date, Rides)) +
  geom_smooth(method = "lm", se = FALSE) +
  geom_jitter(shape=".")

ggplot(uber_weather2014, aes(Date, Rides)) +
  geom_smooth(method = "lm", se = FALSE) +
  geom_jitter(shape=".")

ggplot(uber_weather2015, aes(Date, Rides)) +
  geom_smooth(method = "lm", se = FALSE) +
  geom_jitter(shape=".")


## Holiday patterns

holidaydataset <- uber_weather %>% 
  filter(Holiday == "yes") %>% 
  group_by(Holiday_Name, year) 


  
  ggplot(holidaydataset ,aes(x = Holiday_Name, y = Rides, fill = year ))+
  geom_bar(stat = "identity" , position = "dodge")


  holidaydataset <- uber_weather %>% 
    filter(Holiday == "yes") %>% 
    group_by(Holiday_Name, year)  %>% 
    summarise(sum(Rides)) 


View(holidaydataset)


uber_weather %>% 
  filter(year == "2015") %>% 
  group_by(weekday) %>% 
  summarise(mean(Rides))
 

#Linear Regression model

model1 <- lm(logvalues ~ Temperature + Date + Hour + Precipitation + Weather + Holiday + Weekend, data = uber_weather)
summary(model1)

1
