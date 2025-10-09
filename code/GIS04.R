#raster data

if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
               stars)

(spr_ex <- rast("data/spr_example.tif"))

# overwrite = TRUE enables overwriting
writeRaster(x = spr_ex, 
            filename = "data/spr_elev.tif",
            overwrite = TRUE)

ggplot() +
  geom_spatraster(data = spr_ex)

star_ex <- st_as_stars(spr_ex)
mapview(star_ex)

v_elev <- values(spr_ex)
head(v_elev)

na.omit(v_elev) %>% 
  mean()

#Continuous
extract(spr_ex, #rater layer
        y = cbind(6.0000, 50.0000)) #where we get data from, long lat

(df_point <- tibble(lon = c(6, 5.9), lat = c(50, 49.96)))

extract(spr_ex, y = df_point)

## discrete
(spr_for <- rast("data/spr_forest_nc.tif"))

ggplot() +
  geom_spatraster(data = spr_for)

unique(spr_for)

v_binary <- values(spr_for)
(p_forest <- mean(v_binary))

(spr_land <- rast("data/spr_land_reclass.tif"))
unique(spr_land)

extract(spr_land, cbind(-79.8063, 36.0701))

# write a conversion matrix
# left, original value
# right, value after conversion
(cm <- cbind(c(0, 1001, 1010, 1100),
             c(0, 1, 0, 0)))

spr_bin <- classify(spr_land,
                    rcl = cm)

v_bin <- values(spr_bin)
mean(v_bin)

# Exercise ----------------------------------------------------------------

#Q1
(spr_prec_ncne <- rast("data/spr_prec_ncne.tif"))

#Q2
print(spr_prec_ncne)

#Q3
ggplot() +
  geom_spatraster

#Q4
(sf_site <- readRDS("data/sf_finsync_nc.rds"))

df_xy <- st_coordinates(sf_site)

df_land <- extract(spr_land, y = df_xy)
unique(df_land)

#Q5
# write a conversion matrix
# left, original value
# right, value after conversion
(cm <- cbind(c(0, 1001, 1010, 1100),
             c(0, 0, 0, 1)))

spr_urban <- classify(spr_land,
                    rcl = cm)

v_bin <- values(spr_urban)
mean(v_bin)

ggplot() +
  geom_spatraster(data = spr_urban)
