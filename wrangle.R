library(dplyr)
library(readr)
library(tidyr)

#Set WD to the Local Github Repo
setwd("~/Documents/Github/twitter-project")

#Load and Subset Data
tweets <- read.csv("tweets.csv")
tweets <- tweets[, c(2, 6)]

#Use Regular expressions to split up fields
newdf <- separate(tweets, text, into = c("street", "other"), sep = "[\\,]", extra = "merge")

newerdf <- newdf %>% separate('other', c("city", "emergency"), sep = "[\\*]")

vehicle <- grepl("Vehicle", newerdf$emergency)

for (i in 1:length(vehicle)){
  if (indices[i] == TRUE){
    newerdf$emergency[i] <- "Vehicle"
  }
}


fire <- grepl("Fire", newerdf$emergency)

for (i in 1:length(fire)){
  if (fire[i] == TRUE){
    newerdf$emergency[i] <- "Fire"
  }
}

medical <- grepl("Medical", newerdf$emergency)

for (i in 1:length(medical)){
  if (medical[i] == TRUE){
    newerdf$emergency[i] <- "Medical"
  }
}