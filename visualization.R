source("pkg-check.R")
pkgCheck(c("usmap", "ggplot2", "dplyr"))
library(urbnmapr)

drawMap <- function(area, title, subtitle, legend_position) {
  counties_data <- counties %>% group_by(county_fips) %>% summarise(lat = mean(lat), long = mean(long))
  area_map <- areas_fips 
  print(names(area))
  names(area_map)[2] <- "county_fips"
  area_map <- left_join(area_map, counties_data, by = "county_fips")
  
  map_render <- plot_usmap(data = area, values = "Area.name", regions = "county", include = areas_fips$fips) +
                labs(title = title,
                     subtitle = subtitle) +
  #geom_text(data = area_map, aes(label = "?", x = lat, y = long)) + 
  scale_fill_discrete(name = "Areas") + theme(legend.position = "none")
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
  map_render <- map_render + geom_label(data = dataset, aes(long, lat, label = wage))
  map_render <- map_render + scale_fill_discrete(name = "Areas") + theme(legend.position = "right")
  map_render
}

# duplicate values are omitted from the labels
employmentPlot <- function(dataset) {
  names(dataset)[1] <- "Area.name"
  dataset <- left_join(dataset, areas_fips, by = "Area.name")
  
  map_render <- plot_usmap(data = dataset2, values = "Occupation", regions = "county", include = areas_fips$fips)
  map_render <- map_render + scale_fill_discrete(name = "Occupations") + theme(legend.position = "right")
  map_render
}



