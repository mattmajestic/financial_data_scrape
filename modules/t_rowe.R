### Module for T Rowe Price ###

t_roweUi <- function(id, label = "Counter") {
  ns <- NS(id)
  tagList(
    box(title ="T Rowe Price Data",status = "success",solidHeader = TRUE,width = 6,
        radioButtons(ns("t_rowe_type"),label = "Select Data Type",choices = t_rowe_price_tabs,inline = TRUE),
        br(),
        DTOutput(ns("t_rowe_dt")))
  )
}

t_roweServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      output$t_rowe_dt <- renderDT({
        datatable(t_rowe_price_data[[input$t_rowe_type]],rownames = FALSE,caption = "Source: T Rowe Price",
                  options = list(scrollX =TRUE))
      })
    }
  )
}