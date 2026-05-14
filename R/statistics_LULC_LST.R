statistics_LULC_LST <- function(lulc_data, lst_result) {

  clc_masked         <- lulc_data$clc_masked
  clc_lookup_present <- lulc_data$clc_lookup_present
  LST                <- lst_result$LST
  city               <- lst_result$city
  date               <- lst_result$date 


  clc_resamp <- terra::resample(
    terra::project(clc_masked, terra::crs(LST)),
    LST,
    method = "near"
  )

  df <- data.frame(
    lst    = terra::values(LST)[, 1],
    clc_id = terra::values(clc_resamp)[, 1]
  ) |>
    stats::na.omit() |>
    dplyr::left_join(clc_lookup_present, by = "clc_id")


  p <- ggplot(df, aes(x = reorder(label, lst, median), y = lst, fill = label)) +
    geom_boxplot(outlier.size = 0.3) +
    scale_fill_manual(values = setNames(clc_lookup_present$color, clc_lookup_present$label)) +
    coord_flip() +
    labs(
      title = paste0("LST by Land Use Class – ", city, " (", date, ")"),
      x     = NULL,
      y     = "LST (°C)"
    ) +
    theme_minimal(base_size = 12) +
    theme(
      legend.position = "none",
      plot.title      = element_text(face = "bold", size = 14)
    )

  return(p)
}


