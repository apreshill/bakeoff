bakers <- readr::read_csv(here::here("data-raw", "bakers.csv"))

# end of exports
usethis::use_data(bakers, overwrite = TRUE)
