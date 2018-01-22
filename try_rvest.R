installed.packages("rvest")

library("rvest")

## Clear the Console
cat("\014")
## Clear the data Environment
rm(list=ls())
setwd("C:/R_Projects")

dtab <- read_html("http://w1.weather.gov/data/obhistory/KGRI.html")

tab <- html_nodes(dtab, css = "table")

tab2 <- html_table(tab, fill = TRUE, header = FALSE)[[4]]

tab2 <- tab2[-c(1:3),] 
tab2 <- tab2[-c((nrow(tab2)-3):nrow(tab2)),] 
