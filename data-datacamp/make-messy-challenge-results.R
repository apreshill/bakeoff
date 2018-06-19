#**************************************************************
# this creates a new data file for datacamp with messy challenge results with metadata in row 2 (need to skip at import)


#**************************************************************
# load packages
library(dplyr)
library(readr)
library(tidyr)
library(stringr)

#**************************************************************
# read in file
challenge_results <- read_csv("./data-raw/challenge_results.csv", 
                              col_types = cols(uk_premiere = col_character())
) %>% 
  unite(episode, series, episode, sep = "-") %>% 
  #replace_na(list(baker = "", result = "Previously eliminated")) %>% 
  #unite(mess, baker, result, remove = FALSE, sep = " / ") %>%
  mutate(showstopper = na_if(showstopper, "Eliminated after signature")) %>% 
  drop_na(result) # added this so ch1 is cleaner
  



# challenge_results <- challenge_results %>% 
#  mutate(episode = formatC(episode, digits = 2, format = "f"))

# add a row of metadata on top
challenge_meta <- c("This is the UK series number + episode", "First name of baker only", "Coded as: eliminated / result", "Signature bake", "Technical ranking", "Showstopper bake", "UK Premiere Date", "UK Airdate", "This is the US season, out of 4", "Airdate in the US")

add_meta_row <- function(clean_data, metadata) {
  true_names <- names(clean_data)
  names(clean_data) <- metadata
  messy_data <- rbind(true_names, clean_data)
}

messy_challenge_results <- add_meta_row(challenge_results, challenge_meta) 


#**************************************************************
# output files
write_csv(messy_challenge_results, "./data-datacamp/messy_challenge_results.csv")

#**************************************************************
# alternative file exports
openxlsx::write.xlsx(messy_challenge_results, 
                     file = "./data-datacamp/messy_challenge_results.xlsx")
haven::write_sav(challenge_results, 
                 path = "./data-datacamp/challenge_results.sav")


# don't use
bakers <- read_csv("./data-raw/bakers.csv") %>% 
  select(baker_full, baker) %>% 
  mutate(baker_full = str_replace_all(baker_full, "\"", "")) %>% 
  mutate(baker_full = str_replace_all(baker_full, "\\(", "")) %>% 
  mutate(baker_full = str_replace_all(baker_full, "\\)", "")) %>% 
  separate(baker_full, into = c("n1", "n2", "n3"), 
           remove = FALSE,
           fill = "left",
           sep = "\\s+") %>% 
  mutate(baker_first = coalesce(n1, n2),
         n3 = ifelse(baker == "Miranda", "Gore Browne", n3)) %>% 
  select(baker_first, baker_last = n3, baker_nick = baker,
         everything(), -n1, -n2, -baker_full)

challenge_bakers <- bakers %>% 
  left_join(challenge_results, by = c("baker_nick" = "baker"))