## this script scrapes data about the episode results across each GBBO series
## and exports the list to a json + the data frame to a csv
library(rvest)
library(purrr)
library(dplyr)
library(tidyr)
library(readr)

url_base <- "https://en.wikipedia.org/wiki/The_Great_British_Bake_Off_(series_%d)"

## get the episode results across series
get_results <- function(series) {
  cat(c("on your mark...","get set...", "BAKE!", sep = " "))
  pages <- read_html(sprintf(url_base, series))
  results_table <- pages %>%
    html_nodes(xpath = '//*[@id="mw-content-text"]/div/table') %>%
    html_table(fill = TRUE, header = FALSE) %>%
    .[[3]]
}

## bind them all together in a dataframe
results_df <- map_dfr(.x = 1:9, .f = get_results, .id = 'series') %>%
  select(series,
         baker = X1,
         episode_ = X2:X11) %>%
  group_by(series) %>%
  filter(!row_number() %in% c(1:2)) %>%
  ungroup()

## tons of wrangling here
results_df2 <- results_df %>%
  gather(episode, result, -series, -baker) %>%
  separate(episode, into = c("drop", "episode")) %>%
  select(series, episode, baker, result) %>%
  mutate(series = as.integer(series),
         episode = as.integer(episode),
         baker = ifelse(series == 2 & baker == "Jo", "Joanne", baker)) %>%
  arrange(series, baker, episode) %>%
  drop_na(result)  # this gets rid of episodes that don't apply to that series

results <- results_df2 %>%
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
  select(series, episode, baker, result = new_result2) %>%
  mutate(result = case_when(
    result %in% c("Runner up", "Runner Up", "Runner-Up", "Third Place") ~ "RUNNER-UP",
    result == "SB" ~ "STAR BAKER",
    TRUE ~ result
  ))

## dataframe to csv
write_csv(results, here::here("data-raw", "results.csv"))
