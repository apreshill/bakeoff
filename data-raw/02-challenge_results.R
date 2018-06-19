#**************************************************************
# this creates a new data file combining 2 input sources

#**************************************************************
# input files
input_challenges <- "./data-raw/challenges.csv"
input_results <- "./data-raw/results.csv"
input_episodes <- "./data-raw/episodes.csv"

#**************************************************************
# output files
out_csv <- "./data-raw/challenge_results.csv"
out_rda <- "./data/challenge_results.rda"

#**************************************************************
# load packages
library(readr)
library(dplyr)

#**************************************************************
# read in input files
challenges <- read_csv(input_challenges) 
results <- read_csv(input_results)
episodes <- read_csv(input_episodes) %>% 
  select(series, episode, uk_airdate, uk_premiere, us_season, us_airdate)

#**************************************************************
# merge files
# Challenges is missing NA values for Diana, Series 5, episode 5 (she left)
challenge_results <- results %>% 
  full_join(challenges) %>% 
  left_join(episodes) %>% 
  arrange(series, episode, result)

#**************************************************************
# export final files
write_csv(challenge_results, out_csv)
save(challenge_results, file = out_rda)
