library(rvest)
library(dplyr)
link<-"https://www.imdb.com/search/title/?groups=top_250&sort=user_rating"
web<-read_html(link)
Name<-web %>% html_nodes(".lister-item-header a")%>%html_text()
year<-web %>% html_nodes(".text-muted.unbold")%>%html_text()
View(year)
rating<-web%>%html_nodes(".ratings-imdb-rating strong")%>%html_text()
View(rating)
duration<-web%>%html_nodes(".runtime")%>%html_text()
View(duration)
imdb.ratings<-data.frame(Name,year,rating,duration)
View(imdb.ratings)
write.csv(imdb.ratings,"My_movie data.csv")
#1. Check for special characters
imdb.ratings$year <-gsub("[()]", "", imdb.ratings$year)
View(imdb.ratings)
imdb.ratings$duration <-gsub("min","",imdb.ratings$duration)
View(imdb.ratings)
#2. Check whether all the variables are having right datatype or not
str(imdb.ratings)
imdb.ratings$Name<-as.character(imdb.ratings$Name)
imdb.ratings$duration<-as.numeric(imdb.ratings$duration)
imdb.ratings$rating<-as.numeric(as.character(imdb.ratings$rating))
imdb.ratings$year<-as.numeric(imdb.ratings$year)
View(imdb.ratings)
str(imdb.ratings)
#3. Dealing with Missing values
set.seed(124)
imdb.ratings$Gross<-runif(50,min = 10000000,max=1000000000)
imdb.ratings$Gross_dollars<-runif(50,min = 10000000,max=1000000000)
View(imdb.ratings)
#Oops remove the extra column
imdb.ratings<-subset(imdb.ratings,select = -(Gross))
View(imdb.ratings)
imdb.ratings$rank<-c(1:50)
View(imdb.ratings)
imdb.ratings<-imdb.ratings[c("rank","Name","year","rating","duration","Gross_dollars")]
View(imdb.ratings)
#Lets create some missing values
#imdb.ratings$Gross_dollars<-NULL
View(imdb.ratings)
#imdb.ratings<-imdb.ratings[1,6]<-NA
View(imdb.ratings)
imdb.ratings[1,6]<-NA
imdb.ratings[18,6]<-NA
imdb.ratings[36,6]<-NA
imdb.ratings[45,6]<-NA
View(imdb.ratings)
#Let's replace the missing values
imdb.ratings$Gross_dollars=ifelse(is.na(imdb.ratings$Gross_dollars),
                                  ave(imdb.ratings$Gross_dollars,FUN=function(x) mean(x,na.rm=TRUE)),
                                  imdb.ratings$Gross_dollars)
View(imdb.ratings)
imdb.ratings$Watch_list<-imdb.ratings$rating>8.6
View(imdb.ratings)
str(imdb.ratings)
imdb.ratings$Watch_list=as.factor(imdb.ratings$Watch_list)
# Lets deal with categorical data
imdb.ratings$Watch_list=factor(imdb.ratings$Watch_list,
                               levels = c('TRUE','FALSE'),
                               labels = c(1,0))
View(imdb.ratings)
# Sorting data
imdb.ratings_Asc<-imdb.ratings[order(imdb.ratings$duration),]
View(imdb.ratings_Asc)
#Training set and testing set
library(caTools)
split=sample.split(imdb.ratings$Gross_dollars,SplitRatio = 0.8)
training_set=subset(imdb.ratings,split==TRUE)
testing_set=subset(imdb.ratings,split==FALSE)
View(training_set)
View(testing_set)
# Feature scaling/Normalization
training_set$scaled_gross=scale(training_set[,6])
View(training_set)
testing_set$scaled_gross<-scale(testing_set[,6])
View(testing_set)
write.csv()
