library(wordcloud)
library(RColorBrewer)
library(wordcloud2)
library(tm)
library(dplyr)

#read csv constructed during web scraping
df = read.csv(file = './full_df.csv')

#Create a vector containing only the text
text <- df$job_description

# Create a corpus  
docs <- Corpus(VectorSource(text))
#cleaning
docs <- docs %>%
  tm_map(removeNumbers) %>%
  tm_map(removePunctuation) %>%
  tm_map(stripWhitespace)
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removeWords, c("will", "work","can","know","well","make","job","good","things","first","keep","youre","ugentec")) 

#basic word stem
docs <- tm_map(docs, stemDocument)

#document term
dtm <- TermDocumentMatrix(docs) 
matrix <- as.matrix(dtm) 
words <- sort(rowSums(matrix),decreasing=TRUE) 
df <- data.frame(word = names(words),freq=words)


wordcloud2(data=df, size=1.6, color='random-dark')


# Find associations for words that occur at least 50 times
head(findAssocs(dtm, terms = findFreqTerms(dtm, lowfreq = 50), corlimit = 0.5), 5)

filter(df, df$word == "action")
filter(df, df$word == "leader")
