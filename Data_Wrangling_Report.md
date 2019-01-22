Data Wrangling Report
================

Loaded packages for necessary for the project
---------------------------------------------

``` r
library(tidyr)
```

``` r
library(ggplot2)
```

``` r
library(timeDate)
```

``` r
library(lubridate)
```

``` r
library(dplyr)
```

Weather data tidying
--------------------

I opened the weather data and seperated the singular column of data into its corresponding variables. I then made sure to select the variables I would use for this project and made sure to format the Date column. I also made sure to select the only the dates that correspond the Uber data.

``` r
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
```

Holiday Data Tidying
--------------------

Opened the holiday data, made sure to only select the colmuns/variables necessary, and formatted the dates.

``` r
holidays <- read.csv("2010-2020 Holiday Dates.csv")

holidays <- select(holidays, DAY_DATE, HOLIDAY_NAME)

holidays$DAY_DATE <- as.Date(holidays$DAY_DATE, format ="%m/%d/%Y" )

holidays$DAY_DATE <- ymd(holidays$DAY_DATE)
```

Uber Data Tydying
-----------------

Opened the Uber Data from each .csv file. I fomratted the Time and Date, and then sepearated this singular column into 2.

``` r
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
```

Compiling the seperate Uber data sets into 1
--------------------------------------------

Now that all of the data sets are uniform, I compiled them all into 1 data set.

``` r
uber <- april %>% 
  bind_rows(may) %>% 
  bind_rows(june) %>% 
  bind_rows(july) %>% 
  bind_rows(august) %>% 
  bind_rows(september) %>% 
  bind_rows(early2015)
```

Added 2 more variables
----------------------

I created a column for the hour of the day in which the ride took place. I also grouped by and created a column for the total number of rides in the hour of that specific day.

``` r
uber$Hour <- format(strptime(uber$Time, "%H:%M:%S"), "%H")


uber <- uber %>% 
  group_by(Date, Hour) %>% 
  summarise(Rides = n())

uber$Date <- ymd(uber$Date)
```

Compiling all of the data sets
------------------------------

I was now able to compile the Uber data set, the holiday data set, and the weather data set.

``` r
uber_weather <- left_join(uber, weather3)
```

    ## Joining, by = c("Date", "Hour")

``` r
uber_weather <- left_join(uber_weather, holidays, by = c("Date" = "DAY_DATE"))
```

I then renamed a couple of columns

``` r
uber_weather <- rename(uber_weather, Holiday_Name = HOLIDAY_NAME )

uber_weather <- rename(uber_weather, Precipitation = Precip)
```

Created 2 more columns
----------------------

Created a "yes" or "no" column to find out if the Date falls on a holiday.

``` r
uber_weather$Holiday <- ifelse(is.na(uber_weather$Holiday_Name), "no", "yes")
```

Created a "TRUE" or "FALSE" column to find out if the Date falls on a weekend

``` r
uber_weather$Weekend <- isWeekend(uber_weather$Date)
```

Tidying the Weather column
--------------------------

A problem with the Weather column is that it sometimes contains variables that are a combination of weather conditions. A solution to this would be to find the mean ridership for that variable then compare it to the mean of the individual variables that make up the combination.

``` r
aggregate(uber_weather[,3], list(uber_weather$Weather), mean)
```

    ##     Group.1    Rides
    ## 1     -FZRA 2752.000
    ## 2  -FZRA BR 5505.143
    ## 3       -RA 2615.068
    ## 4    -RA BR 2651.886
    ## 5    -RA FG 1778.000
    ## 6       -SN 3317.588
    ## 7    -SN BR 3160.174
    ## 8  -SN FZFG 3156.000
    ## 9       +RA 1460.500
    ## 10   +RA BR 2428.188
    ## 11   +RA FG 2577.250
    ## 12      +SN 3789.167
    ## 13      BKN 2032.127
    ## 14       BR 1893.789
    ## 15      CLR 2073.385
    ## 16      FEW 2081.041
    ## 17       FG 2273.500
    ## 18       HZ 2754.836
    ## 19      OVC 2251.035
    ## 20       RA 2337.400
    ## 21    RA BR 2978.629
    ## 22    RA FG 4776.500
    ## 23      SCT 2023.624
    ## 24       SN 3977.600
    ## 25    SN FG 2178.250
    ## 26  SN FZFG 4227.143
    ## 27       UP 2793.222
    ## 28    UP BR 2733.182

Now that I know the results, I can change the change the combination variables to the the variable in its singular component that is closer to its mean.

``` r
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
```
