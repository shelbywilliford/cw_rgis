setwd("C:/Users/shelb/OneDrive - UNCG/UNCG/GitHub/cw_rgis")

if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview,
               here)

# Vector Data Manipulation ------------------------------------------------

sf_site_join <- st_join(x = sf_site, # base layer
                        y = sf_nc_county) # overlaying layer

sf_site_guilford <- sf_site_join %>% 
  filter(county == "guilford")

sf_nc_guilford <- sf_nc_county %>% 
  filter(county == "guilford")

ggplot() +
  geom_sf(data = sf_nc_guilford) +
  geom_sf(data = sf_str) +
  geom_sf(data = sf_site_guilford) +
  theme_bw()

ggplot() +
  geom_sf(data = sf_nc_guilford) +
  geom_sf(data = sf_str,
          color = "steelblue") +
  geom_sf(data = sf_site_guilford,
          color = "salmon") +
  theme_bw()


# Length ------------------------------------------------------------------

(sf_str_proj <- st_transform(sf_str, crs = 32617))

v_str_l <- st_length(sf_str_proj)

# print the first 10 elements
head(v_str_l)

(sf_str_w_len <- sf_str %>% 
    mutate(length = v_str_l))

sf_str_w_len <- sf_str %>% 
  st_transform(crs = 32617) %>%       # transform to projected CRS (utm zone 17n) for accurate length calculation
  mutate(length = st_length(.)) %>%   # calculate length of each feature and store it in a new column
  st_transform(crs = 4326)           # transform back to geographic CRS (wgs84) for consistency with other layers

# # the above code returns identical results with the code below
# sf_str_proj <- st_transform(sf_str, crs = 32617)
# v_str_l <- st_length(sf_str_proj)               
# sf_str <- sf_str %>% 
#   mutate(length = v_str_l)   


# Area --------------------------------------------------------------------

(sf_nc_county_proj <- st_transform(sf_nc_county, crs = 32617))

v_area <- st_area(sf_nc_county)

# print the first 10 elements
head(v_area)

(sf_nc_county_w_area <- sf_nc_county %>% 
    mutate(area = v_area))

(sf_nc_county_w_area <- sf_nc_county %>% 
    st_transform(crs = 32617) %>%       # transform to projected CRS (utm zone 17n) for accurate area calculation
    mutate(area = st_area(.)) %>%       # calculate area of each polygon and store it in a new column
    st_transform(crs = 4326))           # transform back to geographic CRS (wgs84) for consistency with other layers


# Filter by Attributes ----------------------------------------------------

(sf_nc_county_1000 <- sf_nc_county_w_area %>% 
   mutate(area = as.numeric(area) / 1e+6) %>% 
   filter(area > 1000))

ggplot() +
  geom_sf(data = sf_nc_county_1000) +
  theme_bw()


# Exercise ----------------------------------------------------------------

#Q1
sf_nz <- readRDS("data/sf_nz.rds")

mapview(sf_nz) 
mapview(sf_quakes)

sf_quakes_join <- st_join(x = sf_quakes, # base layer
                        y = sf_nz)    # overlaying layer

sf_quakes_nz <- sf_quakes_join %>% 
  drop_na(fid)

nrow(sf_quakes_nz)

#Q2
sf_n_site <- sf_site_join %>% 
  as_tibble() %>% 
  group_by(county) %>%
  summarize(n_site = n())

#Q3
sf_n10 <- sf_n_site %>% 
  filter(n_site > 10)

#Q4
sf_n_map_df <- sf_n_site %>% 
  left_join(sf_nc_county)

sf_nc_n <- sf_nc_county %>% 
  left_join(sf_n_site, 
            by = "county") %>% 
  mutate(n_site = ifelse(is.na(n_site), 0, n_site))

sf_nc_3 <- sf_nc_n %>% 
  filter(n_site >= 3) 

sf_site_3 <- st_join(x = sf_site, # base layer
                        y = sf_nc_3) %>%  # overlaying layer
  drop_na()

ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_site, color = "grey") +
  geom_sf(data = sf_site_3, color = "salmon")
