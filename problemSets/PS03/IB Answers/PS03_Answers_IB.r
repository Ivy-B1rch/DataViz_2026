
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

ces2015 <- read.csv("https://raw.githubusercontent.com/ASDS-TCD/DataViz_2026/refs/heads/main/datasets/CES2015.csv")
ces2015 <- ces2015 |> filter(discard == "Good quality")


ces2015 <- ces2015 |> filter(p_voted == "Yes" | p_voted == "No")

ces2015 <- ces2015 |> mutate(as.numeric(p_voted))

ces2015$age <- as.numeric(as.character(ces2015$age))

ageconverter <- function(age){
  2015-age
}

ces2015["age_group"] <- ageconverter(ces2015$age)
ces2015["age_group"] = cut(ces2015$age_group, breaks=c(0,30, 45, 65,1000))



pdf("turnoutage.pdf")
#calculate turnout rate
turnout <- ces2015 |> 
  count(age_group, name = "turnout") 
     
ggplot(turnout,
              aes(x = age_group, y=turnout)) +
  geom_bar(stat="identity")
dev.off()


pdf("density.pdf")

density <- ces2015 |> 
  mutate(p_selfplace = as.numeric(p_selfplace)) |>
  filter(partyid == c("Liberal","Conservative","ndp","Bloc Quebecois","Green Party")) |>
  filter(p_selfplace <= 10 & p_selfplace >= 0)

ggplot(density, aes(x = p_selfplace, fill = partyid)) +
  geom_density(alpha = 0.5, color = NA, adjust = 1) +
  labs(x = "\nIdealogy, left to right leaning",
       y = "Density\n",
       fill = "Party")
dev.off()

ces2015$province

pdf("turnoutincome.pdf")
turnoutincome <- ces2015 |> 
  count(income_full,province,name = "turnout_no")

turnoutincome

ggplot(turnoutincome,
       aes(turnout_no,fill=income_full)) +
  geom_histogram()
  facet_wrap(vars(income_full))

dev.off()
