#' @title Map vulnerable facilities within LST hotspots 

#'@description Creates an interactive Leaflet map showing vulnerable facilities within perviously identified LST hotspots
#' 
#' @examples 
#' df <- table_facilities_heat(lst_result, 0.9)
#' map_facilities_heat(df)
#' 
#' @export



map_facilities_heat <- function(df) {
  library(leaflet)

  pal <- colorFactor(
    palette = "viridis", 
    domain = df$category)

  leaflet(df) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addCircleMarkers(
      lng = ~lon,
      lat = ~lat,
      popup = ~paste0("<b>", name, "</b><br>", category),
      color = pal (df$category),
      radius = 6
    )
}



