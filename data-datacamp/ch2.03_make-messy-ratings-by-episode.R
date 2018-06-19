#**************************************************************
# this creates a new data file that merges episode_results and episodes

#**************************************************************
# input files
input_ratings <- "./data-raw/episode_results.csv"
input_episodes <- "./data-raw/episodes.csv"

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
ratings <- read_csv(input_ratings,
                    col_types = cols(
                      us_airdate = col_date(format = "%d-%b-%y")
                    )) 

episodes <- read_csv(input_episodes,
                     na = c("", "NA", "N/A"),
                     col_types = cols(
                       us_airdate = col_date(format = "%d-%b-%y")
                     )) %>% 
  select(-uk_airdate, -airdate)

ratings <- ratings %>% 
  left_join(episodes) 

#**************************************************************
# output files

write_csv(ratings, out_csv)


