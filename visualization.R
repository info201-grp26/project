source("pkg-check.R")

drawMap <- function(area) {
  
  map_render <- plot_usmap(regions = "county", include = area$county_fips) +
    labs(title = "Western US States", subtitle = "These are the states in the Pacific Timezone.")
  ggsave(filename = "test.jpg", plot = map_render)
}

drawGraph <- function() {
  
}