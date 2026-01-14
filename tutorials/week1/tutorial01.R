# Data Viz  
# Tutorial 1: Tidyverse and ggplot        

# Remove objects
rm(list=ls())

# Detach all libraries
detachAllPackages <- function() {
    basic.packages <- c("package:stats", "package:graphics", "package:grDevices", "package:utils", "package:datasets", "package:methods", "package:base")
    package.list <- search()[ifelse(unlist(gregexpr("package:", search()))==1, TRUE, FALSE)]
    package.list <- setdiff(package.list, basic.packages)
    if (length(package.list)>0)  for (package in package.list) detach(package,  character.only=TRUE)
    }
detachAllPackages()

# Load libraries
pkgTest <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[,  "Package"])]
    if (length(new.pkg)) 
        install.packages(new.pkg,  dependencies = TRUE)
    sapply(pkg,  require,  character.only = TRUE)
    }

# Load any necessary packages
lapply(c("tidyverse", "ggplot2"),  pkgTest)

# Set working directory for current folder
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

# Agenda
# (1) Organize data yourself in groups using tidy
# (2) Create informative plots of example RQs
# (3) Start to add basic elements using ggplot

# Research questions: 
# What is the relationship between social demographic characteristics (education, employment, age, gender) & informal politics (official political parties vs traditional leaders)?

# download data from AfroBarometer (Zimbabwe R10): https://www.afrobarometer.org/survey-resource/zimbabwe-round-10-data-2024/
# here is the codebook: https://www.afrobarometer.org/survey-resource/zimbabwe-round-10-codebook-2024/
AB_ZIM <- read.csv()
View(df)

# reduce your data to these variables: 
# URBRUR - urban/rural respondent
# Q1 - age 
# Q101 - gender
# Q102 - interview language
# Q94A - employed
# Q97 - religion
# Q98 - voted for party in last election
# Q12B - contacted party official
# Q12C - contacted traditional leader

# rename your variables to informative/easy names

# create a couple of visualizations that shed light on our RQ

# (we will present your "findings" to the class)
