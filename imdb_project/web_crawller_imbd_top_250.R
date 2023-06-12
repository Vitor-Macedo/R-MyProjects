library(rvest)
library(tidyverse)
library(httr)
url_imbd <- 'https://www.imdb.com/chart/top/'
webpage <- read_html(url_imbd)
links <- webpage%>%
  html_elements(xpath = '//table//tr/td[@class="titleColumn"]/a')%>%
  html_attr('href')
df_final <- matrix(NA,nrow = length(links),ncol = 10)
for (i in 1:length(links)) {
  cat("\f","Filme: ",i)
  webpage_aux1 <- read_html(paste0('https://www.imdb.com/',links[i]))
  titulo <- webpage_aux1%>%
    html_elements(xpath = '//*[@id="__next"]/main/div/section[1]/section/div[3]/section/section/div[2]/div[1]/h1/span')%>%
    html_text()
  titulo_original <- webpage_aux1%>%
    html_elements(xpath = '//*[@id="__next"]/main/div/section[1]/section/div[3]/section/section/div[2]/div[1]/div')%>%
    html_text()
  titulo_original <- ifelse(length(titulo_original)==1,titulo_original,titulo)
  ano <- webpage_aux1%>%
    html_elements(xpath = '//*[@id="__next"]/main/div/section[1]/section/div[3]/section/section/div[2]/div[1]/ul/li[1]/a')%>%
    html_text()
  classi <- webpage_aux1%>%
    html_elements(xpath = '//*[@id="__next"]/main/div/section[1]/section/div[3]/section/section/div[2]/div[1]/ul/li[2]/a')%>%
    html_text()
  duracao <- webpage_aux1%>%
    html_elements(xpath = '//*[@id="__next"]/main/div/section[1]/section/div[3]/section/section/div[2]/div[1]/ul/li[3]/text()')%>%
    html_text()
  enredo <- webpage_aux1%>%
    html_elements(xpath = '//*[@id="__next"]/main/div/section[1]/section/div[3]/section/section/div[3]/div[2]/div[1]/section/p/span[3]/text()')%>%
    html_text()
  rating <- webpage_aux1%>%
    html_elements(xpath = '//*[@id="__next"]/main/div/section[1]/section/div[3]/section/section/div[2]/div[2]/div/div[1]/a/span/div/div[2]/div[1]/span[1]')%>%
    html_text()
  diretor <- webpage_aux1%>%
    html_elements(xpath = '//*[@id="__next"]/main/div/section[1]/section/div[3]/section/section/div[3]/div[2]/div[1]/section/div[2]/div/ul/li[1]/div/ul//li/a/text()')%>%
    html_text()%>%paste(collapse = '/')
  roterista <- webpage_aux1%>%
    html_elements(xpath = '//*[@id="__next"]/main/div/section[1]/section/div[3]/section/section/div[3]/div[2]/div[1]/section/div[2]/div/ul/li[2]/div/ul//li/a/text()')%>%
    html_text()%>%paste(collapse = '/')
  link_poster <- webpage_aux1%>%
    html_element(xpath = '//*[@id="__next"]/main/div/section[1]/section/div[3]/section/section/div[3]/div[1]/div[1]/div/a')%>%
    html_attr('href')
  webpage_aux2 <- read_html(paste0('https://www.imdb.com/',link_poster))
  poster <- webpage_aux2%>%
    html_element(xpath = '//*[@id="__next"]/main/div[2]/div[3]/div[4]/img')%>%
    html_attr('src')
  df_final[i,] <- c(titulo,titulo_original,ano,classi,duracao,enredo,rating,diretor,roterista,poster)
}
df_final <- df_final%>%as.data.frame()
names(df_final) <- c('titulo','titulo original','ano','classificacao','duracao','enredo','nota','diretor','roteristas','poster')
write.csv(df_final,file = "dados.csv")
