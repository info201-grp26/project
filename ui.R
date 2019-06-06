#source("pkg-check.R")
#pkgCheck(c("shiny", "shinythemes"))

library(shiny)
library(shinythemes)

source("process-data.R")

ui <- fluidPage(
  theme = shinytheme("paper"),
  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
  ),
  navbarPage(
    "Occupations in Washington State",
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
        #plotOutput("areaPlot", width = "100%", height = "550px"),
        
        h3(class = "title", "Our Team"),
        p(tags$ul(
          tags$li("Khoa Luong: I have been programming since middle school and 
                  I plan to get a job in the technology field, which is why I 
                  am very interested to learn about this data."),
          tags$li("Matthew McNeil: I recently decided learn programming for its 
                  applications to data science, and want to apply it to work in 
                  a psychology lab."),
          tags$li("Saatvik Arya: I started learning programming in middle school and I want to work as a Product Manager in the future."),
          tags$li("Sherry Zhang: I started to learn about programming in college, 
                  and want to become a UI designer in the future.")
          )
        ),
      
        h3(class = "title", "Questions"),
        p(tags$ol(
          tags$li("Which area in Washington has the highest average hourly income?"),
          tags$li("Which occupations have the highest average hourly incomes?"),
          tags$li("Which occupations have the lowest average hourly incomes?"),
          tags$li("Which occupation is most popular in each region?"),
          tags$li("How do the hourly incomes vary across Washington State for a give occupation?")
        )
        )
      )
    ),
    tabPanel("Region",
             mainPanel(
               fluidRow(
                 column(12, plotOutput("areaPlot", width = "100%", height = "600px"))
               )
               
             )
    ),
    
    tabPanel(
      "Occupation and Area Lookup",
      h3(class = "title", "Browse occupation by area in the dataset"),
      #h3(class = "title", "Which area in Washington has the highest average hourly income?"),
      sidebarLayout(
        sidebarPanel(
          selectInput(
            inputId = "Area2",
            label = "Area",
            choices = as.character(areas_choices[["Area.name"]])[2:19]
          ),
          uiOutput("areaOccupations"),
          plotOutput("countyMap2")
        ),
        mainPanel(
          uiOutput("hourlyWage"),
          uiOutput("annualWage"),
          uiOutput("highestWageArea"),
          plotOutput("occupationPlot")
        )
      )
    ),
    
    tabPanel("Compare My Income",
             h3(class = "title", "Compare My Average Hourly Income"),
             sidebarLayout(
               sidebarPanel(
                 numericInput(
                   inputId = "wageInput",
                   label = "Hourly wage ($/hr)",
                   value = 15.00
                 ),
                 selectInput(
                   inputId = "Occupation2",
                   label = "Occupation",
                   choices = as.vector(state_occupations)
                 )
               ),
               mainPanel(
                 plotOutput("variablePlot"),
                 textOutput("variableText")
               )
             )
    ),

    navbarMenu("Hourly Income",
      tabPanel(
        "WA State",
        h3(class = "title", "Which area in Washington has the highest average hourly income? What occupation is it?"),
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
               "in Spokane", strong("($84.88)"), "."),
            p("Click and drag the slider below to see a longer list highest paying occupations
               in Washington State, along with the corresponding area."),
            h4(textOutput("hourlyNText")),
            plotOutput("topNPlot"),
            tableOutput(tbl_df("hourlyWagesTable"))
          )
        )
      ),
      tabPanel(
        "Counties",
        h3(class = "title", "How does the highest and lowest paying occupations vary across Washington State?"),
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
            p("This data frame below shows", strong("top 10 / bottom 10 average hourly wages"), 
              "occupations in Washington State counties." ),
            p("Click the drop down menu to select which county you want to learn more about,
              along with the corresponding area."),
            fluidRow(
                       column(6,
                        h4(textOutput("topHourlyText")),
                        tableOutput("hourlyAreaTable")
                       )
                       ,
                       column(6,
                        h4(textOutput("bottomHourlyText")),
                        tableOutput("hourlyAreaTableBottom")
                       )
                     ),
            
            h4('Description'),
            p("Observed from the graph,", strong ("Chief Executives ($60/hr - $70/hr)"),"is the occupation 
            with the **highest** average hourly wage.", strong("Hotel Clerks ($12/hr), Cleaners ($13/hr), 
            Cashiers ($13/hr)"), "are the occupations with the", strong("lowest"),"average hourly wage."),
            p("Click and drag the slider on the left to see a longer list of the most to least popular occupations 
               in Washington State.")
            
                   )
                 )
          )),

    navbarMenu("Occupations",
               tabPanel(
                 "WA State",
                 h3(class = "title", "Which occupations are most popular in Washington State?"),
                 sidebarLayout(
                   sidebarPanel(
                     sliderInput(
                       inputId = "mostEmployedWASlider",
                       label = "Top N",
                       value = 10,
                       min = 1,
                       max = 25)
                   ),
                 mainPanel(
                   h4('Description'),
                   p("Data frame below shows the top N most popular occupations in the Washington State. 
                     Observed from the data frame, the most popular occupation is", strong("retail salesman"), 
                      ", and", strong("top 5"), "occupations' average income wages are", strong("low ($14/hr - $17/hr)")),
                   
                   tableOutput("mostEmployedWATable")
                 )
               )),
               tabPanel(
                 "Counties",
                 h3(class = "title", "How does the most popular occupation vary across Washington State?"),
                 mainPanel(
                   #h4('Description'),
                   #p(""),
                  plotOutput("mostEmployedPlot"),
                   tableOutput("mostEmployedTable")
                 )

               )
              )
  )
)

shinyUI(ui)