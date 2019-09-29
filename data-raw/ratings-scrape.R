library(rvest)
library(purrr)
library(dplyr)
library(tidyr)
library(readr)
library(stringr)
library(jsonlite)
library(here)
library(lubridate)

url_base <- "https://en.wikipedia.org/wiki/The_Great_British_Bake_Off_(series_%d)"
ratings_start <- c(10, 12, 14, 19, 19, 19, 16, 16, 16)

## get the ratings data across series
get_ratings <- function(series, ratings_start) {
  cat(c("on your mark...","get set...", "BAKE!", sep = " "))
  pages <- read_html(sprintf(url_base, series))
  results_table <- pages %>%
    html_nodes(xpath = '//*[@id="mw-content-text"]/div/table') %>%
    html_table(fill = TRUE, header = FALSE) %>%
    .[[ratings_start]]
}

new_colnames <- c("series", "episode", "airdate", "viewers_7day",
                  "viewers_28day",
                  "weekly_ranking_network",
                  "weekly_ranking_all_channels",
                  "bbc_iplayer_requests")

## bind them all together in dataframe
ratings_df <- map2_dfr(.x = 1:9, .y = ratings_start,
                    .f = get_ratings, .id = "series") %>%
  set_names(new_colnames) %>%
  group_by(series) %>%
  filter(!row_number() == 1) %>%
  ungroup()

## more wrangling
ratings <- ratings_df %>%
  separate(bbc_iplayer_requests, into = "bbc_iplayer_requests", extra = "drop", sep = "\\[") %>%
  separate(airdate, into = c("uk_premiere", "uk_airdate"), sep = "\\(", remove = TRUE) %>%
  mutate(uk_airdate = ymd(uk_airdate)) %>%
  select(-uk_premiere) %>%
  mutate_if(is.character, funs(na_if(., "N/A"))) %>%
  mutate_if(is.character, funs(parse_number)) %>%
  mutate(series = as.integer(series),
         episode = as.integer(episode)) %>%
  rename(network_rank = weekly_ranking_network,
         channels_rank = weekly_ranking_all_channels)

## work now with the ratings list

## export list objects to json
## auto_unbox = TRUE in order to make this JSON as close as possible to the JSON
## null = "null" is necessary for roundtrips to work:
## list --> JSON --> original list
ratings %>%
  toJSON(pretty = TRUE, auto_unbox = TRUE, null = "null") %>%
  writeLines(here::here("inst", "extdata", "ratings.json"))

## dataframe to csv
write_csv(ratings, here::here("data-raw", "ratings.csv"))

## all.equal(), identical() and diffObj() say these objects are all the same
# library(diffobj)
# ratings_json <- fromJSON(here::here("inst", "extdata", "ratings.json"))
# diffObj(ratings, ratings_json)
# identical(ratings, ratings_json)
# all.equal(ratings, fromJSON(toJSON(ratings)))
