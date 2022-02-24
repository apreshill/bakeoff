
delayedAssign("bakers_raw", local({
  if (requireNamespace("tibble", quietly = TRUE)) {
    tibble::as_tibble(bakeoff:::bakers_raw)
  } else {
    bakeoff:::bakers_raw
  }
}))

delayedAssign("bakers", local({
  if (requireNamespace("tibble", quietly = TRUE)) {
    tibble::as_tibble(bakeoff:::bakers)
  } else {
    bakeoff:::bakers
  }
}))

delayedAssign("bakes_raw", local({
  if (requireNamespace("tibble", quietly = TRUE)) {
    tibble::as_tibble(bakeoff:::bakes_raw)
  } else {
    bakeoff:::bakes_raw
  }
}))

delayedAssign("challenges", local({
  if (requireNamespace("tibble", quietly = TRUE)) {
    tibble::as_tibble(bakeoff:::challenges)
  } else {
    bakeoff:::challenges
  }
}))

delayedAssign("episodes_raw", local({
  if (requireNamespace("tibble", quietly = TRUE)) {
    tibble::as_tibble(bakeoff:::episodes_raw)
  } else {
    bakeoff:::episodes_raw
  }
}))

delayedAssign("episodes", local({
  if (requireNamespace("tibble", quietly = TRUE)) {
    tibble::as_tibble(bakeoff:::episodes)
  } else {
    bakeoff:::episodes
  }
}))

delayedAssign("ratings_raw", local({
  if (requireNamespace("tibble", quietly = TRUE)) {
    tibble::as_tibble(bakeoff:::ratings_raw)
  } else {
    bakeoff:::ratings_raw
  }
}))

delayedAssign("ratings", local({
  if (requireNamespace("tibble", quietly = TRUE)) {
    tibble::as_tibble(bakeoff:::ratings)
  } else {
    bakeoff:::ratings
  }
}))

delayedAssign("results_raw", local({
  if (requireNamespace("tibble", quietly = TRUE)) {
    tibble::as_tibble(bakeoff:::results_raw)
  } else {
    bakeoff:::results_raw
  }
}))

delayedAssign("seasons_raw", local({
  if (requireNamespace("tibble", quietly = TRUE)) {
    tibble::as_tibble(bakeoff:::seasons_raw)
  } else {
    bakeoff:::seasons_raw
  }
}))

delayedAssign("series_raw", local({
  if (requireNamespace("tibble", quietly = TRUE)) {
    tibble::as_tibble(bakeoff:::series_raw)
  } else {
    bakeoff:::series_raw
  }
}))

delayedAssign("spice_test_wide", local({
  if (requireNamespace("tibble", quietly = TRUE)) {
    tibble::as_tibble(bakeoff:::spice_test_wide)
  } else {
    bakeoff:::spice_test_wide
  }
}))
