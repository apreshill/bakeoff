results <- readr::read_csv(here::here("data-raw", "results.csv"),
                           col_types = cols(series = col_integer(),
                                            episode = col_integer()))

# end of exports
usethis::use_data(results, overwrite = TRUE)
