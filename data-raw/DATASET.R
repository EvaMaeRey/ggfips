## code to prepare `DATASET` dataset goes here

library(tidyverse)
library(sf)
#> Linking to GEOS 3.8.1, GDAL 3.2.1, PROJ 7.2.1

fips_geometries <- readRDS(url("https://wilkelab.org/SDS375/datasets/US_counties.rds")) %>%
  rename(FIPS = GEOID) %>%
  janitor::clean_names()

us_census <- read_csv("https://wilkelab.org/SDS375/datasets/US_census.csv",
                      col_types = cols(FIPS = "c")
) %>%
  janitor::clean_names()

# from Claus Wilke on ggplot2
fips_geometries %>%
  left_join(us_census, by = "fips") %>%
  ggplot() +
  geom_sf(aes(fill = mean_work_travel,
              fips = fips), # a bug or a feature?
          linewidth = .1) +
  scale_fill_viridis_c(option = "magma") ->
  classic_plot_sf_layer

classic_plot_sf_layer

layer_data(classic_plot_sf_layer) %>%
  select(fips, geometry, xmin, xmax, ymin, ymax) ->
  reference_fips

reference_fips %>%
  left_join(fips_geometries) %>%
  mutate(name = tolower(name)) %>%
  mutate(name_2 = tolower(name_2)) %>%
  rename(county_name = name) %>%
  rename(state_name = name_2) ->
reference_fips_full



usethis::use_data(us_census, overwrite = T)
usethis::use_data(reference_fips, overwrite = T)
usethis::use_data(reference_fips_full, overwrite = TRUE)
