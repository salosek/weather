##install.packages("scrapeR", dependencies = TRUE)
##install.packages("lubridate", dependencies = TRUE)
##install.packages("plyr", dependencies = TRUE)

library(scrapeR) 
library(XML) 
library(lubridate) 
##library(reshape2) ``
library(plyr) 

setwd("C:/R_Projects")
date <- today() 
date
cday <- day(date)
cday

webpage <- scrape("http://w1.weather.gov/data/obhistory/KGRI.html") 

tab <- readHTMLTable(webpage[[1]], stringsAsFactors=FALSE) 
tab <- readHTMLTable(webpage[[1]], skip.rows=c(1, 2, 3), which=4, stringsAsFactors=FALSE) 
tab <- tab[-c((nrow(tab)-3):nrow(tab)),] 
names(tab) <- c("Day", "Time", "Wind", "Visibility", "Weather", "Sky", "Air.Temp", "DewPt", "Max6hr", "Min6hr", "Humidity", "WindChill", "HeatIndex", "AltimeterPressure", "SeaLevelPressure", "X1hrPrecip", "X3hrPrecip", "X6hrPrecip") 

tab$Date <- date-ddays((day(date)-as.numeric(tab$Day))) 
tab$Date

tab$Date <- tab$Date - ( as.numeric(tab$Day) > day(today()) ) * months(1)
tab$Date
                

tab$DateTime <- ymd_hm(paste(tab$Date, tab$Time, sep=" ")) 


write.csv(tab, "GIhourlyWeb.csv", row.names=FALSE)



data <- read.csv("GIhourly.csv", stringsAsFactors=FALSE) 
data$DateTime <- ymd_hms(data$DateTime) 

data <- rbind.fill(data, tab[which(!tab$DateTime %in%data$DateTime),]) 
data <- data[order(data$DateTime),]
count(data,vars="Date")

write.csv(data, "GIhourly.csv", row.names=FALSE)
write.csv(tab, "GIhourly2.csv", row.names=FALSE) 

