library(rvest)

airport <- 'MLN'
year <-2016
month<-02
day <-01


url.weather <- paste0("https://www.wunderground.com/history/airport/",airport,"/",year,"/",month,"/",day,"/DailyHistory.html?MR=1")
tmp <- read_html(url.weather)
tmp <- html_nodes(tmp, "table")
sapply(tmp, class)
weather <- html_table(tmp[[5]])
path<-paste0('../Desktop/',airport,year,month,day,'.csv')
write.csv(weather,path)
