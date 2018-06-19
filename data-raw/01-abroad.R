#**************************************************************
# this reads in the international versions of the show

#**************************************************************
# input files
input_latest <- "./data-raw/abroad_latest.csv"

#**************************************************************
# output files
out_csv <- "./data-raw/abroad.csv"
out_rda <- "./data/abroad.rda"

#**************************************************************
# load packages
library(rvest)
library(dplyr)
library(tidyr)
library(readr)
library(tidyr)
library(stringr)
library(janitor)

#**************************************************************
# read in input files
latest <- read_csv(input_latest)

# set the url and read
url <- "https://en.wikipedia.org/wiki/The_Great_British_Bake_Off"
page <- read_html(url)
cancelled_countries <- c("Belgium", "Ireland", "Turkey", "Ukraine")


# get + clean table 4
abroad_table <- page %>% 
  html_nodes(xpath = '//*[@id="mw-content-text"]/div/table') %>% 
  html_table(fill = TRUE) %>% 
  .[[4]] %>% 
  clean_names() %>% 
  mutate_at(vars(-premiere), funs(str_replace_all(., "[[:digit:]]+", ""))) %>% 
  mutate_at(vars(-premiere), funs(str_replace_all(., "\\[|\\]", ""))) %>% 
  mutate(cancelled = ifelse(country %in% cancelled_countries | local_title == "The American Baking Competition", 1, 0)) %>% 
  mutate(rownum = seq_len(n())) 

abroad <- abroad_table %>% 
  left_join(latest) %>% 
  separate(premiere, into = "premiere", sep = "\\[", extra = "drop") %>% 
  separate(premiere, into = "premiere", sep = "\\(", extra = "drop") %>% 
  separate(local_title, into = c("local_title", "en_title"), sep = "\\(", extra = "drop") %>% 
  mutate(en_title = str_replace_all(en_title, "\\(|\\)", ""),
         en_title = coalesce(en_title, local_title)) %>% 
  filter(!rownum == 2) %>% 
  select(country, en_title, premiere, cancelled, latest_season, hosts = host_s, everything(), -rownum) 

abroad_cleaned <- abroad %>% 
  mutate(hosts = str_replace_all(hosts, "\n", ", "),
         hosts = str_replace_all(hosts, "(?<=[[:lower:]])(?=[[:upper:][:digit:](])", ", "),
         hosts = str_replace_all(hosts, " \\(\\)", ", "),
         hosts = str_replace_all(hosts, "\\(\\-\\)", ""),
         hosts = str_replace_all(hosts, "\\s*\\([^\\)]+\\)", ", "),
         hosts = str_replace_all(hosts, "\\,,|\\, ,", ", "),
         hosts = str_replace_all(hosts, "\\, $|\\,$|\\,  $", "")) %>% 
  mutate(judges = str_replace_all(judges, "\n", ", "),
         judges = str_replace_all(judges, "(?<=[[:lower:]])(?=[[:upper:][:digit:](])", ", "),
         judges = str_replace_all(judges, " \\(\\)", ", "),
         judges = str_replace_all(judges, "\\(\\-\\)", ""),
         judges = str_replace_all(judges, "\\s*\\([^\\)]+\\)", ", "),
         judges = str_replace_all(judges, "\\,,|\\, ,", ", "),
         judges = str_replace_all(judges, "\\, $|\\,$|\\,  $", "")) %>% 
  mutate(local_title = str_replace_all(local_title, "\n", "")) %>% 
  mutate(en_title = ifelse(country == "Estonia", "Estonia's Best Baker", en_title),
         premiere = ifelse(country == "Italy", "29 November 2013", premiere),
         premiere_clean = parse_date(premiere, format = "%d %B %Y")) %>% 
  arrange(country, premiere_clean) %>% 
  select(-premiere_clean)



#**************************************************************
# export final files
write_csv(abroad_cleaned, out_csv)
save(abroad_cleaned, file = out_rda)

#**************************************************************
# make mini versions for chapter 1
abroad_slides <- abroad_cleaned %>% 
  select(country, en_title, premiere, cancelled, latest_season)

write_csv(abroad_slides, "./data-datacamp/abroad_slides.csv")

# round 1
bakeoffs_abroad <- read_csv("./data-datacamp/abroad_slides.csv")
bakeoffs_abroad
glimpse(bakeoffs_abroad)

# round 2
fr_names <- c("pays", "titre", "première", 
              "annulé", "dernier")
bakeoffs_abroad <- read_csv("./data-datacamp/abroad_slides.csv",
                            col_names = fr_names)
glimpse(bakeoffs_abroad)

# round 3
fr_names <- c("pays", "titre", "première", 
              "annulé", "dernier")
bakeoffs_abroad <- read_csv("./data-datacamp/abroad_slides.csv",
                            col_names = fr_names,
                            skip = 1)
glimpse(bakeoffs_abroad)

bakeoffs_abroad <- read_csv("data-datacamp/abroad_slides.csv", 
                            col_types = cols(latest_season = col_number()))

bakeoffs_abroad <- read_csv("data-datacamp/abroad_slides.csv", 
                            col_types = cols(
                              premiere = col_date(format = "%d %B %Y")))
