#**************************************************************
# this creates a new data file that untidies episode_results


#**************************************************************
# output files
out_csv <- "./data-datacamp/02.03_messy_ratings.csv"

#**************************************************************
# load packages
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(lubridate)

#**************************************************************
# read in input files

ratings_tidy <- read_csv(here::here("data-raw", "episodes.csv"),
                         na = c("", "NA", "N/A")) %>% 
  select(series, episode, contains("day"), uk_premiere)

untidy_order <- c("series", "e1_viewers_7day", "e1_viewers_28day", 
                  "e2_viewers_7day", "e2_viewers_28day",
                  "e3_viewers_7day", "e3_viewers_28day",
                  "e4_viewers_7day", "e4_viewers_28day", 
                  "e5_viewers_7day", "e5_viewers_28day", 
                  "e6_viewers_7day", "e6_viewers_28day", 
                  "e7_viewers_7day", "e7_viewers_28day", 
                  "e8_viewers_7day", "e8_viewers_28day", 
                  "e9_viewers_7day", "e9_viewers_28day", 
                  "e10_viewers_7day", "e10_viewers_28day",
                  "e1_uk_airdate", "e2_uk_airdate","e3_uk_airdate",
                  "e4_uk_airdate", "e5_uk_airdate", "e6_uk_airdate",
                  "e7_uk_airdate", "e8_uk_airdate", "e9_uk_airdate",
                  "e10_uk_airdate")

# make this 1
ratings_untidy <- ratings_tidy %>% 
  mutate(uk_airdate = as.character(uk_premiere)) %>% 
  select(series, episode, uk_airdate,
         starts_with("viewers")) %>% 
  mutate(episode = str_c("e", episode)) %>% 
  gather(key, value, uk_airdate:viewers_28day, factor_key = TRUE) %>% 
  unite(new_key, episode, key) %>% 
  mutate(new_key = as.factor(new_key)) %>% 
  spread(new_key, value) %>% 
  mutate_at(vars(contains("viewers")), as.numeric) %>% 
  mutate_at(vars(contains("date")), ymd)

ratings_untidy <- ratings_untidy[, untidy_order] 

series <- read_csv(here::here("data-raw", "series.csv"))
ratings_untidy <- series %>% 
  left_join(ratings_untidy)


#**************************************************************
# output files

write_csv(ratings_untidy, out_csv)


