#
# Renaming of datasets
#

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
