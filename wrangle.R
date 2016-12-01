library(dplyr)
library(readr)
library(tidyr)

#Set WD to the Local Github Repo
setwd("~/Documents/Github/twitter-project")

#Load and Subset Data
tweets <- read.csv("tweets.csv")
tweets <- tweets[, c(2, 6)]

#Use Regular expressions to split up fields

cleanSBTweets <- function(twitter){
  
  twitter <- twitter %>% separate(text, into = c("street", "other"), sep = "[\\,]", extra = "merge")
  twitter <- twitter %>% separate('other', c("city", "emergency"), sep = "[\\*]", extra = "merge")
  twitter <- twitter  %>% separate('emergency', c("emergency", "other"), sep = "[\\*]", extra = "merge")
  twitter <- twitter %>% separate('created', c("date", "time"), sep = 11, extra = "merge")
  twitter <- twitter %>% separate('time', c("hour", "minute"), sep = 2, extra = "merge")
  twitter$day <- as.Date(twitter$date) %>% weekdays()
  twitter <- data.frame("city" = twitter$city, 
                       "day" = twitter$day, 
                       "hour" =twitter$hour, 
                       "emergency" = twitter$emergency)
  
  return(twitter)
}


tweets <- cleanSBTweets(tweets)

#Delete Rows with NA's or missing values

tweets <- tweets[complete.cases(tweets),]

#Reindex the rows
rownames(tweets) <- 1:nrow(tweets)

#Remove nonstandard tweets
badRows <- c(576, 1791, 2568, 1523, 1847)
tweets <- tweets[-badRows,]

#Remove Rows where medical emergency, city occurs fewer than 15 times
tweets <- tweets[tweets$emergency %in% names(table(tweets$emergency))[table(tweets$emergency) > 15],]
tweets <- tweets[tweets$city %in% names(table(tweets$city))[table(tweets$city) > 15],]

#Make columns factor
for (i in 1:ncol(tweets)){
  tweets[i] <- factor(tweets[[i]])
}


