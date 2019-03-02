Final Report
================
Jorge Londono

Introduction
------------

The Metropolitan Transportation Authority (MTA) is New York City's public transportation system. This service allows the residents of New York City, those who live in the city's vicinity, and other visitors to have a viable means of transportation that is inexpensive and convenient. While many use it it as their main means of transportation, there are other private services such as taxis and ride share companies that have created additional options to New York City's commuters.

But why is there a such a growing market for these types of private transportation services? Ideally, a city's own transit should be able to be meet the needs of its citizens.

By looking at Uber ridership data, we can learn about what may cause the people of New York City to select more expensive private transportation services rather than the more affordable public transportation service the city provides. Using the results of this project, we can create a model that can be used to explain what factors are important and significant to the increase or decrease of Uber ridership. Additionally, this model can be used to predict the ridership for a given time and date by plugging in certain variables. This can be useful as a way for public transportation administrators to understand where and when they need to improve or expand service . Also, the results of this project can help private transportation services prepare for times when they are going to see a surge of ridership and how they can use this in order to better monetize their business.

Data Used
---------

The final data set used in this project will be a combination of 3 different data sets. The first and major one, provided by Five Thirty Eight, is Uber ridersehip data set in two different time spans from April 1st – September 30th 2014 and January 1st – March 31st 2015, containing thousands of observations . In this data set we can find the specific time and date there was a pickup by Uber.

    ##          Date.Time     Lat      Lon   Base
    ## 1 4/1/2014 0:11:00 40.7690 -73.9549 B02512
    ## 2 4/1/2014 0:17:00 40.7267 -74.0345 B02512
    ## 3 4/1/2014 0:21:00 40.7316 -73.9873 B02512
    ## 4 4/1/2014 0:28:00 40.7588 -73.9776 B02512
    ## 5 4/1/2014 0:33:00 40.7594 -73.9722 B02512
    ## 6 4/1/2014 0:33:00 40.7383 -74.0403 B02512

The next data set, contains the hourly temperature and weather conditions of a specific date This will be used to identify what the climate and the weater was for every observation in the data set.

    ##       Date Hour Temperature Weather Precip
    ## 1 1/1/2004    0          41     CLR      0
    ## 2 1/1/2004    1          41     CLR      0
    ## 3 1/1/2004    2          41     CLR      0
    ## 4 1/1/2004    3          41     CLR      0
    ## 5 1/1/2004    4          42     CLR      0
    ## 6 1/1/2004    5          41     CLR      0

Lastly, we will use a data set that has a list of holidays and its correspoding dates from 2010-2020. This will be used to see how holidays impact Uber ridership.

    ##    DAY_DATE           HOLIDAY_NAME
    ## 1  1/1/2010         New Year's Day
    ## 2 1/18/2010 Martin Luther King Day
    ## 3 2/15/2010        Presidents' Day
    ## 4  4/2/2010            Good Friday
    ## 5 5/31/2010           Memorial Day
    ## 6  7/4/2010       Independence Day

``` r
summary(cars)
```

    ##      speed           dist       
    ##  Min.   : 4.0   Min.   :  2.00  
    ##  1st Qu.:12.0   1st Qu.: 26.00  
    ##  Median :15.0   Median : 36.00  
    ##  Mean   :15.4   Mean   : 42.98  
    ##  3rd Qu.:19.0   3rd Qu.: 56.00  
    ##  Max.   :25.0   Max.   :120.00

Limitations of Data
-------------------

While we can obtain many insights from this data set, there are certain questions that cannot be answered by using it. For instance, while the results of this project can help us understand what factors can be attributed to an increase in private transportation usage, it cannot identify how how much of this traffic is being diverted from public transportation. This actual piece of insight is impossible to obtain with the data used in this project because there is no information about any type of public transportation ridership. Therefore, we cannot compare and make inferences on what portion of the private transportation ridership is being used as a direct substitute for public transportation.

Something that our data set does not take into account is any other type of special event happening in NYC that is not a holiday. Could there have been a special concert many New Yorkers attended? A special fair or parade that caused many New Yorkers to leave theor homes.

Additionally, since our data set will contain no information on public transportation services, there is no way to measure if cloures, delays, and other mishaps from the MTA are affecting Uber ridership.

Including Plots
---------------

You can also embed plots, for example:

![](Project_Final_Report_files/figure-markdown_github/pressure-1.png)

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
