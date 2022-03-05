## this script scrapes data about the challenges across each GBBO series
## and exports the list to a json + the data frame to a csv
library(rvest)
library(purrr)
library(dplyr)
library(tidyr)
library(readr)
library(jsonlite)
# library(listviewer)

url_base <- "https://en.wikipedia.org/wiki/The_Great_British_Bake_Off_(series_%d)"
max_episodes <- c(6, 8, 10, 10, 10, 10, 10, 10, 10, 10) + 3

## function to get episodes across series
get_episodes <- function(series, max_episodes) {
  ## progress indicator
  cat(c("on your mark...","get set...", "BAKE!", sep = " "))
  pages <- read_html(sprintf(url_base, series))
  series_table <- pages %>%
    html_nodes(xpath = '//*[@id="mw-content-text"]/div/table') %>%
    html_table(fill = TRUE) %>%
    .[4:max_episodes] %>%
    #map(~set_names(., new_colnames)) %>%
    map(~rename_with(., ~ tolower(stringr::word(.x, sep = "[[:punct:][:space:][:digit:]]+")))) %>%
    map(mutate, series = series)
}

## bind them all together in one list
episodes <- map2(.x = 1:10,
                   .y = max_episodes,
                   .f = get_episodes)


## export list objects to json
## auto_unbox = TRUE in order to make this JSON as close as possible to the JSON
## null = "null" is necessary for roundtrips to work:
## list --> JSON --> original list
episodes %>%
  toJSON(pretty = TRUE, auto_unbox = TRUE, null = "null") %>%
  writeLines(here::here("inst", "extdata", "episodes.json"))

## work now with the challenges list
## make into a dataframe
## this counts each episode cumulatively, not by series
episodes_df <- flatten_df(episodes, .id = "episode_count") %>%
  mutate(episode_count = as.integer(episode_count))

## make episode counts by series, not cumulative
## also parse technical ranks to actual numbers
episodes_df <- episodes_df %>%
  arrange(series, episode_count, baker) %>%
  group_by(series, baker) %>%
  mutate(episode = row_number()) %>%
  select(series, episode, baker, everything(), -episode_count) %>%
  ungroup() %>%
  mutate(baker = ifelse(series == 2 & baker == "Jo", "Joanne", baker)) %>%
  mutate(across(everything(), ~na_if(., "UNKNOWN"))) %>%
  mutate(across(everything(), ~na_if(., "N/A"))) %>%
  mutate(across(everything(), ~na_if(., "Did not compete"))) %>%
  mutate(technical = parse_number(technical))

## dataframe to csv
write_csv(episodes_df, here::here("data-raw", "episodes.csv"))

episodes_df %>%
  split(.$series, .$episode) %>%
  toJSON(pretty = TRUE, auto_unbox = TRUE, null = "null") %>%
  writeLines(here::here("inst", "extdata", "episodes.json"))

## listviewer::jsonedit(episodes, mode = "view")
## all.equal(), identical() and diffObj() say these objects are all the same
# library(diffobj)
# episodes_json <- fromJSON(here::here("inst", "extdata", "episodes.json"))
# diffObj(episodes, episodes_json)
# identical(episodes, episodes_json)
# all.equal(episodes, fromJSON(toJSON(episodes)))
