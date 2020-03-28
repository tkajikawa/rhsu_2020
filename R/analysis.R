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

# Load cleaned data from prep.R
rhsu_2020_df <- read.csv("data/final_data.txt",
                         header = TRUE,
                         colClasses = 'character',
                         sep = '\t',
                         fileEncoding="UTF-8")
rhsu_2020_df <- rhsu_2020_df %>%
  mutate_at(vars(snippet), function(x){gsub('[^ -~]', '', x)})

## Bar chart for popular websites

popular_websites <- rhsu_2020_df %>% group_by(displayLink) %>% tally()
colnames(popular_websites) <- c("displayLink", "count")
popular_websites <- arrange(popular_websites, desc(count))[1:10,]
# Plot using ggplot2

ggplot(popular_websites, aes(y=count,x=reorder(displayLink, count))) +
  geom_bar(stat="identity", color="black", fill="white") +
  coord_flip() +
  ggtitle("Most Popular Websites")+
  labs(y="Count", x = "displayLink")

## Frequent words in Snippet
# https://towardsdatascience.com/a-light-introduction-to-text-analysis-in-r-ea291a9865a8
attach(rhsu_2020_df)
library(tidytext)
library(dplyr)
library(tm)
library(syuzhet)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
dfCorpus <- SimpleCorpus(VectorSource(rhsu_2020_df$snippet))

# 1. Stripping any extra white space:
dfCorpus <- tm_map(dfCorpus, stripWhitespace)
# 2. Transforming everything to lowercase
dfCorpus <- tm_map(dfCorpus, content_transformer(tolower))
# 3. Removing numbers 
dfCorpus <- tm_map(dfCorpus, removeNumbers)
# 4. Removing punctuation
dfCorpus <- tm_map(dfCorpus, removePunctuation)
# 5. Removing stop words
dfCorpus <- tm_map(dfCorpus, removeWords, stopwords("english"))
# 6. Now let's stem our data
# dfCorpus <- tm_map(dfCorpus, stemDocument)

# Now convert to DTM
DTM <- DocumentTermMatrix(dfCorpus)

# Now leverage our DTM for data visualization
sums <- as.data.frame(colSums(as.matrix(DTM)))
sums <- rownames_to_column(sums) 
colnames(sums) <- c("Term", "Freq")
sums <- arrange(sums, desc(Freq))
head <- sums[1:20,]

## Now plot for popular words
ggplot(head, aes(y=Freq,x=reorder(Term, Freq))) +
  geom_bar(stat="identity", color="black", fill="white") +
  coord_flip() +
  ggtitle("Most Popular Snippet Words")+
  labs(y="Count", x = "Term")

# Now let's pipe in the snippet data for sentiment analysis
library(syuzhet)
rhsu_2020_df$snippet_sentiment<-get_nrc_sentiment(rhsu_2020_df$snippet)

# Data visualization
barplot(
  sort(colSums(prop.table(rhsu_2020_df$snippet_sentiment[, 1:8]))), 
  horiz = TRUE, 
  cex.names = 0.7, 
  las = 1, 
  main = "Emotions in Snippet Text", xlab="Percentage"
)

barplot(
  sort(colSums(prop.table(rhsu_2020_df$snippet_sentiment[, 9:10]))), 
  horiz = TRUE, 
  cex.names = 0.7, 
  las = 1, 
  main = "Connotation in Snippet Text", xlab="Percentage"
)

# SKIP WORD CLOUD FOR NOW
# wordcloud(words = head$term, freq = head$Freq, min.freq = 1,
#           max.words=75, random.order=FALSE, rot.per=0.25,
#           colors=brewer.pal(6, "Dark2"))

# Let's try some sentiment analysis
# library(sentimentr)
# rhsu_2020_df$sentiment <- sentiment_by(rhsu_2020_df$snippet)
# 
# summary(rhsu_2020_df$sentiment$ave_sentiment)
# 
# # Historgram of sentiment
# qplot(rhsu_2020_df$sentiment$ave_sentiment,
#       geom="histogram",
#       binwidth=0.01,
#       main="Snippet Sentiment Histogram")

