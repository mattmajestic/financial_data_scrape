### Module for SP ###

spUi <- function(id, label = "Counter") {
  ns <- NS(id)
  tagList(
    box(title ="Yahoo Finance Stock Data",status = "warning",solidHeader = TRUE,width = 6,
        selectInput(ns("sp"),label = "Select Stock",choices = sp$Tickers,selected = "SBUX"),
        br(),
        plotlyOutput(ns("SP500_line")),
        textOutput(ns("company")))
  )
}


spServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
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
      observeEvent(input$sp,{
        output$company <- renderText({input$sp})
      })
    }
  )
}








