challenges <- readr::read_csv(here::here("data-raw", "challenges.csv"),
                         col_types = cols(series = col_integer(),
                                          episode = col_integer(),
                                          technical = col_integer()))

# end of exports
usethis::use_data(challenges, overwrite = TRUE)
