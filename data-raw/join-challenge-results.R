## this script joins challenges and results
## by shared keys: series / episode / baker

library(readr)
library(dplyr)
library(bakeoff)

# merge files
# Challenges is missing NA values for Diana, Series 5, episode 5 (she left)
challenge_results <- results %>%
  full_join(challenges) %>%
  arrange(series, episode, result)

## dataframe to csv
write_csv(challenge_results, here::here("data-raw", "challenge_results.csv"))

# end of exports
usethis::use_data(challenge_results, overwrite = TRUE)
