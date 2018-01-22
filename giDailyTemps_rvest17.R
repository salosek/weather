## giDailyTemps_rvest17.R Scrape Daily Hi/Lo Temps from Accuweather for GI

##install.packages("openxlsx")
##installed.packages("rvest")
##install.packages("rJava")

if(!dir.exists("data")){
      dir.create("data")
  } else { 
      message("directory data already exists")
  }
getwd()
dir(path = ".")

library("rvest")
#library("rJava")
library(openxlsx)

## Clear the Console
cat("\014")
## Clear the data Environment
rm(list=ls())
setwd("C:/rProjects/weather")

dtab <- read_html("https://www.accuweather.com/en/us/grand-island-ne/68801/january-weather/329504?monyr=1/1/2017&view=table")
tab <- html_nodes(dtab, css = "table")
tab01 <- html_table(tab, fill = TRUE, header = FALSE)[[1]]
tab01 <- tab01[-c(1),] 

dtab <- read_html("https://www.accuweather.com/en/us/grand-island-ne/68801/february-weather/329504?monyr=2/1/2017&view=table")
tab <- html_nodes(dtab, css = "table")
tab02 <- html_table(tab, fill = TRUE, header = FALSE)[[1]]
tab02 <- tab02[-c(1),] 

dtab <- read_html("https://www.accuweather.com/en/us/grand-island-ne/68801/march-weather/329504?monyr=3/1/2017&view=table")
tab <- html_nodes(dtab, css = "table")
tab03 <- html_table(tab, fill = TRUE, header = FALSE)[[1]]
tab03 <- tab03[-c(1),] 

dtab <- read_html("https://www.accuweather.com/en/us/grand-island-ne/68801/april-weather/329504?monyr=4/1/2017&view=table")
tab <- html_nodes(dtab, css = "table")
tab04 <- html_table(tab, fill = TRUE, header = FALSE)[[1]]
tab04 <- tab04[-c(1),] 

dtab <- read_html("https://www.accuweather.com/en/us/grand-island-ne/68801/may-weather/329504?monyr=5/1/2017&view=table")
tab <- html_nodes(dtab, css = "table")
tab05 <- html_table(tab, fill = TRUE, header = FALSE)[[1]]
tab05 <- tab05[-c(1),] 

dtab <- read_html("https://www.accuweather.com/en/us/grand-island-ne/68801/june-weather/329504?monyr=6/1/2017&view=table")
tab <- html_nodes(dtab, css = "table")
tab06 <- html_table(tab, fill = TRUE, header = FALSE)[[1]]
tab06 <- tab06[-c(1),] 

dtab <- read_html("https://www.accuweather.com/en/us/grand-island-ne/68801/july-weather/329504?monyr=7/1/2017&view=table")
tab <- html_nodes(dtab, css = "table")
tab07 <- html_table(tab, fill = TRUE, header = FALSE)[[1]]
tab07 <- tab07[-c(1),] 

dtab <- read_html("https://www.accuweather.com/en/us/grand-island-ne/68801/august-weather/329504?monyr=8/1/2017&view=table")
tab <- html_nodes(dtab, css = "table")
tab08 <- html_table(tab, fill = TRUE, header = FALSE)[[1]]
tab08 <- tab08[-c(1),] 

dtab <- read_html("https://www.accuweather.com/en/us/grand-island-ne/68801/september-weather/329504?monyr=9/1/2017&view=table")
tab <- html_nodes(dtab, css = "table")
tab09 <- html_table(tab, fill = TRUE, header = FALSE)[[1]]
tab09 <- tab09[-c(1),] 

dtab <- read_html("https://www.accuweather.com/en/us/grand-island-ne/68801/october-weather/329504?monyr=10/1/2017&view=table")
tab <- html_nodes(dtab, css = "table")
tab10 <- html_table(tab, fill = TRUE, header = FALSE)[[1]]
tab10 <- tab10[-c(1),] 

dtab <- read_html("https://www.accuweather.com/en/us/grand-island-ne/68801/november-weather/329504?monyr=11/1/2017&view=table")
tab <- html_nodes(dtab, css = "table")
tab11 <- html_table(tab, fill = TRUE, header = FALSE)[[1]]
tab11 <- tab11[-c(1),] 

dtab <- read_html("https://www.accuweather.com/en/us/grand-island-ne/68801/december-weather/329504?monyr=12/1/2017&view=table")
tab <- html_nodes(dtab, css = "table")
tab12 <- html_table(tab, fill = TRUE, header = FALSE)[[1]]
tab12 <- tab12[-c(1),] 

gitab <- rbind(tab01,tab02,tab03,tab04,tab05,tab06,tab07,tab08,tab09,tab10,tab11,tab12)
rm(dtab,tab, tab01, tab02, tab03, tab04, tab05, tab06, tab07, tab08, tab09, tab10, tab11, tab12)

names(gitab) <- c("Date", "HiLo", "Precip", "Snow", "Forecast", "AvgHiLo")

##reformat the data
gitab$Date <- chartr(" ",",",gitab$Date)
gitab$Date <- sub(".*,","",gitab$Date)
gitab$Date <- paste(gitab$Date,"/2017")
gitab$Date <- as.Date(gsub(" ","",gitab$Date), "%m/%d/%Y")

gitab$Precip <- as.numeric(gsub(" in","",gitab$Precip))
gitab$Snow <- as.numeric(gsub(" in","",gitab$Snow))

gitab$HiLo <- chartr("/",",",gitab$HiLo)
gitab$TMaxGI <- sub(",.*","",gitab$HiLo)
gitab$TMinGI <- sub(".*,","",gitab$HiLo)
gitab$HiLo <- NULL

gitab$TMaxGI <- as.numeric(gsub("°","",gitab$TMaxGI))
gitab$TMinGI <- as.numeric(gsub("°","",gitab$TMinGI))

gitab$AvgHiLo <- chartr("/",",",gitab$AvgHiLo)
gitab$AvgHigh <- sub(",.*","",gitab$AvgHiLo)
gitab$AvgLow <- sub(".*,","",gitab$AvgHiLo)
gitab$AvgHiLo <- NULL

gitab$AvgHigh <- as.numeric(gsub("°","",gitab$AvgHigh))
gitab$AvgLow <- as.numeric(gsub("°","",gitab$AvgLow))

##count(gitab,vars=year(gitab$Date))
write.csv(gitab, "./data/2017GIWeather_forecast.csv", row.names=FALSE)
gitab$Forecast <- NULL
write.csv(gitab, "./data/2017GIWeather.csv", row.names=FALSE)
write.xlsx(gitab, file = "./data/2017GIWeather99.xlsx", rowNames=FALSE, colNames = TRUE)

print(gitab[1:365,])     ## Jan 1:31, Feb 32:59, Mar 60:90, Apr 91:120, May 121:151, Jun 152:181
                           ## Jul 182:212, Aug 213:243, Sep 244:273, Oct 274:304, Nov 305:334, Dec 335:365
print(Sys.Date())



