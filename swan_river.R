library(leaflet)
library(tidyverse)
library(sf)
library(htmlwidgets)
library(glue)

shipwrecks <- read_csv("Swan Shipwrecks.csv") %>% st_as_sf(coords = c("Lon", "Lat"))

popup = glue('<b>{shipwrecks$Name}</b></br>
             Sunk: {shipwrecks$Sunk}</br>
             {shipwrecks$Description}</br>
             <a href="{shipwrecks$Link}" target="_blank" rel="noopener noreferrer">More info 🔗</a>')


map <- leaflet(shipwrecks, options = leafletOptions(preferCanvas = TRUE)) %>% 
  addProviderTiles(providers$CartoDB.Voyager,
                   options = providerTileOptions(minZoom = 8, maxZoom = 16),
                   group="basemap") %>% 
  groupOptions("basemap", zoomLevels = 0:18) %>% 
  addCircleMarkers(popup = popup,
             color = "#1B54A8", radius=5, opacity=0.7, weight = 6,
             popupOptions = popupOptions(maxHeight = 320)) %>% 
  addScaleBar(position = 'bottomleft') %>% 
  htmlwidgets::onRender(paste0("
    function(el, x) {
      $('head').append('<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" />');
    }"))
map
saveWidget(map, file="index.html", title="Shipwrecks of the Swan River")
