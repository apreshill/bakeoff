## this script scrapes data about the bakes across each GBBO series
## and exports the list to a json + the data frame to a csv
library(rvest)
library(purrr)
library(dplyr)
library(tidyr)
library(readr)
library(jsonlite)
library(listviewer)

url_base <- "https://en.wikipedia.org/wiki/The_Great_British_Bake_Off_(series_%d)"
max_episodes <- c(6, 8, 10, 10, 10, 10, 10, 10) + 3
new_colnames <- c("baker", "signature", "technical", "showstopper")

## function to get bakes across series
get_bakes <- function(series, max_episodes) {
  ## progress indicator
  cat(c("on your mark...","get set...", "BAKE!", sep = " "))
  pages <- read_html(sprintf(url_base, series))
  series_table <- pages %>%
    html_nodes(xpath = '//*[@id="mw-content-text"]/div/table') %>%
    html_table(fill = TRUE) %>%
    .[4:max_episodes] %>%
    map(~set_names(., new_colnames)) %>%
    map(mutate, series = series)
}

## bind them all together in one list
bakes <- map2(.x = 1:8, .y = max_episodes, .f = get_bakes)

## export list objects to json
## auto_unbox = TRUE in order to make this JSON as close as possible to the JSON
## null = "null" is necessary for roundtrips to work:
## list --> JSON --> original list
bakes %>%
  toJSON(pretty = TRUE, auto_unbox = TRUE, null = "null") %>%
  writeLines(here::here("inst", "extdata", "bakes.json"))

## work now with the bakes list
## make into a dataframe
## this counts each episode cumulatively, not by series
bakes_df <- flatten_df(bakes, .id = "episode_count") %>%
  mutate(episode_count = as.integer(episode_count))

## make episode counts by series, not cumulative
## also parse technical ranks to actual numbers
bakes_df <- bakes_df %>%
  arrange(series, episode_count, baker) %>%
  group_by(series, baker) %>%
  mutate(episode = row_number()) %>%
  select(series, episode, baker, everything(), -episode_count) %>%
  ungroup() %>%
  mutate(baker = ifelse(series == 2 & baker == "Jo", "Joanne", baker)) %>%
  mutate(technical = parse_number(technical))

## dataframe to csv
write_csv(bakes_df, here::here("data-raw", "bakes.csv"))

bakes_df %>%
  split(.$series, .$episode) %>%
  toJSON(pretty = TRUE, auto_unbox = TRUE, null = "null") %>%
  writeLines(here::here("inst", "extdata", "bakes.json"))

## listviewer::jsonedit(bakes, mode = "view")
## all.equal(), identical() and diffObj() say these objects are all the same
# library(diffobj)
# bakes_json <- fromJSON(here::here("inst", "extdata", "bakes.json"))
# diffObj(bakes, bakes_json)
# identical(bakes, bakes_json)
# all.equal(bakes, fromJSON(toJSON(bakes)))
