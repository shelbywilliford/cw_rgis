#Akira's GIS Course- 9/18

if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview, 
               here)

#Read data
df_fish <- read_csv(here::here("data/data_finsync_nc.csv"))

#Map time
sf_site <- df_fish %>% 
  distinct(site_id, lon, lat) %>% # get unique combinations of longitude & latitude
  st_as_sf(coords = c("lon", "lat"), #x-axis first
           crs = 4326)
print(sf_site)

class(sf_site)

#map
mapview(sf_site,
        legend = FALSE)

#Export data
saveRDS(sf_site, #data
        file = here::here("data/sf_finsync_nc.rds")) #file location and name 

#CRS transformation
sf_ft_wgs <- sf_site %>% 
  slice(c(1, 2))

print(sf_ft_wgs)

sf_ft_utm <- sf_ft_wgs %>% 
  st_transform(crs = 32617)

print(sf_ft_utm)

mapview(sf_ft_utm)
st_distance(sf_ft_utm)

#Exercise
data("quakes")

df_quakes <- as.tibble(quakes)

sf_quakes <- quakes %>% 
  distinct(depth, mag, stations, long, lat) %>% # get unique combinations of longitude & latitude
  st_as_sf(coords = c("long", "lat"), #x-axis first
           crs = 4326)

mapview(sf_quakes,
        legend = FALSE)

sf_ft_quakes <- sf_quakes %>% 
  slice(c(1, 2))

print(sf_ft_quakes)

sf_ft_utm_quakes <- sf_ft_quakes %>% 
  st_transform(crs = 32760)

print(sf_ft_utm_quakes)

mapview(sf_ft_utm_quakes)
st_distance(sf_ft_utm_quakes)

saveRDS(sf_quakes, file = "data/sf_quakes.rds")
