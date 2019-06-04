source("pkg-check.R")



drawMap <- function(area) {
  #area_map <- area
  #names(area_map)[2] <- "county_fips"
  #area_map <- left_join(area_map, counties, by = "county_fips")
  
  map_render <- plot_usmap(data = area, values = "Area.name", regions = "county", include = area$fips) +
                labs(title = "Washington State, metropolitan divisions (MD), metropolitan statistical areas (MSA) and nonmetropolitan areas (NMA)", 
                     subtitle = "This includes some counties from Idaho and Oregon") + 
                #geom_text(data = area_map, aes(label = ~Area.name, x = ~lat, y = ~long)) + 
                scale_fill_discrete(name="Areas") +
                theme(legend.position = "right")
  map_render
}

selectedMap <- function(dataset) {
  names(dataset)[1] <- "Area.name"
  dataset <- left_join(dataset, areas_fips, by = "Area.name")
  map_render <- plot_usmap(data = dataset, values = "Area.name", regions = "county", include = areas_fips$fips) +
    labs(title = "Occupations with the highest average hourly incomes") +
    #geom_text(aes(label = ~Average.wage, x = ~lat, y = ~long)) + 
    scale_fill_discrete(name="Areas") +
    theme(legend.position = "right")
  map_render
}
