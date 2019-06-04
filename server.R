source("process-data.R")
library("shiny")

server <- function(input, output) {
  output$hourlyAreaTable <- renderTable(
    get_highest_area_hourly(input$hourlyAreaN, input$Area)
  )
  output$hourlyWagesTable <- renderTable(
    get_highest_hourly(input$hourlyN)
  )
}
