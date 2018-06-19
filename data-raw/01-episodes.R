#**************************************************************
# this reads in the episodes across series

#**************************************************************
# input files
input_us_airdates <- "./data-raw/us_episode_airdates.csv"

#**************************************************************
# output files
out_csv <- "./data-raw/episodes.csv"
out_rda <- "./data/episodes.rda"

#**************************************************************
# load packages
library(rvest)
library(purrr)
library(dplyr)
library(tidyr)
library(readr)
library(stringr)

#**************************************************************
# read in input files
us_airdates <- read_csv(input_us_airdates) 

#**************************************************************
# setup for scraping

url_base <- "https://en.wikipedia.org/wiki/The_Great_British_Bake_Off_(series_%d)"
episodes_start <- c(10, 12, 14, 19, 19, 19, 16, 16)

#**************************************************************
# get the episode data across series

get_episodes <- function(series, episodes_start) {
  
  # simple but effective progress indicator
  cat(c("on your mark...","get set...", "BAKE!", sep = " "))
  
  pages <- read_html(sprintf(url_base, series))
  
  results_table <- pages %>% 
    html_nodes(xpath = '//*[@id="mw-content-text"]/div/table') %>% 
    html_table(fill = TRUE, header = FALSE) %>% 
    .[[episodes_start]]
}

# bind them all together in one list
episodes <- map2(.x = 1:8, .y = episodes_start, .f = get_episodes)

#**************************************************************
# work now with the episodes list 

# make into a dataframe
episodes_df <- map_df(episodes, bind_rows, .id = "series") 

# work with just a few series with common column names
new_colnames <- c("series", "episode", "airdate", "viewers_7day", 
                  "weekly_ranking_network", "weekly_ranking_all_channels")
first_five_series <- episodes_df %>% 
  filter(series %in% c(1:5)) %>% 
  select(series:X5) %>% 
  set_names(~new_colnames) %>% 
  filter(!episode == "Episode\nno.")

# work with just a few series with common column names
new_colnames <- c("series", "episode", "airdate", "viewers_7day", "viewers_28day",
                  "weekly_ranking_network", "weekly_ranking_all_channels",
                  "bbc_iplayer_requests")
last_three_series <- episodes_df %>% 
  filter(series %in% c(6:8)) %>% 
  set_names(~new_colnames) %>% 
  filter(!episode == "Episode\nno.")
  
# join together
all_episodes <- first_five_series %>% 
  full_join(last_three_series) %>% 
  separate(bbc_iplayer_requests, into = "bbc_iplayer_requests", extra = "drop", sep = "\\[") %>% 
  separate(airdate, into = c("uk_airdate", "uk_premiere"), sep = "\\(", remove = FALSE) %>% 
  mutate(uk_premiere = str_replace(uk_premiere, "\\)", ""),
         uk_airdate = str_replace_all(uk_airdate, "\\W", " "), # gets rid of weird ascii
         series = as.integer(series),
         episode = as.integer(episode))

# now add us airdates
all_episodes <- all_episodes %>% 
  left_join(us_airdates)

#**************************************************************
# output files

write_csv(all_episodes, out_csv)
save(all_episodes, file = out_rda)
