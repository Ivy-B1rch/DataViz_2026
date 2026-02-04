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

NCSS <- read.csv("NCSS_v1.csv")

NCSS <- NCSS |> select(CASEID, YEAR, GDREGION, NUMOFFMBR, TRAD6, TRAD12, INCOME)

NCSS_religion <- filter(NCSS,TRAD6 %in% c("Chrétiennes","Juives","Musulmanes"))

#count em up
count_summary <- NCSS_religion |>
  count(YEAR,TRAD6)
count_summary

#mean and median
mean_summary <- NCSS_religion |>
  group_by(YEAR,TRAD6) |>
  summarize(
    mean_income = mean(INCOME, na.rm = TRUE),
    median_income = median(INCOME, na.rm = TRUE),
    .groups = "drop"
  )
  
mean_summary

#i cannot figure out how to do part 4 
NCSS_religion <- NCSS_religion %>%
  mutate(AVG_INCOME = ifelse(INCOME <- mean_summary, "0", "1"))



porportions <- NCSS |>
  count(TRAD12,YEAR) |>
  group_by(YEAR) |>
  mutate(prop = n/sum(n))


pdf("Porpplot.pdf")
ggplot(data = porportions, aes(x=YEAR, y = prop, fill = TRAD12)) +
  geom_bar(stat="identity")  +
  labs(x = "\nYear", 
     y = "Porportion \n")
dev.off()


#i cant figure out why this isn't working- im getting an error that i require a 'continous x asthetic'

numbcount <- NCSS |>
  group_by(TRAD6) 


ggplot(data = numbcount, aes(x=NUMOFFMBR,fill=TRAD12)) +
  geom_histogram(position="dodge", binwidth =40 ) +
  facet_wrap(vars(YEAR))


#cant do part 3 due to not doing part 4 earlier



#part 4
pdf("GD.pdf")

ggplot(data= NCSS, aes(x=GDREGION,y=NUMOFFMBR,FILL=TRAD12)) +
  geom_boxplot() +
  labs(x = "\nRegion", 
       y = "Number of Members of a Religion \n")
dev.off()
