#' Spice Test
#'
#' Results of a knowledge test from Junior Bake Off (Series 2, Episode 14).
#'
#' @format A data frame with 4 rows representing baker results from the
#'   spice-based knowledge test and 7 variables:
#' \describe{
#'   \item{baker}{A character string with a given name or nickname.}
#'   \item{guess_1,guess_2,guess_3}{The different guesses (in order) for what
#'   the mystery spice was.}
#'   \item{correct_1,correct_2,correct_3}{An integer whether the guess was
#'   correct (`1`) or wrong (`0`).}
#' }
#' @examples
#' if (require('tibble')) {
#'   spice_test_wide
#'  }
#' head(spice_test_wide)
"spice_test_wide"
