#**************************************************************
# this creates a new data file collapsing across challenges into episodes

#**************************************************************
# input files
input_challenge_results <- "./data-raw/challenge_results.csv"

#**************************************************************
# output files
out_csv <- "./data-raw/episode_results.csv"
out_rda <- "./data/episode_results.rda"

#**************************************************************
# load packages
library(readr)
library(dplyr)
library(stringr)
library(tidyr)

#**************************************************************
# read in input files
challenge_results <- read_csv(input_challenge_results)

# clean up results for top 3
challenge_results_clean <- challenge_results %>% 
  mutate(technical_original = technical,
         technical = str_extract(technical, "\\d+"),
         result_original = result,
         result = case_when(
           result == "Runner up" ~ "RUNNER UP",
           result == "Runner Up" ~ "RUNNER UP",
           result == "Runner-Up" ~ "RUNNER UP",
           result == "Third Place" ~ "RUNNER UP",
           TRUE ~ as.character(result)
           )
         )  %>% 
  select(-uk_airdate)

# get sums for each episode
collapse_by_episode <- challenge_results_clean %>% 
  drop_na(result) %>% 
  group_by(series, episode, uk_premiere, us_season, us_airdate) %>% 
  summarize(bakers_appeared = n(),
            bakers_out = sum(result %in% c("OUT", "LEFT", "RUNNER UP"), na.rm = TRUE),
            bakers_remaining = bakers_appeared - bakers_out,
            star_bakers = sum(result == "SB", na.rm = TRUE),
            technical_winners = sum(technical == 1, na.rm = TRUE))

# get star bakers names only
sb_bakers <- challenge_results_clean %>% 
  filter(result == "SB") %>% 
  select(series, episode, sb_name = baker) %>%
  group_by(series, episode) %>%
  summarise(sb_name = paste(sb_name, collapse = ", "))

# get series winner final bakes only
winners <- challenge_results_clean %>%  
  filter(result == "WINNER") %>% 
  select(series, episode, winner_name = baker)

# get out bakes only
out_bakers <- challenge_results_clean %>% 
  filter(result %in% c("LEFT", "OUT")) %>% 
  select(series, episode, eliminated_name = baker) %>%
  group_by(series, episode) %>%
  summarise(eliminated = paste(eliminated_name, collapse = ", "))

bakes <- sb_bakers %>% 
  full_join(winners) %>% 
  full_join(out_bakers)

# merge in
collapse_by_episode2 <- collapse_by_episode %>% 
  left_join(bakes) 

#**************************************************************
# output files

write_csv(collapse_by_episode2, out_csv)
save(collapse_by_episode2, file = out_rda)


