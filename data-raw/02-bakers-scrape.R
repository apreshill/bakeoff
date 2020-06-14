## this script scrapes data about bakers across each GBBO series
## and exports the list to a json + the data frame to a csv
library(rvest)
library(purrr)
library(dplyr)
library(tidyr)
library(readr)
library(stringr)
library(xml2)
library(jsonlite)
library(here)

url_base <- "https://en.wikipedia.org/wiki/The_Great_British_Bake_Off_(series_%d)"

## function to get bakers across series
get_bakers <- function(series) {
  ## progress indicator
  cat(c("on your mark...","get set...", "BAKE!", sep = " "))
  pages <- read_html(sprintf(url_base, series))
  bakers_table <- pages %>%
    html_nodes(xpath = '//*[@id="mw-content-text"]/div/table') %>%
    html_table(fill = TRUE) %>%
    .[[2]] %>%
    .[1:4]
}

## bind them all together in one list
bakers <- map(.x = 1:10, .f = get_bakers)

## work now with the bakers list
## change all column names
new_colnames <- c("baker_full", "age", "occupation", "hometown")
bakers <- map(.x = bakers, ~set_names(.x, new_colnames))

## export list objects to json
## auto_unbox = TRUE in order to make this JSON as close as possible to the JSON
## null = "null" is necessary for roundtrips to work:
## list --> JSON --> original list
bakers %>%
  toJSON(pretty = TRUE, auto_unbox = TRUE, null = "null") %>%
  writeLines(here::here("inst", "extdata", "bakers.json"))

## make into a dataframe
bakers_df <- map_df(bakers, bind_rows, .id = 'series')

## dataframe to csv
write_csv(bakers_df, here::here("data-raw", "bakers.csv"))

## all.equal(), identical() and diffObj() say these objects are all the same
# library(diffobj)
# bakers_json <- fromJSON(here::here("inst", "extdata", "bakers.json"))
# diffObj(bakers, bakers_json)
# identical(bakers, bakers_json)
# all.equal(bakers, fromJSON(toJSON(bakers)))
