source("pkg-check.R")

drawMap <- function(area) {
  
  yo <- area$fips
  
  map_render <- plot_usmap(data = area, values = "Area.name", regions = "county", include = yo) +
    labs(title = "Washington State, metropolitan divisions (MD), metropolitan statistical areas (MSA) and nonmetropolitan areas (NMA)", 
         subtitle = "This includes some counties from Idaho and Oregon")
  ggsave(filename = "test.jpg", plot = map_render)
}

drawGraph <- function() {
  
}