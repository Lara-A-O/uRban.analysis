#' @title Gets the Land Surface Temperature 
#' @description Calculates the Land Surface Temperature within the given boundary based on a Landsat Scene. 
#' Used Formula: `LST = ST_B10 x 0,00341802 +149 -273,15`
#' Where
#' 
#' -`0,00341802` = Scaling Factor 
#' -`149`= Off-Set Value 
#' `-273,15` = Kelvin to Celcius
#'
#' @param st_b10_path Character Path to the Landsat Thermal Band Tif
#' @param city Character Name of the city that is being analyzed
#' @param date Date Acquisition Date of the Landsat Scene 
#' @examples 
#' lst_result <- get_LST(
#' st_b10_path = "C:/Users/LaraO/EAGLE_Master/1_Semester/New R-Package/LC08_L2SP_197025_20250620_20250627_02_T1_ST_B10.TIF",
#' city = "Aachen", 
#' date = as.Date("2025-06-20") )
#' 
#' @return List with four elements: The calculated LST, the city name, the date and the city boundary
#' @export


get_LST <- function(st_b10_path, city, date) {

  ST_B10 <- terra::rast(st_b10_path)

  LST <- ST_B10 * 0.00341802+149-273.15

  boundary <- get_city_boundary(city)

  boundary_reproj <- sf::st_transform(boundary, terra::crs(LST))

  LST_cropped <- terra::crop(LST, terra::vect(boundary_reproj))

  LST_masked <- terra::mask(LST_cropped, terra:: vect(boundary_reproj))

  result <- list(
    LST = LST_masked,
    city = city, 
    date = date, 
    boundary = boundary_reproj
  )

return(result)
}

