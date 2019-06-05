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
        plotOutput("areaPlot", width = "100%", height = "550px"),
        
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
              and learn more about the county geographic information with the map below the menu bar"),
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
            p("Observed from the graph,", strong ("Chief Executives ($60/hr - $70/hr)"),"is the occupation with the **highest** 
              average hourly wage.", strong("Hotel Clerks ($12/hr), Cleaners ($13/hr), Cashiers ($13/hr)"), "are the 
              occupations with the", strong("lowest"),"average hourly wage.")
            
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
                   p(""),
                   
                   tableOutput("mostEmployedWATable")
                 )
               )),
               tabPanel(
                 "Counties",
                 h3(class = "title", "How does the most popular occupation vary across Washington State?"),
                 mainPanel(
                   h4('Description'),
                   p(""),
                  plotOutput("mostEmployedPlot"),
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
          h4(textOutput("occupationAreaLookup"))
        )
      )
    )
  )
)

shinyUI(ui)