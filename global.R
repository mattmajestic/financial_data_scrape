### Loading various libraries ###
## These are packages (pre compiled code) we will need to start working on getting, manipulating, and viz data ##

library(httr)
library(XML)
library(dplyr)
library(jsonlite)
library(magrittr)
library(xml2)
library(rvest)
library(DT)
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(BatchGetSymbols)
library(plotly)

## T Rowe Price Address to perform API request ##
t_rowe_base_url <- "https://www3.troweprice.com/fb2/ppfweb/dailyPrices.do?cat="
## T Rowe Price Metrics to query ##
t_rowe_price_tabs <- c("MM","DOMSTOCK","INTSTOCK","TXBOND","TXFRBOND")

## Create a chararacter with each word being the specific address ##
## Create an empty chacter vector to store values of for loop ##
t_rowe_price_urls <- as.character()

## Run the for loop ##
for(tab in 1:length(t_rowe_price_tabs)){
  t_rowe_price_urls <- c(t_rowe_price_urls,paste0(t_rowe_base_url,t_rowe_price_tabs[tab]))
}

## From this loop you can see the output below:
# [1] "https://www3.troweprice.com/fb2/ppfweb/dailyPrices.do?cat=MM"      
# [2] "https://www3.troweprice.com/fb2/ppfweb/dailyPrices.do?cat=DOMSTOCK"
# [3] "https://www3.troweprice.com/fb2/ppfweb/dailyPrices.do?cat=INTSTOCK"
# [4] "https://www3.troweprice.com/fb2/ppfweb/dailyPrices.do?cat=TXBOND"  
# [5] "https://www3.troweprice.com/fb2/ppfweb/dailyPrices.do?cat=TXFRBOND"

## Notice it is just combining line 19 and 21 content ##

## Create an empty list to store data sets from T Rowe Price Website ##
t_rowe_price_data <- list()

## Run the for loop ##
for(t_rowe_tab in 1:length(t_rowe_price_tabs)){
  t_rowe_html_table <- read_html(t_rowe_price_urls[t_rowe_tab], as.data.frame=T, stringsAsFactors = TRUE)
  x <- t_rowe_html_table %>%  
    html_nodes("table") %>% 
    .[[2]] %>% 
    html_table(fill=T)
  t_rowe_price_data[[t_rowe_price_tabs[t_rowe_tab]]] <- x
  rm(x)
  rm(t_rowe_html_table)
}

# blackrock_url <- "https://fintel.io/iind/blackrock"
# 
# blackrock_html_table <- read_html(blackrock_url, as.data.frame=T, stringsAsFactors = TRUE)
# blackrock_x <- blackrock_html_table %>%  
#   html_nodes("table") %>% 
#   .[[2]] %>%
#   html_table(fill=T)
# blackrock_df <- blackrock_x
# write.csv(blackrock_df,"data/blackrock_df.csv")

blackrock_df <- read.csv("data/blackrock_df.csv")

# agg_url <- "https://fintel.io/industry/investment/agriculture-production-livestock-and-animal-specialties"
# 
# agg_html_table <- read_html(agg_url, as.data.frame=T, stringsAsFactors = TRUE)
# agg_x <- agg_html_table %>%
#   html_nodes("table") %>%
#   .[[1]] %>%
#   html_table(fill=T)
# agriculture_df <- agg_x
# write.csv(agriculture_df,"data/agriculture_df.csv")

agriculture_df <- read.csv("data/agriculture_df.csv")

first.date <- Sys.Date()-2000
sp <- GetSP500Stocks()
