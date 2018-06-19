#**************************************************************
# this creates a new data file for datacamp with messy ratings per episode/series

#**************************************************************
# input files
input <- "./data-raw/episodes.csv"

#**************************************************************
# output files
out_csv <- "./data-datacamp/messy_ratings.csv"
out2_csv <- "./data-datacamp/messy_ratings2.csv"

#**************************************************************
# load packages
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(lubridate)
library(ggplot2)

#**************************************************************
# read in input files
ratings <- read_csv(input, 
                    na = c("NA", "", "N/A"), 
                    col_types = cols(series = col_factor(levels = NULL))) %>% 
  group_by(series) %>% 
  mutate(total_episodes = max(episode)) %>% 
  ungroup() %>% 
  select(-ends_with("28day")) %>% 
  rename(viewers = viewers_7day)

(ratings_plot <- ratings %>% 
    filter(total_episodes == 10) %>% 
    ggplot(., aes(episode, viewers)) +
    geom_col() +
    facet_wrap(~series)) 

ggplot(ratings, aes(episode, viewers, group = series, colour = series)) +
  geom_line() +
  geom_point() 


messy_ratings <- ratings %>% 
  select(series, episode, starts_with("viewers")) %>% 
  mutate(episode = str_c("e", episode)) %>% 
  spread(episode, viewers, convert = TRUE) %>% 
  select(-e10, everything(), e10)

# plot messy ratings columns
ggplot(messy_ratings, aes(series, e1)) +
  geom_col() 

# plot again with lines, ugh group = 1
ggplot(messy_ratings, aes(series, e2, group = 1)) +
  geom_point() + geom_line()

# test to make sure it works
tidy_ratings <- messy_ratings %>% 
  gather(episode, viewers, e1:e10) 

# test big plot to make it sure it is ok
ggplot(tidy_ratings, aes(parse_number(episode), 
                         viewers, 
                         group = series, 
                         colour = series)) +
  geom_line() +
  geom_point() 

# ok looks good and works
write_csv(messy_ratings, out_csv)

ratings2 <- read_csv(input, 
                    na = c("NA", "", "N/A"), 
                    col_types = cols(series = col_factor(levels = NULL))) %>% 
  select(series, episode, contains("day")) %>% 
  gather(key, viewers, contains("day")) %>% 
  separate(key, into = c("drop", "window")) %>% 
  select(-drop) %>% 
  arrange(series, episode)

# make it wide and messy again
wide_ratings2 <- ratings2 %>% 
  mutate(episode = str_c("e", episode)) %>% 
  unite(e_window, episode, window) %>% 
  spread(e_window, viewers) 

my_column_order <- c("series", "e1_7day", "e1_28day", 
                     "e2_7day", "e2_28day",
                     "e3_7day", "e3_28day",
                     "e4_7day", "e4_28day", 
                     "e5_7day", "e5_28day", 
                     "e6_7day", "e6_28day", 
                     "e7_7day", "e7_28day", 
                     "e8_7day", "e8_28day", 
                     "e9_7day", "e9_28day", 
                     "e10_7day", "e10_28day")
wide_ratings2 <- wide_ratings2[, my_column_order]

write_csv(wide_ratings2, out2_csv)




clean_ratings <- messy_ratings %>% 
  gather(key, viewers, ends_with("day")) %>% 
  separate(key, into = c("episode", "days"), convert = TRUE) %>% 
  mutate(episode = parse_number(episode),
         days = parse_number(days))

unclean_ratings <- clean_ratings %>% 
  spread(days, viewers, sep = "_")
  
(ratings_lines <- ggplot(clean_ratings, aes(factor(episode), 
                                      `7day`, 
                                      color = factor(series),
                                      group = series)) +
    geom_line() +
    geom_point())


messy_7day <- ratings %>% 
  select(series, episode, viewers_7day) %>% 
  spread(episode, viewers_7day, sep = "_") 

write_csv(messy_ratings, out_csv)

library(here)
viewers <- read_csv(here("data-datacamp", "messy_ratings.csv"))
