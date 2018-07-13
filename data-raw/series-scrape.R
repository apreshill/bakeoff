library(rvest)
library(dplyr)
library(tidyr)
library(readr)
library(tidyr)
library(stringr)
library(janitor)
library(lubridate)

url <- "https://en.wikipedia.org/wiki/The_Great_British_Bake_Off"
page <- read_html(url)

## get table 2
series <- page %>%
  html_nodes(xpath = '//*[@id="mw-content-text"]/div/table') %>%
  html_table(fill = TRUE) %>%
  .[[2]] %>%
  clean_names() %>%
  rename(avg_uk_viewers = "average_uk_viewers_millions_21_22")

## duplicate entries b/c of 2 runners-up per series
## clean things up a bit
series <- series %>%
  group_by(series) %>%
  mutate(runner_up = seq_along(series)) %>%
  spread("runner_up", "runners_up", sep = "_") %>%
  separate(timeslot, into = c("day_of_week", "timeslot"), sep = -7) %>%
  mutate(timeslot = str_replace_all(timeslot, "[^\x20-\x7E]", "")) %>%
  mutate(premiere = dmy(premiere),
         finale = dmy(finale))

## dataframe to csv
write_csv(series, here::here("data-raw", "series.csv"))
