##install.packages("scrapeR", dependencies = TRUE)
##install.packages("lubridate", dependencies = TRUE)
##install.packages("plyr", dependencies = TRUE)

library(scrapeR) 
library(XML) 
library(lubridate) 
##library(reshape2) 
library(plyr) 

setwd("C:/R_Projects/GIHourly")
date <- today() 
curdt <- Sys.time()

webpage <- scrape("http://w1.weather.gov/data/obhistory/KGRI.html") 

tab <- readHTMLTable(webpage[[1]], stringsAsFactors=FALSE) 
tab <- readHTMLTable(webpage[[1]], skip.rows=c(1, 2, 3), which=4, stringsAsFactors=FALSE)  
tab <- tab[-c((nrow(tab)-3):nrow(tab)),] 
names(tab) <- c("Day", "Time", "Wind", "Visibility", "Weather", "Sky", "Air.Temp", "DewPt", "Max6hr", "Min6hr", "Humidity", "WindChill", "HeatIndex", "AltimeterPressure", "SeaLevelPressure", "X1hrPrecip", "X3hrPrecip", "X6hrPrecip") 

tab$Humidity <- as.numeric(gsub("%","",tab$Humidity))
tab$Day <- as.integer(tab$Day)

currun <- paste(paste("GIhourly",curdt,sep="_"),"csv",sep=".")
currun <- chartr(":","-",currun)

curday <- as.integer(day(date))
tab$difday <- curday - tab$Day
tab$moflag <- as.integer(tab$difday<0)
tab$curyr <- as.integer(year(date))
tab$curmo <- as.integer( month(date) - tab$moflag)

str(tab)

tab$Date <- as.Date( paste( tab$curyr,  tab$curmo , tab$Day, sep = "." )  , format = "%Y.%m.%d" )

#tab$durdays <- ddays((day(date)-as.numeric(tab$Day))) 
#tab$Date <- as.Date(date-tab$durdays)
#tab$Date <- date-ddays((day(date)-as.numeric(tab$Day))) 
#tab$Date <- tab$Date - ( as.numeric(tab$Day) > day(today()) ) * months(1)
tab$DateTm <- ymd_hm(paste(tab$Date, tab$Time, sep=" "))

tab$difday <- NULL
tab$moflag <- NULL
tab$curyr <- NULL
tab$curmo <- NULL


write.csv(tab, currun, row.names=FALSE) 



data <- read.csv("GIhourlynew2.csv", stringsAsFactors=FALSE) 
##data$Humidity <- as.numeric(gsub("%","",data$Humidity))

data$durdays <- NULL

data$DateTm <- ymd_hms(data$DateTm)

data <- rbind.fill(data, tab[which(!tab$DateTm %in% data$DateTm),])
data <- data[order(data$DateTm),]

##data$Date <- data$Date - ( as.numeric(data$Day) > day(today()) ) * months(1)


data$DateTm <- ymd_hm(paste(data$Date, data$Time, sep=" "))

newdata <- data[ !(data$Date %in% c("2017-08-29","2017-08-30","2017-08-31")), ]
str(data)
print(count(data,vars="Date"))
count(data,vars="Date")

write.csv(data, "GIhourlyNew2.csv", row.names=FALSE)
write.csv(tab, "GIhourly2.csv", row.names=FALSE) 

