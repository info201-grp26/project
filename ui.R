library(plotly)
library(shiny)
library(shinythemes)

ui <- fluidPage(
  theme = shinytheme("yeti"),
  navbarPage(
    "Occupations in Washington State",
    tabPanel("Overview",
             mainPanel(
               h3(class = "title", "Overview"),
               p(""),
               p(""),
               h3(class = "title", "Questions"),
               p(tags$ol(
                 tags$li("Which area in Washington has the highest average hourly income?"),
                 tags$li("Which occupations have the highest average hourly incomes?"),
                 tags$li("Which occupation is most popular in each region?"),
                 tags$li("Which area(s) have the most variability in hourly incomes?"),
                 tags$li("Do metropolitan areas have higher wages than non-metropolitan areas?")
               )
               )
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
    )
  )
)

shinyUI(ui)