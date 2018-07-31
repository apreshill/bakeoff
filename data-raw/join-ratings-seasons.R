## this script joins ratings and seasons
## by shared keys: series / episode

library(readr)
library(dplyr)
library(stringr)
library(lubridate)
library(bakeoff)

ratings_seasons <- ratings %>%
  left_join(seasons)

## dataframe to csv
write_csv(ratings_seasons, here::here("data-raw", "ratings_seasons.csv"))

# end of exports
usethis::use_data(ratings_seasons, overwrite = TRUE)
