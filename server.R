source("process-data.R")
library("shiny")

server <- function(input, output) {
  output$hourlyAreaTable <- renderTable(
    get_highest_area_hourly(10, input$Area)
  )
  output$hourlyWagesTable <- renderTable(
    get_highest_hourly(input$hourlyN)
  )
  
  output$areaPlot <- renderPlot(
    drawMap(areas_fips)
  )
  
  output$topNPlot<- renderPlot(
    selectedMap(get_highest_hourly(input$hourlyN))
  )
}
