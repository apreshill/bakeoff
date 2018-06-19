#**************************************************************
# this starts with the cleaned up challenge_results

# new title: dessert 

# has type of dessert, chocolate, nuts (need to add), fruits!


#**************************************************************
# load packages
library(dplyr)
library(readr)
library(tidyr)
library(stringr)

#**************************************************************
# Dessert types here
cakes <- c("cake", "torte", "savarin", "swiss roll", "gâteau")
pies <- c("pie", "bakewell", "tart", "banoffee", "quiche")
puddings <- c("pudding", "custard", "trifle")
# https://github.com/dariusk/corpora/blob/master/data/foods/fruits.json
# add fruits!
fruits <- c("apple",
            "apricot",
            "avocado",
            "banana",
            "bell pepper",
            "bilberry",
            "blackberry",
            "blackcurrant",
            "blood orange",
            "blueberry",
            "boysenberry",
            "breadfruit",
            "canary melon",
            "cantaloupe",
            "cherimoya",
            "cherry",
            "chili pepper",
            "clementine",
            "cloudberry",
            "coconut",
            "cranberry",
            "cucumber",
            "currant",
            "damson",
            "date",
            "dragonfruit",
            "durian",
            "eggplant",
            "elderberry",
            "feijoa",
            "fig",
            "goji berry",
            "gooseberry",
            "grape",
            "grapefruit",
            "guava",
            "honeydew",
            "huckleberry",
            "jackfruit",
            "jambul",
            "jujube",
            "kiwi fruit",
            "kumquat",
            "lemon",
            "lime",
            "loquat",
            "lychee",
            "mandarine",
            "mango",
            "mulberry",
            "nectarine",
            "nut",
            "olive",
            "orange",
            "pamelo",
            "papaya",
            "passionfruit",
            "peach",
            "pear",
            "persimmon",
            "physalis",
            "pineapple",
            "plum",
            "pomegranate",
            "pomelo",
            "purple mangosteen",
            "quince",
            "raisin",
            "rambutan",
            "raspberry",
            "redcurrant",
            "rock melon",
            "salal berry",
            "satsuma",
            "star fruit",
            "strawberry",
            "tamarillo",
            "tangerine",
            "tomato",
            "ugli fruit",
            "watermelon")
# nuts

#**************************************************************
# read in file
challenge_results <- read_csv("./data-raw/challenge_results.csv", 
                              na = c("", "NA", "UNKNOWN"),
                              col_types = cols(
                                #uk_airdate = col_date(format = "%d %B %Y"),
                                us_airdate = col_date(format = "%d-%b-%y")
                              )) %>% 
  mutate(result = case_when(
    result == "Runner up" ~ "RUNNER UP",
    result == "Runner Up" ~ "RUNNER UP",
    result == "Runner-Up" ~ "RUNNER UP",
    result == "Third Place" ~ "RUNNER UP",
    TRUE ~ as.character(result)
  )) %>% 
  select(series, episode, baker, signature,
         showstopper, technical, result, uk_airdate, 
         starts_with("us"), -uk_premiere) %>% 
  drop_na(result) # added this so ch1 is cleaner
  

# gather into right shape
desserts_tidy <- challenge_results %>% 
  gather(challenge, bake, signature:showstopper) %>% 
  mutate(bake = str_to_lower(bake)) 

# add dessert type here
desserts_tidy <- desserts_tidy %>% 
  mutate(cake = str_detect(bake, paste(cakes, collapse="|")),
         pie = str_detect(bake, paste(pies, collapse="|")),
         pudding = str_detect(bake, paste(puddings, collapse="|"))) %>% 
  mutate(dessert = case_when(
    cake == TRUE ~ "cake",
    pie == TRUE ~ "pie",
    pudding == TRUE ~ "pudding",
    TRUE ~ "other"
  )) %>% 
  select(-cake, -pie, -pudding)

# add choc or not here
desserts_tidy <- desserts_tidy %>% 
  mutate(chocolate = case_when(
    str_detect(bake, "chocolate") ~ "chocolate",
    TRUE ~ "no chocolate"
  )) 

# add fruit or not here
desserts_tidy <- desserts_tidy %>% 
  mutate(fruit = case_when(
    str_detect(bake, paste(fruits, collapse="|")) ~ "fruit",
    TRUE ~ "no fruit"
  )) 

# add nuts here
desserts_tidy <- desserts_tidy %>% 
  mutate(pecan = str_detect(bake, fixed("pecan", ignore_case = TRUE)),
       walnut = str_detect(bake, fixed("walnut", ignore_case = TRUE)),
       hazel = str_detect(bake, fixed("hazel", ignore_case = TRUE)),
       almond = str_detect(bake, fixed("almond", ignore_case = TRUE)),
       peanut = str_detect(bake, fixed("peanut", ignore_case = TRUE)),
       cashew = str_detect(bake, fixed("cashew", ignore_case = TRUE)),
       macadamia = str_detect(bake, fixed("macadamia", ignore_case = TRUE)),
       pistachio = str_detect(bake, fixed("pistachio", ignore_case = TRUE))) %>% 
  mutate(nut_sum = rowSums(.[14:21])) %>% 
  mutate(nut = case_when(
    nut_sum > 1 ~ "multiple",
    cashew == TRUE ~ "cashew",
    pecan == TRUE ~ "pecan",
    walnut == TRUE ~ "walnut",
    hazel == TRUE ~ "filbert",
    almond == TRUE ~ "almond",
    peanut == TRUE ~ "peanut",
    pistachio == TRUE ~ "pistachio",
    TRUE ~ "no nut"
  )) %>% 
  select(-c(almond, walnut, pistachio, cashew, pecan, walnut, hazel, peanut, macadamia, nut_sum))
 
#now think about summarizing per baker?
#cookie first
#then cake, pie, tart, pudding last
# if custard + tart --> tart



desserts_untidy <- desserts_tidy %>% 
  select(-bake) %>% 
  gather(key, value, dessert:nut) %>% 
  unite(challenge_var, challenge, key) %>% 
  spread(challenge_var, value)
  

# questions:
# which bakers baked the most of x?
# growth over seasons? peak pie?

# recode "other" as NA then drop_na



# gropu by series, episode, cahllenge, dessert type
desserts_count <- desserts_tidy %>% 
  count(series, episode, uk_airdate, us_season, us_airdate,
        challenge, dessert)

desserts_by_baker <- desserts_tidy %>% 
  count(series, baker, dessert) %>% 
  spread(dessert, n, fill = 0) %>% 
  select(series, baker, cake, pie, pudding)

#**************************************************************
# output files
write_csv(desserts_untidy, "./data-datacamp/desserts.csv")
write_csv(desserts_tidy, "./data-datacamp/desserts_tidy.csv")
write_csv(desserts_by_baker, "./data-datacamp/desserts_by_baker.csv")

# make finale variable! case_when
# group_by series, if episode is max(episode)

desserts_tidy <- desserts_tidy %>% 
  group_by(series) %>% 
  mutate(finale = case_when(
    episode == max(episode) ~ "finale"
  )) %>% 
  ungroup()