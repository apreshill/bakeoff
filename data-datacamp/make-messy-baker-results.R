#**************************************************************
# this creates a new data file for datacamp with messy baker results

#**************************************************************
# input files
input_baker_results <- "./data-raw/baker_results.csv"
input_challenge_results <- "./data-raw/challenge_results.csv"

#**************************************************************
# output files
out_csv <- "./data-datacamp/messy_baker_results.csv"

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

# I want to make the results column wide, spread by episode
# clean up results first
challenge_results_clean <- challenge_results %>% 
  mutate(correct_date = uk_premiere, # keep the one formatted correctly
         technical_original = technical,
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
  #select(-airdate1, -airdate2) %>% 
  group_by(series, episode) %>% 
  mutate(total_bakers = sum(!is.na(result))) %>% 
  ungroup() %>% 
  arrange(series, episode)

# get max position reached 
dirty_position_reached <- challenge_results_clean %>% 
  filter(result %in% c("WINNER", "RUNNER UP")) %>% 
  select(series, baker, result_original) %>% 
  mutate(result_original = case_when(
    baker == "Joanne" | baker == "Nadiya" ~ "winner",
    baker == "Sophie" ~ "Winner",
    TRUE ~ as.character(result_original)
  )) %>% 
  rename(position_reached = result_original)

# now lets spread!
wide_bakers <- challenge_results_clean %>% 
  mutate(episode = formatC(episode, width = 2, 
                           format = "d", flag = "0")) %>% 
  select(series, episode, baker, result, signature, technical, showstopper) %>%
  gather(key, value, result:showstopper) %>% 
  unite(e, episode, key) %>% 
  spread(e, value, sep = "_") 



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
         first_date_appeared_uk = uk_premiere, # good one
         first_date_appeared_us = us_airdate) # bad one

# get dates in line
# join with first_dates --> first_date_appeared column
# joint with dates --> last_date_appeared column
messy_baker_results <- baker_results %>% 
  left_join(wide_bakers) %>% #all the e_#_ junk
  left_join(first_dates) %>% 
  left_join(dates, by = c("series" = "series", 
                          "total_episodes_appeared" = "episode")) %>% 
  select(-ends_with("date_appeared"), -us_premiere, -uk_airdate) %>% 
  rename(last_date_appeared_uk = uk_premiere, # keep good
         last_date_appeared_us = us_airdate) %>% 
  replace_na(list(first_date_appeared_us = "not aired in US", 
                  last_date_appeared_us = "not aired in US")) 

# general clean up (or mess up really)
messy_baker_results <- messy_baker_results %>% 
  left_join(dirty_position_reached) %>% 
  mutate(age = str_c(age, " years")) %>% 
  select(series, 
         starts_with("baker"), age, occupation, hometown, 
         position_reached, star_baker, starts_with("technical"), 
         starts_with("series_"), 
         contains("episodes"), contains("percent"), contains("_uk"), contains("_us"),
         starts_with("e_"))


#**************************************************************
# output files

write_csv(messy_baker_results, out_csv)

#**************************************************************
# alternative file exports
openxlsx::write.xlsx(messy_baker_results, 
                     file = "./data-datacamp/messy_baker_results.xlsx")
haven::write_sav(messy_baker_results, 
                 path = "./data-datacamp/messy_baker_results.sav")
