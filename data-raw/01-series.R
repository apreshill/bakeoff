#**************************************************************
# this reads in the series information

#**************************************************************
# output files
out_csv <- "./data-raw/series.csv"
out_rda <- "./data/series.rda"

#**************************************************************
# load packages
library(rvest)
library(dplyr)
library(tidyr)
library(readr)
library(tidyr)
library(stringr)
library(janitor)

# set the url and read
url <- "https://en.wikipedia.org/wiki/The_Great_British_Bake_Off"
page <- read_html(url)

# get table 2
series <- page %>% 
  html_nodes(xpath = '//*[@id="mw-content-text"]/div/table') %>% 
  html_table(fill = TRUE) %>% 
  .[[2]] %>% 
  clean_names() %>% 
  rename(avg_uk_viewers = "average_uk_viewers_millions_21_22") 

# duplicate entries b/c of 2 runners-up per series
# clean things up a bit
series <- series %>% 
  group_by(series) %>% 
  mutate(runner_up = seq_along(series)) %>% 
  spread("runner_up", "runners_up", sep = "_") %>% 
  separate(timeslot, into = c("day_of_week", "timeslot"), extra = "merge") %>% 
  mutate(timeslot = str_replace_all(timeslot, "[^\x20-\x7E]", ""))

# add us seasons
series <- series %>% 
  mutate(season = case_when(
    series == 4 ~ 1,
    series == 5 ~ 2,
    series == 6 ~ 3,
    series == 7 ~ 4),
    season_premiere = case_when(
      season == 1 ~ "2014-12-28",
      season == 2 ~ "2015-09-06",
      season == 3 ~ "2016-07-01",
      season == 4 ~ "2017-06-16"),
    season_finale = case_when(
      season == 1 ~ "2015-03-01",
      season == 2 ~ "2015-11-08",
      season == 3 ~ "2016-08-12",
      season == 4 ~ "2017-08-04")
    )

#**************************************************************
# export final files
write_csv(series, out_csv)
save(series, file = out_rda)
