##install.packages("scrapeR", dependencies = TRUE)
##install.packages("lubridate", dependencies = TRUE)
##install.packages("plyr", dependencies = TRUE)
##install.packages("stringr")
#install.packages("xlsx")
#install.packages("rJava")

library(scrapeR) 
library(XML) 
library(lubridate) 
##library(reshape2) 
library(plyr) 
library(stringr)
#library(rJava)
#library(xlsx)


setwd("C:/R_Projects") 
date <- today() 
##read in the tables
                     
parse01 <- htmlParse("https://www.accuweather.com/en/us/grand-island-ne/68801/january-weather/329504?monyr=1/1/2017&view=table")
parse02 <- htmlParse("http://www.accuweather.com/en/us/grand-island-ne/68801/february-weather/329504?monyr=2/1/2017&view=table")
parse03 <- htmlParse("http://www.accuweather.com/en/us/grand-island-ne/68801/march-weather/329504?monyr=3/1/2017&view=table")
parse04 <- htmlParse("http://www.accuweather.com/en/us/grand-island-ne/68801/april-weather/329504?monyr=4/1/2017&view=table")
parse05 <- htmlParse("http://www.accuweather.com/en/us/grand-island-ne/68801/may-weather/329504?monyr=5/1/2017&view=table")
parse06 <- htmlParse("http://www.accuweather.com/en/us/grand-island-ne/68801/june-weather/329504?monyr=6/1/2017&view=table")
parse07 <- htmlParse("http://www.accuweather.com/en/us/grand-island-ne/68801/july-weather/329504?monyr=7/1/2017&view=table")
parse08 <- htmlParse("http://www.accuweather.com/en/us/grand-island-ne/68801/august-weather/329504?monyr=8/1/2017&view=table")
parse09 <- htmlParse("http://www.accuweather.com/en/us/grand-island-ne/68801/september-weather/329504?monyr=9/1/2017&view=table")
parse10 <- htmlParse("http://www.accuweather.com/en/us/grand-island-ne/68801/october-weather/329504?monyr=10/1/2017&view=table")
parse11 <- htmlParse("http://www.accuweather.com/en/us/grand-island-ne/68801/november-weather/329504?monyr=11/1/2017&view=table")
parse12 <- htmlParse("http://www.accuweather.com/en/us/grand-island-ne/68801/december-weather/329504?monyr=12/1/2017&view=table")
#class(parse06)
frame01 <- readHTMLTable(parse01, which=1, stringAsFactors=FALSE)
frame02 <- readHTMLTable(parse02, which=1, stringAsFactors=FALSE)
frame03 <- readHTMLTable(parse03, which=1, stringAsFactors=FALSE)
frame04 <- readHTMLTable(parse04, which=1, stringAsFactors=FALSE)
frame05 <- readHTMLTable(parse05, which=1, stringAsFactors=FALSE)
frame06 <- readHTMLTable(parse06, which=1, stringAsFactors=FALSE)
frame07 <- readHTMLTable(parse07, which=1, stringAsFactors=FALSE)
frame08 <- readHTMLTable(parse08, which=1, stringAsFactors=FALSE)
frame09 <- readHTMLTable(parse09, which=1, stringAsFactors=FALSE)
frame10 <- readHTMLTable(parse10, which=1, stringAsFactors=FALSE)
frame11 <- readHTMLTable(parse11, which=1, stringAsFactors=FALSE)
frame12 <- readHTMLTable(parse12, which=1, stringAsFactors=FALSE)

gitab <- rbind(frame01,frame02,frame03,frame04,frame05,frame06,frame07,frame08,frame09,frame10,frame11,frame12)
rm(parse01,parse02,parse03,parse04, parse05, parse06,parse07,parse08,parse09,parse10,parse11,parse12)
rm(frame01,frame02,frame03,frame04,frame05,frame06,frame07,frame08,frame09,frame10,frame11,frame12)

names(gitab) <- c("Date", "HiLo", "Precip", "Snow", "Forecast", "AvgHiLo") 
class(gitab)
##reformat the data
gitab$Date <- chartr(" ",",",gitab$Date)
gitab$Date <- sub(".*,","",gitab$Date)
gitab$Date <- paste(gitab$Date,"/2017")
gitab$Date <- as.Date(gsub(" ","",gitab$Date), "%m/%d/%Y")

gitab$Precip  <- as.numeric(gsub(" in","",gitab$Precip))
gitab$Snow  <- as.numeric(gsub(" in","",gitab$Snow))

gitab$HiLo <- chartr("/",",",gitab$HiLo)
gitab$TMaxGI <- sub(",.*","",gitab$HiLo)
gitab$TMinGI  <- sub(".*,","",gitab$HiLo)
gitab$HiLo <- NULL

gitab$TMaxGI <- as.numeric(gsub("°","",gitab$TMaxGI))
gitab$TMinGI  <- as.numeric(gsub("°","",gitab$TMinGI))

gitab$AvgHiLo <- chartr("/",",",gitab$AvgHiLo)
gitab$AvgHigh <- sub(",.*","",gitab$AvgHiLo)
gitab$AvgLow  <- sub(".*,","",gitab$AvgHiLo)
gitab$AvgHiLo <- NULL

gitab$AvgHigh <- as.numeric(gsub("°","",gitab$AvgHigh))
gitab$AvgLow  <- as.numeric(gsub("°","",gitab$AvgLow))

write.csv(gitab, "2017GIWeather_forecast.csv", row.names=FALSE)

gitab$Forecast <- NULL

write.csv(gitab, "2017GIWeather.csv", row.names=FALSE)

write.xlsx(gitab, "2017GIWeather.xlsx", row.names=FALSE)


# gitab2$High <- str_split(gitab2$HiLo,"/")
# 
# gitab2$High <- chartr("°"," ",gitab2$High)
# gitab2$Low <- as.numeric(gitab2$High[-c(,(ncol(gitab2$High)-1):ncol(gitab2$High))],double())
# 
# str_length(gitab2[1,2])
# 
# 
# gitab2[2]
# test1 <- str_length(gitab2[2,1])
# test1
# 
# write.csv(gitab2, "0617GIWeather.csv", row.names=FALSE)
# 
# 
# webpage2 <- scrape("http://www.accuweather.com/en/us/grand-island-ne/68801/june-weather/329504?monyr=6/1/2017&view=table")
# 
# gitab <- readHTMLTable(webpage2[[1]], which=1, stringsAsFactors=FALSE)
# 
# gitab <- tab[-c((nrow(tab)-3):nrow(tab)),]
# names(gitab2) <- c("Date", "HiLo", "Precip", "Snow", "Forecast", "AvgHiLo")
# 
# gitab$Date <- date-ddays((day(date)-as.numeric(tab$Day)))
# ##gitab$DateTime <- ymd_hm(paste(tab$Date, tab$Time, sep=" "))
