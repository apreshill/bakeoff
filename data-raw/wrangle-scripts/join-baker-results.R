## this script joins bakers and challenge_results
## by shared keys: series / baker

library(readr)
library(dplyr)
library(stringr)
library(lubridate)
library(tidyr)

## for baker info
bakers <- read_csv(here::here("data-raw", "bakers.csv"))

## for airdates
dates <- read_csv(here::here("data-raw", "ratings_seasons.csv"))

# add total bakers
challenge_results <- read_csv(here::here("data-raw",
                                         "challenge_results.csv")) %>%
  group_by(series, episode) %>%
  mutate(total_bakers = sum(!is.na(result))) %>%
  ungroup() %>%
  arrange(series, episode) %>%
  left_join(select(dates, series, episode, ends_with("airdate")))

# get summaries for each outcome
collapse_by_baker <- challenge_results %>%
  drop_na(result) %>%
  group_by(series, baker) %>%
  summarize(star_baker = sum(result == "SB", na.rm = TRUE),
            technical_winner = sum(technical == 1, na.rm = TRUE),
            technical_top3 = sum(technical %in% c(1:3), na.rm = TRUE),
            technical_bottom = sum(technical > 3, na.rm = TRUE),
            technical_highest = min(technical, na.rm = TRUE),
            technical_lowest = max(technical, na.rm = TRUE),
            technical_median = median(technical, na.rm = TRUE),
            series_winner = sum(result == "WINNER", na.rm = TRUE),
            series_runner_up = sum(result == "RUNNER UP", na.rm = TRUE),
            total_episodes_appeared = max(episode, na.rm = TRUE),
            first_date_appeared = min(uk_airdate),
            last_date_appeared = max(uk_airdate),
            first_date_us = min(dmy(us_airdate)),
            last_date_us = max(dmy(us_airdate))) %>%
  ungroup() %>%
  group_by(series) %>%
  mutate(total_episodes_series = max(total_episodes_appeared)) %>%
  ungroup() %>%
  mutate(percent_episodes_appeared = 100*total_episodes_appeared/total_episodes_series,
         percent_technical_top3 = 100*technical_top3/total_episodes_appeared) %>%
  mutate(technical_highest = case_when(
    is.infinite(technical_highest) ~ 10000,
    TRUE ~ technical_highest
  ),
  technical_lowest = case_when(
    is.infinite(technical_lowest) ~ 10000,
    TRUE ~ technical_lowest
  )) %>%
  na_if(10000)

# merge
baker_results <- collapse_by_baker %>%
  left_join(bakeoff::bakers %>% mutate(series = as.numeric(series))) %>%
  select(everything(), -total_episodes_series)

#**************************************************************
# output files

write_csv(baker_results, "baker_results.csv")
usethis::use_data(baker_results, overwrite = TRUE)
