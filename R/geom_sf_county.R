compute_county <- function(data, scales, state = NULL, county = NULL){


  if(!is.null(state)){

    state %>% tolower() -> state

    reference_fips_full %>%
      dplyr::filter(.data$state_name %in% state) ->
      reference_fips_full
  }

  if(!is.null(county)){

    county %>% tolower() -> county

    reference_fips_full %>%
      dplyr::filter(.data$county_name %in% county) ->
      reference_fips_full

  }

  reference_fips_full %>%
    dplyr::select("fips", "geometry", "xmin",
                  "xmax", "ymin", "ymax") ->
    reference_fips_full

  data %>%
    dplyr::inner_join(reference_fips_full) %>%
    dplyr::mutate(group = -1)

}


StatCounty <- ggplot2::ggproto(`_class` = "StatCounty",
                               `_inherit` = ggplot2::Stat,
                               # required_aes = c("fips"), #breaks when required!?
                               # setup_data = my_setup_data,
                               compute_panel = compute_county,
                               default_aes = ggplot2::aes(geometry = ggplot2::after_stat(geometry))
)



#' Title
#'
#' @param mapping
#' @param data
#' @param position
#' @param na.rm
#' @param show.legend
#' @param inherit.aes
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
#' library(ggplot2)
#' us_census |>
#' ggplot() +
#'   coord_sf() +
#'   aes(fips = fips) +
#'   geom_sf_county(state = "Illinois") +
#'   geom_sf_county(state = "Illinois",
#'                  county = c("Cook", "Champaign"),
#'                  color = "red", linewidth = 1) +
#'   aes(fill = mean_work_travel) +
#'   scale_fill_viridis_c(option = "magma")
#'
#' last_plot() +
#'   aes(fill = per_capita_income) +
#'   scale_fill_viridis_c()
geom_sf_county <- function(
  mapping = NULL,
  data = NULL,
  position = "identity",
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE, ...) {
  ggplot2::layer(
    stat = StatCounty,  # proto object from step 2
    geom = ggplot2::GeomSf,  # inherit other behavior
    data = data,
    mapping = mapping,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}



