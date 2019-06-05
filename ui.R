# library(plotly)
# library(shiny)
# library(shinythemes)

source("pkg-check.R")
pkgCheck(c("shiny", "shinythemes"))

source("process-data.R")

ui <- fluidPage(
  theme = shinytheme("yeti"),
  navbarPage(
    "Occupations in Washington State - Group 6:45 (Khoa Luong, Matthew McNeil, Saatvik Arya, Sherry Zhang)",
    tabPanel("Overview",
      mainPanel(
        h3(class = "title", "Overview"),
        p("Our group is working with data that estimates occupational employment and wages in Washington
           State in 2018. The data records the occupation title along with the mean hourly and yearly wages, 
           as well as 25th, 50th and 75th percentile hourly wages. The data was collected from a survey of 4,800 
           state employers, collecting information on over 800 occupations with a total sample size of 29,300 employees."),
        p("The data includes employment and wage figures for different regions as well as Washington as a whole. 
           We hope visualizing this data will provide current and graduating college students with valuable information 
           on prospective fields of employment while also providing insight into the diverse economy of Washington State."),
        plotOutput("areaPlot"),
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
    
    navbarMenu("Hourly Income",
      tabPanel(
        "WA State",
        h3(class = "title", "Which area in Washington has the highest average hourly income?"),
        sidebarLayout(
          sidebarPanel(
            sliderInput(
              inputId = "hourlyN", 
              label = "Top N", 
              value = 1,
              min = 1, 
              max = 15)
          ),
          mainPanel(
            h4('Description'),
            p("The top paying jobs in Washington include", strong("Dentist"), "in 
               the Greater Seattle Area", strong("($89.81/hr)"), ",", strong("Dentist"),
               "in Yakima", strong("($88.33)"), "and", strong("General Practitioner"), 
               "in Spokane", strong("($84.88)"),"."),
            p("Click and drag the slider below to see a longer list highest paying occupations
               in Washington State, along with the corresponding area."),
            h4("Top N average hourly wages in Washington"),
            plotOutput("topNPlot"),
            tableOutput(tbl_df("hourlyWagesTable"))
          )
        )
      ),
      tabPanel(
        "Counties",
        h3(class = "title", "Which area in Washington has the highest average hourly income?"),
          sidebarLayout(
            sidebarPanel(
              selectInput(
                inputId = "Area",
                label = "Area",
                choices = as.vector(areas_choices)
              ),
              plotOutput("countyMap1")
            ),
          mainPanel(
            h4('Description'),
            p(""),
            flowLayout(
            fluidPage(
                         h4("Top 10 average hourly wages for the given Area"),
                         tableOutput("hourlyAreaTable")
                       )
                       ,
                       fluidPage(
                         h4("Bottom 10 average hourly wages for the given Area"),
                         tableOutput("hourlyAreaTableBottom")
                       )
                     )
                   )
                 )
          )),
    
    navbarMenu("Occupations",
               tabPanel(
                 "WA State",
                 h3(class = "title", "Which occupations are most popular in Washington State?"),
                 mainPanel(
                   h4('Description'),
                   p(""),
                   #plotOutput("topNPlot"),
                   tableOutput("mostEmployedWATable")
                 )
               ),
               tabPanel(
                 "Counties",
                 h3(class = "title", "Which occupations are most popular in Counties?"),
                 mainPanel(
                   h4('Description'),
                   p(""),
                   #plotOutput("topNPlot"),
                   tableOutput("mostEmployedTable")
                 )
               )),
    tabPanel(
      "Occupation and Area Lookup",
      h3(class = "title", "Browse occupation by area in the dataset"),
      #h3(class = "title", "Which area in Washington has the highest average hourly income?"),
      sidebarLayout(
        sidebarPanel(
          selectInput(
            inputId = "Area2",
            label = "Area",
            choices = as.vector(areas_choices)
          ),
          selectInput(
            inputId = "Occupation",
            label = "Occupation",
            choices = as.vector(occupations)
          ),
          plotOutput("countyMap2")
        ),
        mainPanel(
          h4('Description'),
          p(""),
          tableOutput("occupationAreaLookup")
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