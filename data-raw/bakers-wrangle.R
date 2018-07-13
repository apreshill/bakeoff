bakers <- readr::read_csv(here::here("data-raw", "bakers.csv"))

## wrangling to clean up
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

# end of exports
usethis::use_data(bakers, overwrite = TRUE)
