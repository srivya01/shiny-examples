library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

# Leaflet bindings are a bit slow; for now we'll just sample to compensate
set.seed(100)
zipdata <- allzips[sample.int(nrow(allzips), 10000),]
# By ordering by centile, we ensure that the (comparatively rare) SuperZIPs
# will be drawn last and thus be easier to see
zipdata <- zipdata[order(zipdata$centile),]

data <- readRDS(file = "//safeautonet/dfs/dds/exports/geoVisualizationExtract.RDS")
latlong <- read.csv("//safeautonet/dfs/dds/exports/zipcodeLatLongMapping.csv", header = TRUE)
dataFrame <- merge.data.frame(data,latlong, by.x = "GaragingZipCode", by.y = "GEOID" )

function(input, output, session) {

  ## Interactive Map ###########################################

  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -93.85, lat = 37.45, zoom = 4)
  })

  # A reactive expression that returns the set of zips that are
  # in bounds right now
  
  

  # Precalculate the breaks we'll need for the two histograms
  

  

  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
  observe({
    colorBy <- input$color
    sizeBy <- input$size

    
    colorData <- dataFrame[[Loss]]
    pal <- colorBin("viridis", colorData, 7, pretty = FALSE)
    

    
    radius <- dataFrame[[sizeBy]] / max(dataFrame[[sizeBy]]) * 30000
    
    leafletProxy("map", data = dataFrame) %>%
      clearShapes() %>%
      addCircles(~INTPTLONG, ~INTPTLAT, radius=radius, layerId=~GaragingZipCode,
        stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData)) %>%
      addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,
        layerId="colorLegend")
  })

  # Show a popup at the given location
  

  # When map is clicked, show a popup with city info
  


  ## Data Explorer ###########################################

  
}
