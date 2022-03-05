#
# Renaming of datasets
# These rda files can now be found in data-raw/built_data
#

# library(fs)
# library(tidyverse)
#
# data_dir <- "data-raw/built_data"
# fs::dir_ls(data_dir)
#
# rds_files <- fs::dir_ls(data_dir, regexp = "\\.rda$") %>%
#   here::here()
#
# rds_files %>%
#   walk(readRDS)

bakers_raw <- bakers
bakers <- baker_results
bakes_raw <- bakes
challenges <- challenge_results
episodes_raw <- episodes
episodes <- episode_results
ratings_raw <- ratings
ratings <- ratings_seasons
results_raw <- results
seasons_raw <- seasons
series_raw <- series
spice_test_wide <- spice_test_wide

# Build datasets in `./data`

usethis::use_data(
  bakers_raw,
  bakers,
  bakes_raw,
  challenges,
  episodes_raw,
  episodes,
  ratings_raw,
  ratings,
  results_raw,
  seasons_raw,
  series_raw,
  spice_test_wide,
  overwrite = TRUE,
  internal = TRUE
)
