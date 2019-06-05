source("process-data.R")
pkgCheck(c("shiny"))
# library("shiny")

server <- function(input, output) {
  # Overview
  output$areaPlot <- renderPlot(
    drawMap(areas_fips)
  )

  # Hourly Wage
  output$hourlyAreaTable <- renderTable(
    get_area_hourly(10, input$Area)
  )

  output$topHourlyText <- renderText(
    paste0("Top 10 average hourly wages for ", input$Area)
  )

  output$bottomHourlyText <- renderText(
    paste0("Bottom 10 average hourly wages for ", input$Area)
  )

  output$hourlyAreaTableBottom <- renderTable(
    get_area_hourly(-10, input$Area)
  )

  # Hourly Wage
  output$hourlyWagesTable <- renderTable(
    get_hourly(input$hourlyN)
  )

  # Hourly Wage
  output$topNPlot <- renderPlot(
     selectedMap(get_hourly(input$hourlyN))
   )

  output$countyMap1 <- renderPlot(
     drawMap(areas_fips[areas_fips$Area.name == input$Area,])
   )

  # Occupations
  output$mostEmployedTable <- renderTable(
    most_employed
  )

  output$mostEmployedWATable <- renderTable(
    get_employed_WA(10)
  )

  # Occupation and Area Lookup
  output$occupationAreaLookup <- renderTable(
    get_area_occupation_data(input$Area, input$Occupation)
  )

  output$countyMap2 <- renderPlot(
    drawMap(areas_fips[areas_fips$Area.name == input$Area2,])
  )
}
