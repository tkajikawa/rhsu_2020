#----------------------------------------------#
#---------------2020 RHSU Scholar--------------#
#----------------------------------------------#
# Written by Trent Kajikawa
rm(list=ls())

# Here is some sample code for R...
library(ggplot2)
library(tidyverse)
library(vtable)
library(rvest)

# - First, set your working directory
setwd("C://Users//tkajikaw//rhsu_2020//")

# Now let's get the data from RHess' aei site
# webpage <- read_html("https://www.edweek.org/media/2020/01/13/scholarrankings2020_revised.html")
# Easier for me to save as tab-delimited text
rhsu_2020_Raw <- read.csv("data/html_table.txt",
                       header = TRUE,
                       colClasses = 'character',
                       sep = '\t',
                       fileEncoding="UTF-8-BOM")

rhsu_2020_Raw$search_term <- paste(rhsu_2020_Raw$Name,rhsu_2020_Raw$Affiliation, sep = "+")
# Now export column
write.table(rhsu_2020_Raw$search_term,
           "data/search_terms.txt", sep = '\t',
           col.names = F, row.names = F,quote = F)

# For some reason, need to take text and save as xlsx to transfer
library(xlsx)
links <- read.xlsx("data/links.xlsx",
                   1,
                   header =TRUE)

# links <- read.csv("data/google_api/cleaned_google_api_data.txt",
#                           header = TRUE,
#                           colClasses = 'character',
#                           sep = '|',
#                           fileEncoding="ascii")

joined_data <- left_join(rhsu_2020_Raw, links)

attach(joined_data)
explore <- as.data.frame(table(displayLink))
write.table(joined_data,
            "data/final_data.txt", sep = '\t',
            col.names = T, row.names = F,quote = F,
            fileEncoding="UTF-8")
