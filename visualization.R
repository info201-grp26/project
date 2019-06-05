source("pkg-check.R")
pkgCheck(c("usmap", "ggplot2", "dplyr"))

drawMap <- function(area, title, subtitle) {
  map_render <- plot_usmap(data = area, values = "Area.name", regions = "county", include = areas_fips$fips) +
                labs(title = title,
                     subtitle = subtitle) +
  scale_fill_discrete(name = "Areas") + theme(legend.position = "none")
  map_render
}

regionPlot <- function(dataset) {
  counties_data <- us_map(regions = "counties") %>% group_by(fips) %>% summarise(lat = mean(lat), long = mean(long))
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
 
  counties_data <- us_map(regions = "counties") %>% group_by(fips) %>% summarise(lat = mean(lat), long = mean(long))
  dataset <- left_join(dataset, counties_data, by = "fips")
  names(dataset)[3] <- "wage"
  dataset <- dataset %>% group_by(wage) %>% summarise(Area.name = first(Area.name), Occupation = first(Occupation), lat = mean(lat), long = mean(long))
  
  map_render <- plot_usmap(data = dataset2, values = "Area.name", regions = "county", include = areas_fips$fips)
  map_render <- map_render + geom_label(data = dataset, aes(long, lat, label = paste(paste0("$", wage), Occupation, sep = "\n")))
  map_render <- map_render + scale_fill_discrete(name = "Areas") + theme(legend.position = "right")
  map_render
}

employmentPlot <- function(dataset) {
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
  
  counties_data <- us_map(regions = "counties") %>% group_by(fips) %>% summarise(lat = mean(lat), long = mean(long))
  dataset <- left_join(dataset, counties_data, by = "fips")
  names(dataset)
  dataset <- dataset %>% group_by(Occupation) %>% summarise(Employment = sum(Employment), lat = median(lat), long = median(long))
  
  
  map_render <- plot_usmap(data = dataset2, values = "Occupation", regions = "county", include = areas_fips$fips)
  map_render <- map_render + geom_label(data = dataset, aes(long, lat, label = Occupation))
  map_render <- map_render + scale_fill_discrete(name = "Occupations") + theme(legend.position = "bottom")
  map_render
}


