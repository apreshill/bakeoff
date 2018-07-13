series <- readr::read_csv(here::here("data-raw", "series.csv"),
                          col_types = cols(series = col_integer(),
                                           episodes = col_integer()))

# end of exports
usethis::use_data(series, overwrite = TRUE)
