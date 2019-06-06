#source("pkg-check.R")
#pkgCheck(c("usmap", "ggplot2", "dplyr"))

library(usmap)
library(ggplot2)
library(dplyr)


drawMap <- function(area, title, subtitle) {
  map_render <- plot_usmap(data = area, values = "Area.name", regions = "county", include = areas_fips$fips) +
                labs(title = title,
                     subtitle = subtitle) +
  scale_fill_discrete(name = "Areas") + theme(legend.position = "none")
  map_render
}

counties_data <- us_map(regions = "counties") %>% group_by(fips) %>% summarise(lat = mean(lat), long = mean(long))

regionPlot <- function(dataset) {
  dataset <- left_join(dataset, counties_data, by = "fips")
  dataset <- dataset %>% group_by(Area.name) %>% summarise(lat = mean(lat), long = mean(long))
  
  map_render <- plot_usmap(data = areas_fips, values = "Area.name", regions = "county", include = areas_fips$fips)
  map_render <- map_render + geom_label(data = dataset, aes(long, lat, label = Area.name))
  map_render <- map_render + labs(title = "Washington State counties, highlighted by statistical divisions", subtitle = "This includes some counties from Idaho and Oregon")
  map_render <- map_render + scale_fill_discrete(name = "Areas") + theme(legend.position = "bottom")
  map_render
}

# duplicate values are omitted from the labels
topWAplot <- function(dataset) {
  names(dataset)[1] <- "Area.name"
  dataset <- left_join(dataset, areas_fips, by = "Area.name")
  dataset2 <- dataset
 
  dataset <- left_join(dataset, counties_data, by = "fips")
  names(dataset)[3] <- "wage"
  dataset <- dataset %>% group_by(wage) %>% summarise(Area.name = first(Area.name), Occupation = first(Occupation), lat = mean(lat), long = mean(long))
  
  map_render <- plot_usmap(data = dataset2, values = "Area.name", regions = "county", include = areas_fips$fips)
  map_render <- map_render + geom_label(data = dataset, aes(long, lat, label = paste(paste0("$", wage), Occupation, sep = "\n")))
  map_render <- map_render + scale_fill_discrete(name = "Areas") + theme(legend.position = "right")
  map_render
}

employmentPlot <- function() {
  dataset <- most_employed
  names(dataset)[1] <- "Area.name"
  dataset <- left_join(dataset, areas_fips, by = "Area.name")
  dataset$Occupation <- as.character(dataset$Occupation) 
  dataset$Employment <- as.numeric(dataset$Employment) 
  dataset2 <- dataset
  
  dataset$Occupation[dataset$Occupation == "Combined Food Preparation & Serving Workers, Inc Fast Food"] <- "Food Workers"
  dataset$Occupation[dataset$Occupation == "Farm Workers & Laborers/Crop/Nursery & Greenhouse"] <- "Farm Workers"
  dataset$Occupation[dataset$Occupation == "General & Operations Managers"] <- "Managers"
  dataset$Occupation[dataset$Occupation == "Software Developers, Applications"] <- "Software Developers"
  
  dataset <- left_join(dataset, counties_data, by = "fips")
  dataset <- dataset %>% group_by(Occupation) %>% summarise(Employment = sum(Employment), lat = median(lat), long = median(long))
  
  
  map_render <- plot_usmap(data = dataset2, values = "Occupation", regions = "county", include = areas_fips$fips)
  map_render <- map_render + geom_label(data = dataset, aes(long, lat, label = Occupation))
  map_render <- map_render + scale_fill_discrete(name = "Occupations") + theme(legend.position = "bottom")
  map_render
}


drawBox <- function(dataset, datapoint) {
  iqr = (dataset$X75th.Percentile - dataset$X25th.Percentile)
  ymin = dataset$X25th.Percentile - 1.5 * iqr
  ymax = dataset$X75th.Percentile + 1.5 * iqr
  
  plot_render <- ggplot(data = dataset, aes(x = Occupational.title)) +
    geom_boxplot(aes(ymin = ymin, ymax = ymax, middle = X50th.Percentile, upper = X75th.Percentile,
                     lower= X25th.Percentile, alpha = 0.7),
                 stat = 'identity') + ylab("Hourly Wage") +
    geom_point(aes(y = datapoint, color = "red"), size = 5) +
    coord_flip() + theme(axis.title.y = element_blank(), axis.text.y=element_blank(),
                         axis.ticks.y=element_blank(), legend.position = "none") +
    ggtitle(paste("Your income is", round(abs(dataset$X50th.Percentile - datapoint),digits =  2), 
                  "dollars away from the state median income"))
  plot_render
}

occupationPlot <- function(dataset) {
  dataset <- dataset %>% select(Area.name, Occupational.title, Average.wage) %>%  left_join(areas_fips, by = "Area.name")
  dataset2 <- dataset
  
  dataset <- left_join(dataset, counties_data, by = "fips")
  dataset <- dataset %>% group_by(Area.name) %>% summarise(Average.wage = mean(Average.wage), lat = median(lat), long = median(long))
  
  map_render <- plot_usmap(data = dataset2, values = "Area.name", regions = "county", include = areas_fips$fips)
  map_render <- map_render + geom_label(data = dataset, aes(long, lat, label = Average.wage))
  map_render <- map_render + labs(title = paste0("Average Hourly Wage for ", first(dataset2$Occupational.title), " accross Washington State"))
  map_render <- map_render + scale_fill_discrete(name = "Areas") + theme(legend.position = "bottom")
  map_render
}

