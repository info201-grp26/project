source("pkg-check.R")
source("visualization.R")
pkgCheck(c("dplyr", "tidyr", "usmap"))
library(dplyr)
library(tidyr)
library(usmap)

data <- read.csv("data/Occupational_Employment_and_Wage_Estimates.csv")
data <- drop_na(data) # drop rows with incomplete wage data

areas_choices <- distinct(select(data, Area.name))
occupations <- distinct(select(data, Occupational.title))

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
drawMap(areas_fips)

#areas_fips$lat <- c(47.6101, 48.7519, 47.6477, 46.2226348, 46.400245, 46.1382, 48.4203088, 47.037872, 45.6537, 47.7511, 47.6732, 47.2529, 46.0646, 47.4235, 46.6021, NA, NA, NA, NA)
#areas_fips$long <- c(-122.2015, -122.4787, -122.6413, -119.1830691, -117.00103, -122.9382, -122.3114, -122.900696, -122.5463, -120.7401, -117.2394, -122.4443, -118.3430, -120.3103, -120.5059, NA, NA, NA, NA)

state_data <- filter(data, Area.code == 53)
state_occupations <- distinct(select(state_data, Occupational.title))

area_data <- filter(data, Area.code != 53) # filter out Washington-State rows

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
  df
}

get_highest_area_hourly <- function(n, area) {
  df <- top_n(arrange(get_area_data(area), -Average.wage), n, Average.wage)
  df <- select(df, Occupational.title, Average.wage)
  names(df) <- c("Occupation", "Avg. Hourly Wage")
  tbl_df(df)
}

#top10 <- get_highest_hourly(10)
#selectedMap(top10)

get_most_employed_WA <- function(n) {
  df <- top_n(arrange(state_data, -Employment), n, Employment)
  df <- select(df, Occupational.title, Employment)
  names(df) <- c("Occupation", "# Employed")
  tbl_df(df)
}

get_popular_occupation <- function(area) {
  first(arrange(get_area_data(area), -Employment) %>% pull(Occupational.title)) %>% as.character()
}

get_employment <- function(area) {
  first(arrange(get_area_data(area), -Employment) %>% pull(Employment)) %>% as.character()
}

employment_areas <- as.character(areas_choices[["Area.name"]])
popular_occupations <- lapply(employment_areas, get_popular_occupation)
employment <- lapply(employment_areas, get_employment)
most_employed <- data_frame(Area = employment_areas, Occupation = popular_occupations, Employment = employment)





