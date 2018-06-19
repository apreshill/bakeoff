#**************************************************************
# this creates a new data file for datacamp with messy baker results

#**************************************************************
# input files
input_baker_results <- "./data-raw/baker_results.csv"
input_challenge_results <- "./data-raw/challenge_results.csv"

#**************************************************************
# output files
out_csv <- "./data-datacamp/02.01_messy_baker_results.csv"

#**************************************************************
# load packages
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(lubridate)

#**************************************************************
# read in input files
baker_results <- read_csv(input_baker_results)

# good for datacamp!! set col_number returns error b/c "N/A" is a character
challenge_results <- read_csv(input_challenge_results)

# I want to include the wrong date formats!!
# solution: create a cross-walk of good airdates with bad ones
# the good ones end with premiere
# the bad ones end with airdate
dates <- challenge_results %>% 
  select(series, episode, contains("date"), uk_premiere) %>% 
  mutate(us_premiere = dmy(us_airdate)) %>% 
  distinct(series, episode, .keep_all = TRUE)

# for uk keep good premiere dates --> first date appeared
# for us use airdate --> first date appeared to keep as character!
first_dates <- dates %>% 
  filter(episode == 1) %>% 
  select(-episode, -uk_airdate, -us_premiere,
         first_date_appeared = uk_premiere, # good one
         first_date_appeared_us = us_airdate) # bad one

# get dates in line
# join with first_dates --> first_date_appeared column
# joint with dates --> last_date_appeared column
messy_baker_results <- baker_results %>% 
  left_join(first_dates) %>% 
  left_join(dates, by = c("series" = "series", 
                          "total_episodes_appeared" = "episode")) %>% 
  select(-ends_with("date_appeared"), -us_premiere, -uk_premiere) %>% 
  rename(last_date_appeared = uk_airdate, # keep bad date
         last_date_appeared_us = us_airdate) %>% 
  replace_na(list(first_date_appeared_us = "not aired in US", 
                  last_date_appeared_us = "not aired in US")) %>% 
  mutate(age = str_c(age, " years")) %>% 
  mutate(aired_us = if_else(!is.na(first_date_us), TRUE, FALSE)) %>% 
  select(series, baker, age, 
         num_episodes = total_episodes_appeared, 
         aired_us, last_date_uk = last_date_appeared,
         occupation, hometown, star_baker, technical_winner,
         series_winner, series_runner_up) 


#**************************************************************
# output files

write_csv(messy_baker_results, out_csv)


