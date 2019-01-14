#**************************************************************
# this creates a new data file collapsing across challenges into episodes

library(readr)
library(dplyr)
library(stringr)
library(tidyr)

#**************************************************************
# read in input files
challenge_results <- read_csv(here::here("data-raw", "challenge_results.csv"))

# get sums for each episode
collapse_by_episode <- challenge_results %>%
  drop_na(result) %>%
  group_by(series, episode) %>%
  summarize(bakers_appeared = n(),
            bakers_out = sum(result %in% c("OUT", "LEFT", "RUNNER-UP"), na.rm = TRUE),
            bakers_remaining = bakers_appeared - bakers_out,
            star_bakers = sum(result == "STAR BAKER", na.rm = TRUE),
            technical_winners = sum(technical == 1, na.rm = TRUE)) %>%
  ungroup()

# get star bakers names only
sb_bakers <- challenge_results %>%
  filter(result == "STAR BAKER") %>%
  select(series, episode, sb_name = baker) %>%
  group_by(series, episode) %>%
  summarise(sb_name = paste(sb_name, collapse = ", ")) %>%
  ungroup()

# get series winner final bakes only
winners <- challenge_results %>%
  filter(result == "WINNER") %>%
  select(series, episode, winner_name = baker) %>%
  ungroup()

# get out bakes only
out_bakers <- challenge_results %>%
  filter(result %in% c("LEFT", "OUT")) %>%
  select(series, episode, eliminated_name = baker) %>%
  group_by(series, episode) %>%
  summarise(eliminated = paste(eliminated_name, collapse = ", ")) %>%
  ungroup()

bakes <- sb_bakers %>%
  full_join(winners) %>%
  full_join(out_bakers)

# merge in
episode_results <- collapse_by_episode %>%
  left_join(bakes)

## dataframe to csv
write_csv(episode_results, here::here("data-raw", "episode_results.csv"))

# end of exports
usethis::use_data(episode_results, overwrite = TRUE)


