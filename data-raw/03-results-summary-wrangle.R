results <- readr::read_csv(here::here("data-raw", "results.csv"),
                           col_types = cols(series = col_factor(levels = NULL),
                                            episode = col_factor(levels = NULL),
                                            result = col_factor(levels = NULL)))

# end of exports
usethis::use_data(results, overwrite = TRUE)
