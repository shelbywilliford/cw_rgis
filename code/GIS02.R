#Vectors

if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview)


# Read/Save Data ----------------------------------------------------------

# read a shapefile (e.g., ESRI Shapefile format)
# `quiet = TRUE` just for cleaner output
(sf_nc_county <- st_read(dsn = "data/nc.shp",
                         quiet = TRUE))

# save as shapefile (overwrites by setting append = FALSE)
st_write(sf_nc_county, 
         dsn = "data/sf_nc_county.shp",
         append = FALSE)

# save as Geopackage (overwrites by setting append = FALSE)
st_write(sf_nc_county, 
         dsn = "data/sf_nc_county.gpkg",
         append = FALSE)

# save as an RDS file (compact and efficient for use within R)
saveRDS(sf_nc_county,
        file = "data/sf_nc_county.rds")

# read from an RDS file
sf_nc_county <- readRDS(file = "data/sf_nc_county.rds")


# Point Data --------------------------------------------------------------

(sf_site <- readRDS("data/sf_finsync_nc.rds"))

mapview(sf_site,
        col.regions = "black", # point's fill color
        legend = FALSE) # disable legend


# Line Data ---------------------------------------------------------------

(sf_str <- readRDS("data/sf_stream_gi.rds"))

mapview(sf_str,
        color = "steelblue", # line's color
        legend = FALSE) # disable legend


# Polygon -----------------------------------------------------------------

(sf_nc_county <- readRDS("data/sf_nc_county.rds"))

mapview(sf_nc_county,
        col.regions = "blue", # polygon's fill color
        legend = FALSE) # disable legend


# Mapping vectors ---------------------------------------------------------

ggplot() +
  geom_sf(data = sf_nc_county)

ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str)

ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str) +
  geom_sf(data = sf_site)


# Exercise ----------------------------------------------------------------

(sf_str_as <- readRDS("data/sf_stream_as.rds"))

mapview(sf_str_as,
        color = "steelblue", # line's color
        legend = FALSE) # disable legend

print(sf_str_as)
print(sf_nc_county)

(sf_nc_as <- sf_nc_county %>% 
    filter(county == "ashe"))

ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str_as)

ggplot() +
  geom_sf(data = sf_nc_as) +
  geom_sf(data = sf_str_as)

#add label: contr shift r