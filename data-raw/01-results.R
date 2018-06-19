#**************************************************************
# this reads in the results tables per episode across series

#**************************************************************
# output files
out_csv <- "./data-raw/results.csv"
out_rda <- "./data/results.rda"

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

#**************************************************************
# get the episode results across series

get_results <- function(series) {
  
  # simple but effective progress indicator
  cat(c("on your mark...","get set...", "BAKE!", sep = " "))
  
  pages <- read_html(sprintf(url_base, series))

  results_table <- pages %>% 
    html_nodes(xpath = '//*[@id="mw-content-text"]/div/table') %>% 
    html_table(fill = TRUE, header = FALSE) %>% 
    .[[3]] 
}

# bind them all together in one list
results_table <- map(.x = 1:8, .f = get_results)

#**************************************************************
# work now with the results list 

# make a dataframe, keep series number
results_df <- map_df(results_table, bind_rows, .id = 'series') 

# tons of wrangling here
results_df_clean <- results_df %>% 
  select(series,
         baker = X1,
         episode_ = X2:X11) %>% 
  filter(!episode_1 %in% c("Elimination chart", "1")) %>% 
  gather(episode, result, -series, -baker) %>% 
  separate(episode, into = c("drop", "episode")) %>% 
  select(series, episode, baker, result) %>% 
  mutate(series = as.integer(series),
         episode = as.integer(episode),
         baker = ifelse(series == 2 & baker == "Jo", "Joanne", baker)) %>% 
  arrange(series, baker, episode) %>% 
  drop_na(result)  # this gets rid of episodes that don't apply to that series

results_df_clean2 <- results_df_clean %>% 
  mutate(gone = case_when(
    result == "OUT" ~ "OUT", 
    result == "LEFT" ~ "LEFT",
    is.na(result) ~ NA_character_)) %>% 
  group_by(series, baker) %>% 
  fill(gone, .direction = c("down")) %>% 
  mutate_all(funs(na_if(., ""))) %>% 
  mutate(new_result = coalesce(result, gone)) %>% 
  replace_na(list(new_result = "IN")) %>% 
  mutate(new_result2 = case_when(
    new_result == "OUT" & lag(new_result) == "OUT" ~ NA_character_,
    new_result == "LEFT" & lag(new_result) == "LEFT" ~ NA_character_,
    TRUE ~ new_result)) %>% 
  select(series, episode, baker, result = new_result2)

#**************************************************************
# export final files
write_csv(results_df_clean2, out_csv)
save(results_df_clean2, file = out_rda)
