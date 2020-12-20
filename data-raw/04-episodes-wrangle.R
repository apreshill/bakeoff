episodes <- readr::read_csv(here::here("data-raw", "episodes.csv"),
                         col_types = cols(series = col_factor(levels = NULL),
                                          episode = col_factor(levels = NULL),
                                          technical = col_integer()))

# end of exports
usethis::use_data(episodes, overwrite = TRUE)
