
source("global.R")

## Build a little app looking at the T Rowe Price API ##
ui <- fluidPage(
  useShinydashboard(),
  fluidRow(
           box(title ="T Rowe Price Data",status = "success",solidHeader = TRUE,width = 6,
  radioButtons("t_rowe_type",label = "Select Data Type",choices = t_rowe_price_tabs,inline = TRUE),
  br(),
  DTOutput("t_rowe_dt")),
  box(title ="Yahoo Finance Stock Data",status = "warning",solidHeader = TRUE,width = 6,
selectInput("sp",label = "Select Stock",choices = sp$Tickers,selected = "SBUX"),
br(),
         plotlyOutput("SP500_line"))
  ),
  br(),
  br(),
  fluidRow(column(12,
                  box(title ="BlackRock Data",status = "primary",solidHeader = TRUE,width = 6,
                      br(),
                  DTOutput("blackrock_dt")),
                  box(title = "Agriculture Data",status = "danger",solidHeader = TRUE,width = 6,
                      br(),
                  DTOutput("agriculture_dt"))))
           )

server <- function(input,output,session){
  output$blackrock_dt <- renderDT({
    datatable(blackrock_df,rownames = FALSE,caption = "Source: Fintel",
              options = list(scrollX =TRUE))
  })
  
  output$t_rowe_dt <- renderDT({
    datatable(t_rowe_price_data[[input$t_rowe_type]],rownames = FALSE,caption = "Source: T Rowe Price",
              options = list(scrollX =TRUE))
  })
  
  output$agriculture_dt <- renderDT({
    datatable(agriculture_df %>%,rownames = FALSE,caption = "Source: Fintel Industry Level",
              options = list(scrollX =TRUE))
  })
  
  output$SP500_line <- renderPlotly({
    sp_list <- BatchGetSymbols(tickers = as.character(input$sp),
                               first.date = first.date,
                               last.date = Sys.Date(),
                               do.cache=TRUE)
    ticker_df <- sp_list$df.tickers %>% 
      dplyr::filter(ticker == input$sp) %>% 
       dplyr::mutate(DailyAVG = (price.high + price.low)/2)
    
    plot_ly(ticker_df,x=~ref.date,y=~price.close,type = "scatter",mode = "lines",name = "Closing Price") %>%
      add_trace(y =~DailyAVG,name = "High/LowAVG")
  })
}

shinyApp(ui,server)

