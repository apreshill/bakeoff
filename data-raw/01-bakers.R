#**************************************************************
# this reads in the individual bakers across series

#**************************************************************
# output files
out_csv <- "./data-raw/bakers.csv"
out_rda <- "./data/bakers.rda"

#**************************************************************
# load packages
library(rvest)
library(purrr)
library(dplyr)
library(tidyr)
library(readr)
library(stringr)

#**************************************************************
# setup
url_base <- "https://en.wikipedia.org/wiki/The_Great_British_Bake_Off_(series_%d)"


#**************************************************************
# get the bakers across series

get_bakers <- function(series) {
  
  # progress indicator
  cat(c("on your mark...","get set...", "BAKE!", sep = " "))
  
  pages <- read_html(sprintf(url_base, series))

  bakers_table <- pages %>% 
    html_nodes(xpath = '//*[@id="mw-content-text"]/div/table') %>% 
    html_table(fill = TRUE) %>% 
    .[[2]] %>% 
    .[1:4] 
}

# bind them all together in one list
bakers <- map(.x = 1:8, .f = get_bakers)

#**************************************************************
# work now with the bakers list 

# change all column names
new_colnames <- c("baker_full", "age", "occupation", "hometown")
bakers <- map(.x = bakers, ~set_names(.x, new_colnames))

# make into a dataframe
bakers_df <- map_df(bakers, bind_rows, .id = 'series') 

# more wrangling
bakers_df <- bakers_df %>% 
  separate(baker_full, into = "baker", extra = "drop", 
           remove = FALSE, sep = " ") %>% 
  mutate(baker = case_when(
    baker == "Edward" ~ "Edd",
    baker == "Valerie" ~ "Val",
    baker == "Chuen-Yan" ~ "Yan",
    TRUE ~ baker
  )) %>% 
  mutate(baker_last = word(baker_full, - 1),
         baker_first = word(baker_full, 1))
  #select(-baker_full)

#**************************************************************
# export final files
write_csv(bakers_df, out_csv)
save(bakers_df, file = out_rda)
