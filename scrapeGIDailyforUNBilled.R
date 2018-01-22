## install.packages("httr")
library(httr)
library(RCurl)
library(scrapeR)
library(XML)
library(lubridate)
##library(reshape2)
library(plyr)
library(stringr)
#library(rJava)
#library(xlsx)
##?httr

## Clear the Console
cat("\014")
## Clear the data Environment
rm(list=ls())
setwd("C:/R_Projects")
# Read pages
page01 <- getURL("https://www.accuweather.com/en/us/grand-island-ne/68801/january-weather/329504?monyr=1/1/2017&view=table")
page02 <- getURL("https://www.accuweather.com/en/us/grand-island-ne/68801/february-weather/329504?monyr=2/1/2017&view=table")
page03 <- getURL("https://www.accuweather.com/en/us/grand-island-ne/68801/march-weather/329504?monyr=3/1/2017&view=table")
page04 <- getURL("https://www.accuweather.com/en/us/grand-island-ne/68801/april-weather/329504?monyr=4/1/2017&view=table")
page05 <- getURL("https://www.accuweather.com/en/us/grand-island-ne/68801/may-weather/329504?monyr=5/1/2017&view=table")
page06 <- getURL("https://www.accuweather.com/en/us/grand-island-ne/68801/june-weather/329504?monyr=6/1/2017&view=table")
page07 <- getURL("https://www.accuweather.com/en/us/grand-island-ne/68801/july-weather/329504?monyr=7/1/2017&view=table")
page08 <- getURL("https://www.accuweather.com/en/us/grand-island-ne/68801/august-weather/329504?monyr=8/1/2017&view=table")
page09 <- getURL("https://www.accuweather.com/en/us/grand-island-ne/68801/september-weather/329504?monyr=9/1/2017&view=table")
page10 <- getURL("https://www.accuweather.com/en/us/grand-island-ne/68801/october-weather/329504?monyr=10/1/2017&view=table")
page11 <- getURL("https://www.accuweather.com/en/us/grand-island-ne/68801/november-weather/329504?monyr=11/1/2017&view=table")
page12 <- getURL("https://www.accuweather.com/en/us/grand-island-ne/68801/december-weather/329504?monyr=12/1/2017&view=table")
#class(page06)
frame01 <- readHTMLTable(page01, which=1, stringAsFactors=FALSE)
frame02 <- readHTMLTable(page02, which=1, stringAsFactors=FALSE)
frame03 <- readHTMLTable(page03, which=1, stringAsFactors=FALSE)
frame04 <- readHTMLTable(page04, which=1, stringAsFactors=FALSE)
frame05 <- readHTMLTable(page05, which=1, stringAsFactors=FALSE)
frame06 <- readHTMLTable(page06, which=1, stringAsFactors=FALSE)
frame07 <- readHTMLTable(page07, which=1, stringAsFactors=FALSE)
frame08 <- readHTMLTable(page08, which=1, stringAsFactors=FALSE)
frame09 <- readHTMLTable(page09, which=1, stringAsFactors=FALSE)
frame10 <- readHTMLTable(page10, which=1, stringAsFactors=FALSE)
frame11 <- readHTMLTable(page11, which=1, stringAsFactors=FALSE)
frame12 <- readHTMLTable(page12, which=1, stringAsFactors=FALSE)

gitab <- rbind(frame01,frame02,frame03,frame04,frame05,frame06,frame07,frame08,frame09,frame10,frame11,frame12)
rm(page01,page02,page03,page04, page05, page06,page07,page08,page09,page10,page11,page12)
rm(frame01,frame02,frame03,frame04,frame05,frame06,frame07,frame08,frame09,frame10,frame11,frame12)

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
write.csv(gitab, "2017GIWeather_forecast.csv", row.names=FALSE)
gitab$Forecast <- NULL
write.csv(gitab, "2017GIWeather.csv", row.names=FALSE)
write.xlsx(gitab, "2017GIWeather.xlsx", row.names=FALSE)

gitab[274:305,]


