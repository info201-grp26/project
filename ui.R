library(plotly)
library(shiny)
library(shinythemes)

source("process-data.R")

ui <- fluidPage(
  theme = shinytheme("yeti"),
  navbarPage(
    "Occupations in Washington State",
    tabPanel("Overview",
             mainPanel(
               h3(class = "title", "Overview"),
               p("Our group is working with data that estimates occupational employment and wages in Washington State in 2018. The data records the occupation title along with the mean hourly and yearly wages, as well as 25th, 50th and 75th percentile hourly wages. The data was collected from a survey of 4,800 state employers, collecting information on over 800 occupations with a total sample size of 29,300 employees."),
               p("The data includes employment and wage figures for different regions as well as Washington as a whole. "),
               h3(class = "title", "Questions"),
               p(tags$ol(
                 tags$li("Which area in Washington has the highest average hourly income?"),
                 tags$li("Which occupations have the highest average hourly incomes?"),
                 tags$li("Which occupation is most popular in each region?"),
                 tags$li("Which area have the most variability in hourly incomes?"),
                 tags$li("Do metropolitan areas have higher wages than non-metropolitan areas?")
               )
               )
             )
    ),
    
    tabPanel(
      "Hourly Income by Area",
      h3(class = "title", "Which area in Washington has the highest average hourly income?"),
      sidebarLayout(
        sidebarPanel(
          selectInput(
            inputId = "Area",
            label = "Area",
            selected = "All",
            choices = as.vector(areas)
          )
        ),
        mainPanel(
          h4('Description'),
          p(""),
          numericInput(
            inputId = "hourlyAreaN", 
            label = "Top N", 
            value = 10,
            min = 1, 
            max = 50, 
            step = 2), 
          tableOutput("hourlyAreaTable")
        )
      )
    ),
    tabPanel(
      "Occupations",
      h3(class = "title", "Which occupations have the highest average hourly incomes?"),
        mainPanel(
          h4('Description'),
          p(""),
          numericInput(
            inputId = "hourlyN", 
            label = "Top N", 
            value = 10,
            min = 1, 
            max = 50, 
            step = 2), 
          tableOutput("hourlyWagesTable")
        )
    ),
    tabPanel(
      "Hourly Income",
      h3(class = "title", "Which area in Washington has the highest average hourly income?"),
      sidebarLayout(
        sidebarPanel(
          
        ),
        mainPanel(
          h4('Description'),
          p("")
        )
      )
    ),
    tabPanel(
      "Region",
      h3(class = "title", "Which area have the most variability in hourly incomes?"),
      sidebarLayout(
        sidebarPanel(
          
        ),
        mainPanel(
          h4('Description'),
          p("")
        )
      )
    ),
    tabPanel(
      "",
      h3(class = "title", "Do metropolitan areas have higher wages than non-metropolitan areas?"),
      sidebarLayout(
        sidebarPanel(
          
        ),
        mainPanel(
          h4('Description'),
          p("")
        )
      )
    )
  )
)

shinyUI(ui)