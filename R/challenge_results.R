#' Challenge results
#'
#' Details about the three challenges (signature, technical, and showstopper)
#' for each baker/episode across all GBBO series, and who was eliminated, who
#' won star baker, or if finale, who won and who was runner up. This joined
#' tibble is made by joining the [challenges] and [results] *Simple Tibbles* by
#' `series`, `episode`, and `baker`.
#'
#' @format A data frame with 886 rows representing individual bakers per episode
#'   and 7 variables:
#' \describe{
#'   \item{series}{an integer denoting UK series (1-8)}
#'   \item{episode}{an integer denoting episode number within a series}
#'   \item{baker}{a character string giving given or nickname}
#'   \item{result}{a character string denoting if the baker was `IN`, `OUT`,
#'   `STAR BAKER`, or `SICK` for a given episode. For finale episodes, values
#'   are either `WINNER` or `RUNNER-UP`. If `NA`, the baker did not appear in
#'   episode.}
#'   \item{signature}{a character string containing the bake for the signature
#'   challenge for that baker/episode. If `NA`, baker did not appear in
#'   episode.}
#'   \item{technical}{an integer denoting the rank on the technical challenge
#'   for that baker/episode; rank = 1 is winner of the technical challenge. If
#'   `NA`, baker did not appear in episode.}
#'   \item{showstopper}{a character string containing the bake for the
#'   showstopper challenge for that baker/episode. If `NA`, baker did not
#'   appear in episode.}
#' }
#' @source See
#'   \url{https://en.wikipedia.org/wiki/The_Great_British_Bake_Off#Format}
"challenge_results"
