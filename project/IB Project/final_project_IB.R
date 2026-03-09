
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


lapply(c("tidyverse", "ggplot2","scales"),  pkgTest)


# Set working directory for current folder
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

#make a theme?

mytheme <- theme_minimal(base_family = "Courier") +
  theme(legend.position = "bottom",
        plot.title = element_text(size = 18, face = "bold", color = "#333333", margin = margin(b = 10)),
        axis.title.x = element_text(color = "#333333", margin = margin(t = 15)),
        axis.title.y = element_text(color = "#333333", margin = margin(r = 15)),
        strip.text = element_text(family = "Courier", face = "bold",
                                  size = rel(1.3)))


#data upload and cleaning

data_raw <- read_csv("MTA_Metro-North_Delays__Beginning_2012.csv")

data_raw <- select(data_raw,`Service Date`,Branch,Status,`Minutes Late`,`Delay Category`)

#check for NA
sum(is.na(data_raw))
#good lord 7591 NA
#further inspection reveals this is for  cancellations etc., which obviously do not have a "minutes late" amount

#just the ones without NA so it doesn't have to be manually dropped by the GGPlot function
clean_data <- data_raw[complete.cases(data_raw), ]

# Individual figures

## Figure 1: 

#set up averages
late_data <- clean_data |>
  group_by(`Delay Category`) |>
  summarize(avg = mean(`Minutes Late`))

pdf("Average Delay.pdf")
ggplot(late_data, aes(x = `avg`, y = `Delay Category`)) +
  geom_bar(stat="identity") +
  mytheme +
  labs(title = "Causes and Delay Time",
    x="Average Minutes Late",
    y = "Delay Cause")
dev.off()

## Figure 2: Late over Time
time_data <- clean_data |>
  mutate(date = as.Date(clean_data$`Service Date`, format="%m/%d/%Y")) 

pdf("Minutes Late Over Time.pdf")
ggplot(time_data, aes(x = date, y = `Minutes Late`,)) +
  geom_line() +
  geom_smooth(method='lm') +
  mytheme +
  labs(title = "Minutes Late over Time",
       x= "Year")
dev.off()

## Figure 3: Status by Month
count_data <- data_raw |>
  mutate(Month = format(as.Date(data_raw$`Service Date`,format="%m/%d/%Y"),"%m")) |>
  count(Status,Month)


pdf("status_by_month.pdf")
ggplot(count_data, aes(x = Month, y= n, fill = Status)) +
  geom_bar(stat="identity") +
  mytheme +
  labs(title = "Status Changes by Month",
       x= "Month",
       y = "Number of Status Changes") +
  scale_fill_manual(values=c("#9933FF",
                             "darkred",
                             "pink",
                             "red"))

dev.off()


  