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
