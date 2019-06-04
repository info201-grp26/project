source("process-data.R")
library("shiny")

server <- function(input, output) {
  output$hourlyAreaTable <- renderDataTable(
    get_highest_area_hourly(10, input$Area)
  )
  output$hourlyWagesTable <- renderDataTable(
    get_highest_hourly(10, input$Area)
  )
}
