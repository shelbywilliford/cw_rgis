
if(!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse)

set.seed(123)

iris_sub <- as_tibble(iris) %>% 
  group_by(Species) %>% 
  sample_n(3) %>% 
  ungroup()

print(iris_sub)


# undergrad ---------------------------------------------------------------

## row manipulation
# work 5.1.1 & 5.1.2
filter(iris_sub,
       Species == "virginica")

filter(iris_sub,
       Species %in% c("virginica", "versicolor"))

filter(iris_sub,
       Species != "virginica")

filter(iris_sub,
       !(Species %in% c("virginica", "versicolor")))

filter(iris_sub, 
       Sepal.Length > 5)

filter(iris_sub, 
       Sepal.Length >= 5)

filter(iris_sub, 
       Sepal.Length < 5)

filter(iris_sub, 
       Sepal.Length <= 5)

# Sepal.Length is less than 5 AND Species equals "setosa"
filter(iris_sub,
       Sepal.Length < 5 & Species == "setosa")

# same; "," works like "&"
filter(iris_sub,
       Sepal.Length < 5, Species == "setosa")

# Either Sepal.Length is less than 5 OR Species equals "setosa"
filter(iris_sub,
       Sepal.Length < 5 | Species == "setosa")

# arrange
arrange(iris_sub,
        Sepal.Length)

arrange(iris_sub,
        desc(Sepal.Length))

## column manipulation
select(iris_sub,
       Sepal.Length)

select(iris_sub,
       c(Sepal.Length, Sepal.Width))

select(iris_sub,
       -Sepal.Length)

select(iris_sub,
       -c(Sepal.Length, Sepal.Width))

## adding new columns
# nrow() returns the number of rows of the dataframe
(x_max <- nrow(iris_sub))

x <- 1:x_max
mutate(iris_sub, row_id = x)
mutate(iris_sub, sl_two_times = 2 * Sepal.Length)

## piping
# iris_setosa <- filter(iris_sub, Species == "setosa")
# iris_num <- select(iris_setosa, -Species)

# the following code is identical to above 2 lines of codes
iris_num <- iris_sub %>% 
  filter(Species == "setosa") %>% 
  select(-Species)

# graduate students -------------------------------------------------------

library(swirl)
install_course_github("sysilviakim", "swirl-tidy")
swirl()


# exercise ----------------------------------------------------------------

# exercise 1 filter `iris_sub` to contain only "virginica"

filter(iris_sub, Species == "virginica")

# exercise 2 select column "Sepal.Width" in `iris_sub` 

select(iris_sub, Sepal.Width)

# exercise 3 filter `iris_sub` to contain only "virginica",
# then, pipe to select "Sepal.Width"
# then, pipe to create a new column "sw3" that is a triple of values in Sepal.Width
# assign to "df0"

df0 <- iris_sub %>% 
  filter(Species == "virginica") %>% 
  select(Sepal.Width) %>% 
  mutate(sw3 = 3 * Sepal.Width)

## group operation

# calculate mean
m <- mean(c(2, 5, 8))
s <- sum(c(2, 5, 8))

m_large <- mean(1:1000)
s_large <- sum(1:1000)

mean(iris_sub$Sepal.Length)

# group_by() function
df_summary <- iris_sub %>% 
  group_by(Species) %>% 
  summarize(mean_sl = mean(Sepal.Length),
            sum_sl = sum(Sepal.Length),
            mean_pl = mean(Petal.Length), # calculate the mean of Petal.Length
            sum_pl = sum(Petal.Length)) # calculate the sum of Petal.Length


## join
df1 <- tibble(Species = c("A", "B", "C"),
              x = c(1, 2, 3))

df2 <- tibble(Species = c("A", "B", "C"),
              y = c(10, 12, 13))

left_join(x = df1,
          y = df2,
          by = "Species")

df2_minus_c <- tibble(Species = c("A", "B"),
                      y = c(10, 12))

left_join(x = df1,
          y = df2_minus_c,
          by = "Species")
