## code to prepare `jr_knowledge_test` dataset goes here

library(rvest)
library(dplyr)
library(tidyr)
library(readr)
library(tidyr)
library(stringr)
library(janitor)
library(lubridate)
library(htmltab)

url <- "https://en.wikipedia.org/wiki/Junior_Bake_Off_(series_2)"
page <- xml2::read_html(url)
spice_test_wide <- page %>%
  html_nodes(xpath = '/html/body/div[3]/div[3]/div[4]/div/table[17]') %>%
  html_table(fill = TRUE) %>%
  .[[1]] %>%
  clean_names() %>%
  select(baker, spice_guessing = starts_with("smelling")) %>%
  separate(spice_guessing, sep = "\n", into = c("guess_1", "guess_2", "guess_3")) %>%
  mutate(correct_1 = if_else(guess_1 == "Cinnamon", 1, 0),
         correct_2 = if_else(guess_2 == "Cardamom", 1, 0),
         correct_3 = if_else(guess_3 == "Nutmeg", 1, 0))

usethis::use_data(spice_test_wide, overwrite = TRUE)
