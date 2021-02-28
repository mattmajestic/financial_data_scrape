## Build a little app looking at the T Rowe Price API ##
ui <- fluidPage(
  useShinydashboard(),
  fluidRow(
    t_roweUi("counter_test"),
    spUi("sp_test")
  ),
  br(),
  br(),
  fluidRow(column(12,fintelUi("fintel_test")))
)