#' Get city boundary from GADM
#'
#' @param city Character. City name (e.g. "Aachen"). Only for German cities.
#' @return sf object of the city boundary
#' @export
get_city_boundary <- function(city) {
  
  de <- geodata::gadm("DEU", level = 3, path = tempdir())
  
  city_shape <- de[de$NAME_3 == city, ]
  
  if (nrow(city_shape) == 0) stop(paste("City not found in GADM database:", city))

  city_sf <- sf::st_as_sf(city_shape)
  
  return(city_sf)
}
