#source("process-data.R")
#pkgCheck(c("shiny"))

library(shiny)

server <- function(input, output) {
  # Overview
  output$areaPlot <- renderPlot(
    regionPlot(areas_fips) 
    #drawMap(areas_fips, "right")
  )
  
  area_occupations <- reactive({
    get_area_occupations(input$Area2)
  })
  
  occupation_data <- reactive({
    get_occupation_data(input$Occupation)
  })
  
  occupation_area_data <- reactive({
    get_area_occupation_data(input$Area2, input$Occupation)
  })

  output$areaOccupations <- renderUI(
    selectInput(
      inputId = "Occupation",
      label = "Occupation",
      choices = as.vector(area_occupations())
    )
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
    employmentPlot()
  )

  output$mostEmployedWATable <- renderTable(
    get_employed_WA(input$mostEmployedWASlider)
  )
  
  # Occupation and Area Lookup
  output$hourlyWage <- renderUI(
    h4(paste0("The Averge Hourly Wage for ", input$Occupation, " in ", input$Area2, " is $", occupation_area_data()$Average.wage))
  )
  
  output$annualWage <- renderUI(
    h4(paste0("The Annual Wage is $", occupation_area_data()$Annual.wage))
  )
  
  output$highestWageArea <- renderUI(
    h4(paste0(filter(occupation_data(), Average.wage == max(Average.wage)) %>% select(Area.name), 
              " has the highest Average hourly wage for ", input$Occupation, " of $", 
              filter(occupation_data(), Average.wage == max(Average.wage)) %>% select(Average.wage)))
  )
  
  output$occupationPlot <- renderPlot(
    occupationPlot(occupation_data())
  )
  
  output$countyMap2 <- renderPlot(
    drawMap(areas_fips[areas_fips$Area.name == input$Area2,], input$Area2, "")
  )
  
  output$variablePlot <- renderPlot(
    drawBox(get_state_occupation_data(input$Occupation2), input$wageInput)
  )
}
