
fintelUi <- function(id, label = "Counter") {
  ns <- NS(id)
  tagList(
    box(title ="BlackRock Data",status = "primary",solidHeader = TRUE,width = 6,
        br(),
        DTOutput(ns("blackrock_dt"))),
    box(title = "Agriculture Data",status = "danger",solidHeader = TRUE,width = 6,
        br(),
        DTOutput(ns("agriculture_dt")))
  )
}

fintelServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      output$blackrock_dt <- renderDT({
        datatable(blackrock_df,rownames = FALSE,caption = "Source: Fintel",
                  options = list(scrollX =TRUE))
      })
      
      output$agriculture_dt <- renderDT({
        datatable(agriculture_df ,rownames = FALSE,caption = "Source: Fintel Industry Level",
                  options = list(scrollX =TRUE))
      })
    }
  )
}