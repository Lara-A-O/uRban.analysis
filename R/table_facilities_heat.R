#' @title Table of vulnerable facilities in LST hotspots
#' @description Retrieves vulnerable facilities within LST hotspots for a city
#' and returns a table with facility name and type. Facilities are retrieved
#' automatically via OSM. OSM data may be incomplete for some facility types.
#'
#' @param lst_result List. Result of `get_LST()`
#' @param percentile Numeric. Hotspot threshold (e.g. 0.9 = the upper 10% are being considered)
#'
#' @examples 
#' \dontrun{
#' table_facilities(
#'   lst_result = result,
#'   percentage = 0.10
#' )
#' }
#'
#' @return A data frame with facility category and name.
#' @export

table_facilities <- function(lst_result, percentile = 0.9) {

  LST  <- lst_result$LST
  city <- lst_result$city

  #Treshold for the definition of hotspot 
  hotspot_threshold <- terra::global(LST, fun = quantile,
                                     probs = percentile,
                                     na.rm = TRUE)[1, 1]

  # every value below the treshold is not considered
  hotspot_raster <- terra::ifel(LST >= hotspot_threshold, 1, NA)

# The hotspot raster is transformed into polygons and transformed to EPSG:4326 to match the following OSM query 
  hotspot_poly <- terra::as.polygons(hotspot_raster) |>
    sf::st_as_sf() |>
    sf::st_transform(4326)
  
# Also the used  boundary is being transformed to the same coordinate system 
  boundary_4326 <- sf::st_transform(lst_result$boundary, 4326)
 
# Lookup List for the OSM query
  osm_tags <- list(
    "Nursing home"       = list(key = "amenity", value = "social_facility",
                              extra_key = "social_facility", extra_value = "assisted_living"),
    "Assistance for people with disabilities" = list(key = "amenity", value = "social_facility",
                              extra_key = "social_facility", extra_value = "group_home"),
    "Youth Services"      = list(key = "amenity", value = "social_facility",
                              extra_key = "social_facility", extra_value = "youth"),
    "Hospice"           = list(key = "amenity", value = "hospice"),
    "Kindergarden"             = list(key = "amenity", value = "kindergarten"),
    "Hospital"           = list(key = "amenity", value = "hospital"),
    "School"           = list(key = "amenity", value = "school")
  )
# fetching all the defined categories within the boundary of the city 
  fetch_facilities <- function(category, tag) {
    tryCatch({
      # Build an overpass query for the given tag 
      q <- osmdata::opq(bbox = sf::st_bbox(boundary_4326))
      
      # Add main and optional sub-tag
      if (!is.null(tag$extra_key)) {
        q <- osmdata::add_osm_feature(q, key = tag$key, value = tag$value) |>
          osmdata::add_osm_feature(key = tag$extra_key, value = tag$extra_value)
      } else {
        q <- osmdata::add_osm_feature(q, key = tag$key, value = tag$value)
      }
      #Retrieves the OSM data as sf objects 
      result_osm <- osmdata::osmdata_sf(q)

      # Polygons and points are extracted 
      pts   <- result_osm$osm_points
      polys <- result_osm$osm_polygons

      # Convert polygons to centroids and merge with points
      if (!is.null(polys) && nrow(polys) > 0) {
        polys <- sf::st_centroid(polys)
        pts <- dplyr::bind_rows(pts, polys)
      }
      # If no geometries exist, skip this category
      if (is.null(pts) || nrow(pts) == 0) return(NULL)

      #just facilities with a name are being considered 
      pts <- pts |> dplyr::filter(!is.na(name))
      if (nrow(pts) == 0) return(NULL)

      data.frame(
        category = category,
        name     = as.character(pts$name),
        geometry = sf::st_geometry(pts)
      ) |> sf::st_as_sf()
      

    }, error = function(e) NULL)
  }

  all_facilities <- purrr::map2(names(osm_tags), osm_tags, fetch_facilities) |>
    purrr::compact() |>
    dplyr::bind_rows()
 

  if (nrow(all_facilities) == 0) {
    message("No facilities found within the LST hotspots")
    return(invisible(NULL))
  }

  #Filter: Just Facilities within the hotspots 
  facilities_in_hotspot <- all_facilities |>
    sf::st_transform(sf::st_crs(hotspot_poly)) |>
    sf::st_filter(hotspot_poly)
  
  #Returns a message when there are no facilities within the hotspot
  if (nrow(facilities_in_hotspot) == 0) {
    message("No facilities found within the LST hotspots")
    return(invisible(NULL))
  }

  #Output -> Table with the category and name of each facility remove the geometry
  result_table <- facilities_in_hotspot |>
    sf::st_drop_geometry() |>
    dplyr::select(category, name) |>
    dplyr::arrange(category, name)
  # Geometrie entfernen, nach Kategorie und Name sortieren

  return(result_table)
}