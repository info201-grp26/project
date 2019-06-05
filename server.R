source("process-data.R")
pkgCheck(c("shiny"))

server <- function(input, output) {
  # Overview
  output$areaPlot <- renderPlot(
    regionPlot(areas_fips) 
    #drawMap(areas_fips, "right")
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

  output$hourlyNText <- renderText(
    paste0("Top ", input$hourlyN,  " average hourly wages in Washington")
  )
  
  # Hourly Wage
  output$topNPlot <- renderPlot(
    topWAplot(get_hourly(input$hourlyN))
   )

  output$countyMap1 <- renderPlot(
     drawMap(areas_fips[areas_fips$Area.name == input$Area,], input$Area, "")
   )

  # Occupations
  output$mostEmployedTable <- renderTable(
    most_employed
  )
  
  output$mostEmployedPlot <- renderPlot(
    employmentPlot(most_employed)
  )

  output$mostEmployedWATable <- renderTable(
    get_employed_WA(input$mostEmployedWASlider)
  )
  
  # Occupation and Area Lookup
  output$occupationAreaLookup <- renderText(
    paste(paste0("The Averge Hourly Wage for ", input$Occupation, " in ", input$Area2, " is $", get_area_occupation_data(input$Area2, input$Occupation)$Average.wage),
                 paste0("The Annual Wage is $", get_area_occupation_data(input$Area2, input$Occupation)$Annual.wage), sep = "\n")
  )
  
  output$countyMap2 <- renderPlot(
    drawMap(areas_fips[areas_fips$Area.name == input$Area2,], input$Area2, "")
  )

  
}
