### T Rowe Price API Data ###

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
# library(shinyParallel)

t_rowe_base_url <- "https://www3.troweprice.com/fb2/ppfweb/dailyPrices.do?cat="
t_rowe_price_tabs <- c("MM","DOMSTOCK","INTSTOCK","TXBOND","TXFRBOND")

t_rowe_price_urls <- as.character()
for(tab in 1:length(t_rowe_price_tabs)){
  t_rowe_price_urls <- c(t_rowe_price_urls,paste0(t_rowe_base_url,t_rowe_price_tabs[tab]))
}

t_rowe_price_data <- list()

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
