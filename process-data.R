library(dplyr)
library(tidyr)
source("pkg-check.R")
source("visualization.R")
pkgCheck(c("dplyr", "tidyr"))

data <- read.csv("data/Occupational_Employment_and_Wage_Estimates.csv")
data <- drop_na(data) # drop rows with incomplete wage data


areas <- distinct(select(data, Area.name))
occupations <- distinct(select(data, Occupational.title))
# add longitude and latitude to the dataframe 
county_fips <- list(NA, 53073, 53035, c(53005, 53021), c(53003, 16069), 53015, 53057, 53067,
               c(41005, 53011, 41009, 41051, 53059, 41071), c(53033, 53061),
               c(53051, 53063, 53065), 53053, c(53013, 53071), c(53007, 53017), 53077, c(53009, 53031, 53055),
               c(53027, 53041, 53049, 53045, 53069), c(53037, 53039, 53047), c(53001, 53019, 53023, 53025, 53043, 53075))
areas$fips <- county_fips

areas_no_state <- unnest(areas_no_state, fips)
areas_no_state <- drop_na(areas_no_state)
areas_no_state$fips <- as.character(areas_no_state$fips)
drawMap(areas_no_state)

areas$latitude <- c(47.6101, 48.7519, 47.6477, 46.2226348, 46.400245, 46.1382, 
                    48.4203088, 47.037872, 45.6537, 47.7511, 47.6732, 47.2529, 
                    46.0646, 47.4235, 46.6021, NA, NA, NA, NA)
areas$longitude <- c(-122.2015, -122.4787, -122.6413, -119.1830691, -117.00103, 
                     -122.9382, -122.3114, -122.900696, -122.5463, -120.7401, 
                     -117.2394, -122.4443, -118.3430, -120.3103, -120.5059, NA, NA, NA, NA)

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

get_highest_hourly <- function(n) {
  df <- top_n(arrange(area_data, -Average.wage), n, Average.wage)
  df <- select(df, Area.name, Occupational.title, Average.wage)
  names(df) <- c("Area", "Occupation", "Avg. Hourly Wage")
  tbl_df(df)
}
get_highest_area_hourly <- function(n, area) {
  df <- top_n(arrange(get_area_data(area), -Average.wage), n, Average.wage)
  df <- select(df, Occupational.title, Average.wage)
  names(df) <- c("Occupation", "Avg. Hourly Wage")
  tbl_df(df)
}

