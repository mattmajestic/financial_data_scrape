server <- function(input,output,session){
  fintelServer("fintel_test")
  t_roweServer("counter_test")
  spServer("sp_test")
}