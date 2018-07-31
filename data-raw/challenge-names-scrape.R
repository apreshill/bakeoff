## work in progress
library(rvest)
library(purrr)
library(dplyr)
library(tidyr)
library(readr)
library(jsonlite)
library(listviewer)

url_base <- "https://en.wikipedia.org/wiki/The_Great_British_Bake_Off_(series_%d)"
max_episodes <- c(6, 8, 10, 10, 10, 10, 10, 10) + 3

## function to get names for each challenge
get_names <- function(series, max_episodes) {
  ## progress indicator
  cat(c("on your mark...","get set...", "BAKE!", sep = " "))
  pages <- read_html(sprintf(url_base, series))
  series_table <- pages %>%
    html_nodes(xpath = '//*[@id="mw-content-text"]/div/table') %>%
    html_table(fill = TRUE) %>%
    .[4:max_episodes] %>%
    map(~names(.))
}

challenge_names <- map2(.x = 1:8, .y = max_episodes, .f = get_names)


names_df <- map_df(challenge_names, bind_rows, .id = 'series')

## export list objects to json
## auto_unbox = TRUE in order to make this JSON as close as possible to the JSON
## null = "null" is necessary for roundtrips to work:
## list --> JSON --> original list
challenge_names %>%
  toJSON(pretty = TRUE, auto_unbox = TRUE, null = "null") %>%
  writeLines(here::here("inst", "extdata", "challenge_names.json"))


## listviewer::jsonedit(challenge_names, mode = "view")
## all.equal(), identical() and diffObj() say these objects are all the same
# library(diffobj)
# names_json <- fromJSON(here::here("inst", "extdata", "challenge_names.json"))
# diffObj(challenge_names, names_json)
# identical(challenge_names, names_json)
# all.equal(challenge_names, fromJSON(toJSON(challenge_names)))
