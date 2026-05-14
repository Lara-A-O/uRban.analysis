LULC_plotted <- function(clc_path, city){
  clc <- terra::rast(clc_path)

  boundary <- get_city_boundary(city)

  boundary_reproj <- sf::st_transform(boundary, terra::crs(clc))

  clc_cropped <- terra::crop(clc, terra::vect(boundary_reproj))
  clc_masked <- terra::mask(clc_cropped, terra::vect(boundary_reproj))


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

   #Filters just the classes that are present within the boundary
  present_ids      <- unique(stats::na.omit(terra::values(clc_masked)))
  
  #Also the look up table is being filtered 
  clc_lookup_present <- clc_lookup |>
    dplyr::filter(clc_id %in% present_ids)

   clc_factor <- terra::as.factor(clc_masked)
  
    levels(clc_factor) <- data.frame(
    value = clc_lookup_present$clc_id,
    label = clc_lookup_present$label) 
  
  
    p <- ggplot() +
    tidyterra::geom_spatraster(data = clc_factor) +

    scale_fill_manual(
      values   = setNames(clc_lookup_present$color, clc_lookup_present$label),
      na.value = NA,
      name     = "Land Use Class"
    ) +
    
  ggspatial::annotation_north_arrow(
      location    = "tr", which_north = "true",
      height      = unit(0.5, "cm"), width = unit(0.5, "cm"),
      pad_x       = unit(0.4, "cm"), pad_y = unit(0.5, "cm")
    ) +
  geom_sf(data = boundary_reproj, fill = NA, color = "black", linewidth = 0.6)+
    ggspatial::annotation_scale(
      location   = "bl", width_hint = 0.3,
      pad_x      = unit(0.6, "cm"), pad_y = unit(0.7, "cm"),
      style      = "ticks"
    ) +

    labs(title = paste0("CORINE Land Cover – ", city)) +

    theme_minimal(base_size = 12) +
    theme(
      panel.background = element_rect(fill = "#E5E5E5", color = NA),
      plot.margin      = margin(20, 40, 40, 20),
      plot.title       = element_text(face = "bold", size = 16),
      legend.position  = "right",
      legend.title     = element_text(face = "bold"),
      legend.key.size  = unit(0.4, "cm"),
      legend.text      = element_text(size = 9)
    )

  return(p)
}
  
  
  
  
  
