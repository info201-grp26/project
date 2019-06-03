source("pkg-check.R")

pkgCheck(c("RSocrata", "dplyr"))

data <- read.csv("data/Occupational_Employment_and_Wage_Estimates.csv")

View(data)

