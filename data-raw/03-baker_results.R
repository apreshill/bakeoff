#**************************************************************
# this creates a new data file collapsing into episodes

#**************************************************************
# input files
input_bakers <- "./data-raw/bakers.csv"
input_challenge_results <- "./data-raw/challenge_results.csv"

#**************************************************************
# output files
out_csv <- "./data-raw/baker_results.csv"
out_rda <- "./data/baker_results.rda"

#**************************************************************
# load packages
library(readr)
library(dplyr)
library(stringr)
library(lubridate)

#**************************************************************
# read in input files
bakers <- read_csv(input_bakers)

# good for datacamp!! set col_number returns error b/c "N/A" is a character
challenge_results <- read_csv(input_challenge_results)


# clean up results for top 3
challenge_results_clean <- challenge_results %>% 
  mutate(technical_original = technical,
         technical = as.numeric(str_extract(technical, "\\d+")),
         result_original = result,
         result = case_when(
           result == "Runner up" ~ "RUNNER UP",
           result == "Runner Up" ~ "RUNNER UP",
           result == "Runner-Up" ~ "RUNNER UP",
           result == "Third Place" ~ "RUNNER UP",
           TRUE ~ as.character(result)
           )
         )  %>% 
  group_by(series, episode) %>% 
  mutate(total_bakers = sum(!is.na(result))) %>% 
  ungroup() %>% 
  arrange(series, episode)

# get summaries for each outcome
collapse_by_baker <- challenge_results_clean %>% 
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
            first_date_appeared = min(uk_premiere),
            last_date_appeared = max(uk_premiere),
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
baker_results <- bakers %>% 
  full_join(collapse_by_baker) %>% 
  select(everything(), -total_episodes_series)

#**************************************************************
# output files

write_csv(baker_results, out_csv)
save(baker_results, file = out_rda)


