#' @title Calculates and Plots the hot and cool spots 
#' @description Calculates the hottest and coldest pixels of the city and plots them in a ready-to-use map so areas to cool off and  areas where action is needed can be identified 
#'
#' @param lst_result List - Result of the function get_LST() containing the LST, the boundary, the city name and the acquisition date 
#' @param hot_quantile Numeric - Upper quantile treshold to classify hotspots (by default 0.90 = the hottest 10% are being considered)
#' @param cold_quantile Numeric - Lower quantile treshold to classify coldspots (by default = 0.10 = the coldest 10% are being considered)
#' @examples 
#' \dontrun{
#' get_hotcoolspots(
#' lst_result= lst_result, 
#' hot_quantile= 0.95,
#' cold_quantile= 0.05)}
#' 
#' @return Plot of Hot and Cool Spots in the given city at the acquisition date 
#' @importFrom grid unit
#' @export






get_hotcoolspots <- function(lst_result, hot_quantile = 0.90, cold_quantile = 0.10) {

  LST      <- lst_result$LST
  boundary <- lst_result$boundary
  city     <- lst_result$city
  date     <- lst_result$date


  hotspot   <- terra::global(LST, fun = quantile, probs = hot_quantile, na.rm = TRUE)[1,1]
  coldspot  <- terra::global(LST, fun = quantile, probs = cold_quantile, na.rm = TRUE)[1,1]

 
  lst_classified <- terra::ifel(
    LST >= hotspot, 1,
    terra::ifel(LST <= coldspot, -1, 0)
  )

  lst_factor <- terra::as.factor(lst_classified)

  
  levels(lst_factor) <- data.frame(
    value = c(-1, 0, 1),
    label = c("Cold Spot", "Neutral", "Hot Spot")
  )

  # boundary sicher als sf
  boundary_sf <- sf::st_as_sf(boundary)

  # Plot
  p <- ggplot2::ggplot() +
    tidyterra::geom_spatraster(data = lst_factor) +
    ggplot2::scale_fill_manual(
      values = c(
        "Cold Spot" = "#4575b4",
        "Neutral"   = "#f7f7f7",
        "Hot Spot"  = "#d73027"
      ),
      na.value = NA,
      name = "Thermal Class"
    ) +
    ggplot2::geom_sf(data = boundary_sf, fill = NA, color = "black", linewidth = 0.6) +
    ggspatial::annotation_north_arrow(
      location = "tr", which_north = "true",
      height = grid::unit(0.5, "cm"), width = grid::unit(0.5, "cm"),
      pad_x = grid::unit(0.4, "cm"), pad_y = grid::unit(0.5, "cm")
    ) +
    ggspatial::annotation_scale(
      location = "bl", width_hint = 0.3,
      pad_x = unit(0.6, "cm"), pad_y = unit(0.7, "cm"),
      style = "ticks"
    ) +
    ggplot2::labs(title = paste0("Hot- and Coldspot Analysis – ", city),
         subtitle = (date)) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      panel.background = element_rect(fill = "#E5E5E5", color = NA),
      plot.margin = margin(20, 40, 40, 20),
      plot.title = element_text(face = "bold", size = 16),
      legend.position = "right",
      legend.title = element_text(face = "bold"),
      legend.key.size = unit(0.4, "cm"),
      legend.text = element_text(size = 9)
    )

  return(p)
}




