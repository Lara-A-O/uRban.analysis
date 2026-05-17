#' @title Gets the Land Use and Land Cover Classification 
#' 
#' @description Loads the CORINE Land Cover raster and masks it to the boundaries of the specified city. A lookup table is created to extracr the 44 CORINE land cover classes from the dataset.
#' 
#' @param path_to_CORINE - Character: Path to the CORINE Land Cover raster (.tif)
#' @param city           - Character: Name of the city that is being analyzed
#' 
#' @examples 
#' #Create the list 
#' lulc_result <- get_LULC(
#'  path_to_CORINE = "C:/Users/LaraO/EAGLE_Master/1_Semester/New R-Package/U2018_CLC2018_V2020_20u1.tif",
#'  city = "Aachen"
#' 
#' #Access the masked raster
#' lulc_result$clc_masked
#' 
#' #See which land cover classes are present within the city boundary 
#' lulc_result$clc_lookup_present
#' 
#' @return List with four elements: The masked raster, the look table, the city name and the city boundary
#' 
#' @export 
#' 
#' 

get_LULC <- function(path_to_CORINE, city) {

clc      <- terra::rast(path_to_CORINE)
  
  boundary <- get_city_boundary(city)

  boundary_reproj <- sf::st_transform(boundary, terra::crs(clc))

  clc_cropped <- terra::crop(clc, terra::vect(boundary_reproj))

  clc_masked  <- terra::mask(clc_cropped, terra::vect(boundary_reproj))


clc_lookup <- data.frame(
  clc_id = 1:44, #amount of CORINE Classes
  label = c(
    # 1. Artificial Surfaces
    "Continuous urban fabric",
    "Discontinuous urban fabric",
    "Industrial or commercial units",
    "Road and rail networks",
    "Port areas",
    "Airports",
    "Mineral extraction sites",
    "Dump sites",
    "Construction sites",
    "Green urban areas",
    "Sport and leisure facilities",
    # 2. Agricultural Areas
    "Non-irrigated arable land",
    "Permanently irrigated land",
    "Rice fields",
    "Vineyards",
    "Fruit trees and berry plantations",
    "Olive groves",
    "Pastures",
    "Annual crops / permanent crops",
    "Complex cultivation patterns",
    "Agriculture + natural vegetation",
    "Agro-forestry areas",
    # 3. Forest and Semi Natural Areas
    "Broad-leaved forest",
    "Coniferous forest",
    "Mixed forest",
    "Natural grassland",
    "Moors and heathland",
    "Sclerophyllous vegetation",
    "Transitional woodland-scrub",
    "Beaches, dunes, sands",
    "Bare rocks",
    "Sparsely vegetated areas",
    "Burnt areas",
    "Glaciers and perpetual snow",
    # 4. Wetlands
    "Inland marshes",
    "Peat bogs",
    "Salt marshes",
    "Salines",
    "Intertidal flats",
    # 5. Water Bodies
    "Water courses",
    "Water bodies",
    "Coastal lagoons",
    "Estuaries",
    "Sea and ocean"
  ),

  color = c(
    "#E6004D", "#FF0000", "#CC4DF2", "#CC0000", "#E6CCCC", "#E6CCE6",
    "#A600CC", "#A64DCC", "#FF4DFF", "#FFB8E8", "#E68080",
    "#FFFFA8", "#FFFF00", "#E6E600", "#E68000", "#F2A64D",
    "#E6A600", "#E6E64D", "#FFE6A6", "#FFE64D", "#E6CC4D", "#F2CCA6",
    "#80FF00", "#00A600", "#4DFF00", "#CCF24D", "#A6FF80",
    "#A6E64D", "#A6F200", "#E6E6E6", "#CCCCCC", "#CCFFCC",
    "#000000", "#A6E6CC",
    "#A6A6FF", "#4D4DFF", "#CCCCFF", "#E6E6FF", "#A6A6E6",
    "#00CCF2", "#80F2E6", "#00FFA6", "#A6FFE6", "#E6F2FF"
  )
)

  present_ids        <- unique(stats::na.omit(terra::values(clc_masked)))
  
  clc_lookup_present <- clc_lookup |> dplyr::filter(clc_id %in% present_ids)

  return(list(
    clc_masked         = clc_masked,
    clc_lookup_present = clc_lookup_present,
    boundary_reproj    = boundary_reproj,
    city               = city
  ))
}








