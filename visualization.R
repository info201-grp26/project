source("pkg-check.R")
pkgCheck(c("ggplot2", "maps", "usmap"))

map <- map_data("state", region = "washington")

drawMap <- function() {
  map_render <- ggplot() + geom_polygon(data = map, aes(long, lat))
}

render <- drawMap()

drawGraph <- function() {
  
}

ggsave(filename = "test.jpg", plot = render)