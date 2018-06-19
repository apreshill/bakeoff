#**************************************************************
# this creates a new data file for datacamp with messy NAMES for the baker results data

#**************************************************************
# input files
input_messy <- "./data-datacamp/messy_baker_results.csv"


#**************************************************************
# output files
out_csv <- "./data-datacamp/messy_names_baker_results.csv"

#**************************************************************
# load packages
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(janitor)
library(tibble)

#**************************************************************
# read in input files
messy <- read_csv(input_messy)







%>% 
  select(SERIES,
         BAKER, 
         EPISODE_1:EPISODE_10,
         everything()) %>% 
  select(SERIES,
         X = BAKER:EPISODE_10,
         everything()) %>% 
  rename_all(funs(str_replace_all(., "_", " "))) %>% 
  rename_at(vars(one_of("AGE", "OCCUPATION", "HOMETOWN")),
            funs(str_c(., "-Entered by OMC"))) %>% 
  rename_at(vars(contains("percent")), 
            funs(str_replace(., "PERCENT", "%"))) %>% 
  rename_at(vars(contains("tech")), 
            funs(str_replace(., "TECHNICAL", "TCH"))) %>% 
  select(SERIES, ends_with("OMC"), starts_with("X"), everything())


not_so_messy <- messy_names %>% 
  clean_names("snake") %>% 
  select(baker = x_1,
         episode_ = x_2:x_11,
         everything()) %>% 
  rename_at(vars(starts_with("tch")), 
            funs(str_replace(., "tch", "technical")))  %>% 
  rename_all(funs(str_replace(., "_entered_by_omc", ""))) 


#**************************************************************
# output files

write_csv(messy_names, out_csv)


