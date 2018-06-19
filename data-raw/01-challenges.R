#**************************************************************
# this reads in the episode challenges across series
# weird/tricky: flattening the challenges tables removes episode number (per series), it only keeps a cumulative episode count, so there is some hacky stuff to get episode number per series
# better ways? probably!

#**************************************************************
# output files
out_csv <- "./data-raw/challenges.csv"
out_rda <- "./data/challenges.rda"

#**************************************************************
# load packages
library(rvest)
library(purrr)
library(dplyr)
library(tidyr)
library(readr)

#**************************************************************
# setup

url_base <- "https://en.wikipedia.org/wiki/The_Great_British_Bake_Off_(series_%d)"
max_episodes <- c(6, 8, 10, 10, 10, 10, 10, 10) + 3
new_colnames <- c("baker", "signature", "technical", "showstopper")

#**************************************************************
# get the episode challenges across series

get_challenges <- function(series, max_episodes) {
  
  # simple but effective progress indicator
  cat(c("on your mark...","get set...", "BAKE!", sep = " "))
  
  pages <- read_html(sprintf(url_base, series))
  
  series_table <- pages %>% 
    html_nodes(xpath = '//*[@id="mw-content-text"]/div/table') %>% 
    html_table(fill = TRUE) %>% 
    .[4:max_episodes] %>% 
    map(~set_names(., new_colnames)) %>% 
    map(mutate, series = series) 
}


challenges <- map2(.x = 1:8, .y = max_episodes, .f = get_challenges)

#**************************************************************
# work now with the challenges list 

# this counts each episode, not by series
challenges_df <- flatten_df(challenges, .id = "episode_count") %>% 
  mutate(episode_count = as.integer(episode_count))

# add episode counts
challenges_df <- challenges_df %>% 
  arrange(series, episode_count, baker) %>% 
  group_by(series, baker) %>% 
  mutate(episode = row_number()) %>% 
  select(series, episode, baker, everything(), -episode_count) %>% 
  ungroup() %>% 
  mutate(baker = ifelse(series == 2 & baker == "Jo", "Joanne", baker))


#**************************************************************
# export final files 
write_csv(challenges_df, out_csv)
save(challenges_df, file = out_rda)
