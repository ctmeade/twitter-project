library(twitteR)
library(ROAuth)
library(httr)
library(plyr)

setwd("~/Documents/Github/twitter-project")

# Set API Keys
api_key <- "..."
api_secret <- "..."
access_token <- "..."
access_token_secret <- "..."
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

# Grab latest tweets
tweets_sbcf <- userTimeline('@sbcfiredispatch', n=3200)
tweets_sbcf <- twListToDF(tweets_sbcf)

write.csv(tweets_sbcf, file = "tweets.csv")
