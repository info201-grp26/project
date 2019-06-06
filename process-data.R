#source("pkg-check.R")
source("visualization.R")
#pkgCheck(c("dplyr", "tidyr", "usmap"))
library(dplyr)
library(usmap)
library(tidyr)

data <- read.csv("data/Occupational_Employment_and_Wage_Estimates.csv", stringsAsFactors = FALSE)
data <- drop_na(data) # drop rows with incomplete wage data

data$Area.name[data$Area.name == "Seattle-Bellevue-Everett, WA Metropolitan Division"] <- "Seattle-Bellevue-Everett, WA"
data$Area.name[data$Area.name == "Tacoma-Lakewood, WA Metropolitan Division"] <- "Tacoma-Lakewood, WA"
data$Area.name[data$Area.name == "Spokane-Spokane Valley, WA"] <- "Spokane Valley, WA"
data$Area.name[data$Area.name == "Northwestern WA Nonmetropolitan Area (NMA)"] <- "Northwestern WA"
data$Area.name[data$Area.name == "Southwestern WA Nonmetropolitan Area (NMA)"] <- "Southwestern WA"
data$Area.name[data$Area.name == "Central WA Nonmetropolitan Area (NMA)"] <- "Central WA"
data$Area.name[data$Area.name == "Eastern WA Nonmetropolitan Area (NMA)"] <- "Eastern WA"



areas_choices <- distinct(select(data, Area.name))
occupations <- distinct(select(state_data, Occupational.title))

# add fip codes to data frame 
areas_fips <- areas_choices
county_fips <- list(NA, 53073, 53035, c(53005, 53021), c(53003, 16069), 53015, 53057, 53067,
               c(41005, 53011, 41009, 41051, 53059, 41071), c(53033, 53061),
               c(53051, 53063, 53065), 53053, c(53013, 53071), c(53007, 53017), 53077, c(53009, 53031, 53055),
               c(53027, 53041, 53049, 53045, 53069), c(53037, 53039, 53047), c(53001, 53019, 53023, 53025, 53043, 53075))
areas_fips$fips <- county_fips
areas_fips <- unnest(areas_fips, fips)
areas_fips <- drop_na(areas_fips)
areas_fips$fips <- as.character(areas_fips$fips)

state_data <- filter(data, Area.code == 53)
state_occupations <- distinct(select(state_data, Occupational.title))

area_data <- filter(data, Area.code != 53) # filter out Washington-State rows

get_occupation_data <- function(occupation) filter(data, Occupational.title == occupation) %>% filter(Area.name != "Washington State")
get_state_occupation_data <- function(occupation) filter(state_data, Occupational.title == occupation)
get_area_data <- function(area) filter(data, Area.name == area)
get_area_occupations <- function(area) filter(data, Area.name == area) %>% pull(Occupational.title)
get_hr_wage <- function(df) df$Average.wage
get_annual_wage <- function(df) df$Annual.wage
get_area_occupation_data <- function(area, occupation) filter(data, Area.name == area & Occupational.title == occupation)

get_hourly <- function(n) {
  df <- arrange(area_data, -Average.wage) %>% top_n(n, Average.wage)
  df <- select(df, Area.name, Occupational.title, Average.wage)
  names(df) <- c("Area", "Occupation", "Avg. Hourly Wage")
  df
}

get_area_hourly <- function(n, area) {
  if (n < 0) {
    df <- arrange(get_area_data(area), Average.wage)
  } else {
    df <- arrange(get_area_data(area), -Average.wage)
  }
  df <- df %>% top_n(n, Average.wage)
  df <- select(df, Occupational.title, Average.wage)
  names(df) <- c("Occupation", "Avg. Hourly Wage")
  tbl_df(df)
}

get_employed_WA <- function(n) {
  df <- top_n(state_data, n, Employment)
  df <- arrange(state_data, -Employment) %>% top_n(n, Employment)
  df <- select(df, Occupational.title, Employment, Average.wage, Annual.wage)
  names(df) <- c("Occupation", "# Employed", "Average Hourly Wage", "Annual Wage")
  tbl_df(df)
}

get_popular_occupation <- function(area) {
  first(arrange(get_area_data(area), -Employment) %>% pull(Occupational.title)) %>% as.character()
}

get_employment <- function(area) {
  first(arrange(get_area_data(area), -Employment) %>% pull(Employment)) %>% as.character()
}

employment_areas <- as.character(areas_choices[["Area.name"]])[2:19]
popular_occupations <- lapply(employment_areas, get_popular_occupation)
employment <- lapply(employment_areas, get_employment)
most_employed <- data_frame(Area = employment_areas, Occupation = popular_occupations, Employment = employment)






