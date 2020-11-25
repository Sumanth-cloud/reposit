DATA ACQUISITION IN R

library(robotstxt)
path<-paths_allowed("https://www.imdb.com/search/title/?groups=top_250&sort=user_rating")        
library(rvest)
library(dplyr)
link<-"https://www.imdb.com/search/title/?groups=top_250&sort=user_rating"
read<-read_html(link)
movie_name<-read%>%html_nodes(".lister-item-header a")%>%html_text()
View(movie_name)
movie_rating<-read%>%html_nodes(".ratings-imdb-rating strong")%>%html_text()
View(movie_rating)
movie_year<-read%>%html_nodes(".text-muted.unbold")%>%html_text()
View(movie_year)
movie_duration<-read%>%html_nodes(".runtime")%>%html_text()
View(movie_duration)
imdb.ratings<-data.frame(movie_name,movie_rating,movie_year,movie_duration)
View(imdb.ratings)
write.csv(imdb.ratings,"imdb.csv")
