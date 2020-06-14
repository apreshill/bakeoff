# This script scrapes a single table from Wikipedia

library(rvest)
library(dplyr)
library(tidyr)
library(readr)
library(tidyr)
library(stringr)
library(janitor)
library(lubridate)
library(htmltab)

url <- "https://en.wikipedia.org/wiki/The_Great_British_Bake_Off#Series_overview"
series <- url %>%
  htmltab(2, rm_nodata_cols = F) %>%
  clean_names() %>%
  as_tibble() %>%
  rename(avg_uk_viewers = "average_uk_viewers_millions") %>%
  mutate(series = as.integer(series),
         episodes = as.integer(episodes),
         avg_uk_viewers = as.numeric(avg_uk_viewers))

## get table 2
# page <- xml2::read_html(url)
# series <- page %>%
#   html_nodes(xpath = '/html/body/div[3]/div[3]/div[4]/div/table[2]') %>%
#   html_table(fill = TRUE) %>%
#   .[[2]] %>%
#   clean_names() %>%
#   rename(avg_uk_viewers = "average_uk_viewers_millions_21_22")

## duplicate entries b/c of 2 runners-up per series
## clean things up a bit
series <- series %>%
  group_by(series) %>%
  mutate(runner_up = seq_along(series)) %>%
  spread("runner_up", "runners_up", sep = "_") %>%
  separate(timeslot, into = c("day_of_week", "timeslot"), sep = -7) %>%
  mutate(timeslot = str_replace_all(timeslot, "[^\x20-\x7E]", "")) %>%
  mutate(premiere = dmy(premiere),
         finale = dmy(finale),
         series = as.integer(series),
         episodes = as.integer(episodes))

## dataframe to csv
write_csv(series, here::here("data-raw", "series.csv"))

# end of exports
usethis::use_data(series, overwrite = TRUE)
