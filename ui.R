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
                 tags$li("?"),
                 tags$li("?"),
                 tags$li("?"),
                 tags$li("?")
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