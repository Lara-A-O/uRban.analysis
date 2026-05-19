#' @title Plots the Land Surface Temperature 
#' @description Creates a ready-to-use map of the Land Surface Temperature at the given date, based on the output of `get_LST()`
#'
#' @param lst_result List - Result of the function get_LST() containing the LST, the boundary, the city name and the acquisition date 
#' @examples 
#' \dontrun{
#' LST_plotted (lst_result)}
#' 
#' @return Plot of the Land Surface Temperature 
#' @export




LST_plotted <- function(lst_result) {
  LST      <- lst_result$LST
  boundary <- lst_result$boundary
  city     <- lst_result$city
  date     <- lst_result$date

   p <- ggplot2::ggplot() +
    tidyterra::geom_spatraster(data = LST) +

    scale_fill_distiller(
      palette = "Spectral",
      name = "Temperature (°C)",
      na.value = NA
    ) +

    geom_sf(data = boundary, fill = NA, color = "white", linewidth = 0.6) +

    ggspatial::annotation_north_arrow(
      location = "tr",
      which_north = "true",
      height = unit(0.5, "cm"),
      width  = unit(0.5, "cm"),
      pad_x  = unit(0.4, "cm"),
      pad_y  = unit(0.5, "cm")
    ) +

    ggspatial::annotation_scale(
      location   = "bl",
      width_hint = 0.3,
      pad_x      = unit(0.6, "cm"),
      pad_y      = unit(0.7, "cm"),
      style      = "ticks"
    ) +

    labs(title = paste0("LST of ", city, " at ", date)) +

    theme_minimal(base_size = 12) +
    theme(
      panel.background = element_rect(fill = "#E5E5E5", color = NA),
      plot.margin      = margin(20, 40, 40, 20),
      plot.title       = element_text(face = "bold", size = 16),
      legend.position  = "right"
    )

  return(p)
}
