library(tidyverse)
ratings <- readr::read_csv(here::here("data-raw", "ratings.csv"),
                           col_types = cols(series = col_factor(levels = NULL),
                                            episode = col_factor(levels = NULL),
                                            network_rank = col_integer(),
                                            channels_rank = col_integer()))

# end of exports
usethis::use_data(ratings, overwrite = TRUE)
