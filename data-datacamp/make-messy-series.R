# idea: merge messy_ratings.csv with series.csv for gathering exercises

#**************************************************************
# input files
in_ratings <- "./data-datacamp/messy_ratings.csv"
in_series <- "./data-raw/series.csv"

#**************************************************************
# output files
out_csv <- "./data-datacamp/messy_series.csv"

#**************************************************************
# load packages
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(lubridate)
library(ggplot2)

#**************************************************************
# read in input files
series <- read_csv(in_series) 
ratings <- read_csv(in_ratings) %>% 
  rename_at(vars(starts_with("e")), 
            funs(str_c(., "_viewers")))

#**************************************************************
# merge
messy_series <- full_join(series, ratings)

write_csv(messy_series, out_csv)

