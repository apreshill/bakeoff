#**************************************************************
# this creates a new data file for datacamp with messy strings for the baker results data

#**************************************************************
# input files
input_strings <- "./data-datacamp/messy_baker_results.csv"


#**************************************************************
# output files
out_csv <- "./data-datacamp/messy_strings_baker_results.csv"

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
strings <- read_csv(input_strings)

# make a "position_reached" as winner/runner up

test <- challenge_results %>% 
  mutate(liquor = str_detect(signature, fixed("liquor", ignore_case = TRUE)),
         liqueur = str_detect(signature, fixed("liqueur", ignore_case = TRUE)),
         liquors = str_detect(showstopper, fixed("liquor", ignore_case = TRUE)),
         liqueurs = str_detect(showstopper, fixed("liqueur", ignore_case = TRUE)))