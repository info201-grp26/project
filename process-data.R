library(dplyr)
library(tidyr)

pkgCheck(c("RSocrata", "dplyr"))
source("pkg-check.R")

data <- read.csv("data/Occupational_Employment_and_Wage_Estimates.csv")
data <- drop_na(data) # drop rows with incomplete wage data

areas <- distinct(select(data, Area.name))
occupations <- distinct(select(data, Occupational.title))

state_data <- filter(data, Area.code == 53)
state_occupations <- distinct(select(state_data, Occupational.title))

area_data <- filter(data, Area.code != 53) # filter out Washington-State rows

cities <- distinct(select(area_data, Area.name))

get_occupation_data <- function(occupation) filter(data, Occupational.title == occupation)
get_area_data <- function(area) filter(data, Area.name == area)
get_area_occupation_data <- function(area, occupation) filter(data, Area.name == area & Occupational.title == occupation)

bartender_data <- get_occupation_data("Bartenders")
bellingham_data <- get_area_data("Bellingham, WA")
bellingham_bartender_data <- get_area_occupation_data("Bellingham, WA", "Bartenders")



get_highest_hourly <- function(n) top_n(arrange(area_data, -Average.wage), 10, Average.wage)

View(get_highest_hourly(10))




