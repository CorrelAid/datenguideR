#' @title dg_map
#' @description Produce a map filled with variables queried by \code{dg_call}
#' @param lookup The method used to find the shapefile to use as the electoral background. Defaults to GADM
#' @param return_data Return merged data instead of plot
#' @param b_color Specify the border color
#' @param nuts_nr The NUTS level for the country shapefiles to download from GADM. Requires GADM to be the lookup method
#' @param stat_name Character string containing the name of the main statistic. Please see dg_descriptions for a full list.
#' @param substat_name Character string containing the name of the sub-statistic. Please see dg_descriptions for a full list. Defaults to all available sub-statistics if not specified.
#' @param parameter Character string containing the name(s) of the parameter(s) you want to retrieve. Please see dg_descriptions for a full list. Defaults to all available parameters if not specified.
#' @param year Numeric year(s) for which you want to retrieve the data.
#'
#' @examples
#' \dontrun{
#' turnout_map <- dg_map(
#'   nuts_nr = 1,
#'   year = 2017,
#'   stat_name = "AI0506"
#' )
#' }
#' @export
dg_map <- function(lookup = "GADM3",
                   b_color = "white",
                   nuts_nr = 1,
                   stat_name = NULL,
                   substat_name = NULL,
                   year = NULL,
                   parameter = NULL,
                   return_data = FALSE) {
  if (nuts_nr == 3) {
    stop("NUTS-3 is not supported at the moment")
  }

  if (!(nuts_nr %in% 1:2)) {
    stop("Wrong NUTS Level.")
  }

  country <- "DEU"

  # get the electoral shape files
  if (grepl("GADM", lookup) & nuts_nr == 1) {
    # download a matching country shapefile from GADM and open it
    if (lookup == "GADM2") {
      admin_url <- paste0("https://biogeo.ucdavis.edu/data/gadm2.8/rds/", paste0(country, "_adm", nuts_nr, ".rds"))
    } else if (lookup == "GADM3") {
      admin_url <- paste0("https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_", paste0(country, "_", nuts_nr, "_sf.rds"))
    } else {
      warning("Did you specify either GADM2 or GADM3 as lookup?")
    }

    temp_dir <- tempdir()
    utils::download.file(admin_url, destfile = file.path(temp_dir, "shapefiles.rds"), mode = "wb")

    admin_shape <- sf::st_as_sf(readRDS(file.path(temp_dir, "shapefiles.rds")))
  }

  if (nuts_nr == 2) {
    nuts2_url <- "https://daten.gdz.bkg.bund.de/produkte/vg/nuts250_1231/aktuell/nuts250_12-31.utm32s.shape.zip"

    temp_dir <- tempdir()
    temp <- tempfile(fileext = ".zip")
    utils::download.file(
      "https://daten.gdz.bkg.bund.de/produkte/vg/nuts250_1231/aktuell/nuts250_12-31.utm32s.shape.zip",
      temp
    )
    utils::unzip(temp, exdir = temp_dir)
    admin_shape <- sf::st_read(paste0(temp_dir, "/nuts250_2018-12-31.utm32s.shape/nuts250/250_NUTS2.shp"))
  }


  if (nuts_nr == 1) {
    dg_dat <- dg_call(
      stat_name = stat_name,
      year = year,
      substat_name = substat_name,
      parameter = parameter,
      nuts_nr = nuts_nr
    ) %>%
      dplyr::rename(NAME_1 = name) %>%
      dplyr::mutate(NAME_1 = stringr::str_remove(NAME_1, ", Land"))

    shape_map <- admin_shape %>%
      dplyr::left_join(dg_dat, by = "NAME_1")
  }


  if (nuts_nr == 2) {
    dg_dat <- dg_call(
      stat_name = stat_name,
      year = year,
      substat_name = substat_name,
      parameter = parameter,
      nuts_nr = nuts_nr
    ) %>%
      dplyr::rename(NUTS_NAME = name) %>%
      dplyr::mutate(NUTS_NAME = stringr::str_remove_all(NUTS_NAME, ", Regierungsbezirk")) %>%
      dplyr::mutate(NUTS_NAME = stringr::str_remove_all(NUTS_NAME, ", Stat. Region")) %>%
      dplyr::mutate(NUTS_NAME = as.factor(NUTS_NAME))

    shape_map <- admin_shape %>%
      dplyr::left_join(dg_dat, by = "NUTS_NAME")
  }

  if (return_data) {
    return(shape_map)
  }

  # plot the map
  map <-
    ggplot2::ggplot() +
    ggplot2::geom_sf(data = shape_map, ggplot2::aes(fill = value), colour = b_color)

  return(map)
}
