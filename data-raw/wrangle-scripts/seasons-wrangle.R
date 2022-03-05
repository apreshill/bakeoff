seasons <- readr::read_csv(here::here("data-raw", "seasons.csv"),
                           col_types = cols(series = col_integer(),
                                            episode = col_integer(),
                                            us_season = col_integer(),
                                            us_airdate = col_date(format = "%B %d, %Y")))

# end of exports
usethis::use_data(seasons, overwrite = TRUE)
