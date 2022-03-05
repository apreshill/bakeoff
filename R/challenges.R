#' Challenges
#'
#' Details about the three challenges (`"signature"`, `"technical"`, and
#' `"showstopper"`) for each baker/episode across all GBBO series. Who was
#' eliminated? Who won star baker? In the finale, who won and who was runner up?
#'
#' @format A data frame with 1,136 rows representing individual bakers per episode
#'   and 7 variables:
#' \describe{
#'   \item{series}{An integer denoting the UK series number (`1`-`10`).}
#'   \item{episode}{An integer denoting episode number within a series.}
#'   \item{baker}{A character string with a given name or nickname.}
#'   \item{result}{A character string denoting if the baker was `IN`, `OUT`,
#'   `STAR BAKER`, or `SICK` for a given episode. For finale episodes, values
#'   are either `WINNER` or `Runner-up`. If `NA`, the baker did not appear in
#'   episode.}
#'   \item{signature}{A character string containing the bake for the signature
#'   challenge for that baker/episode. If `NA`, the baker did not appear in
#'   episode.}
#'   \item{technical}{An integer denoting the rank on the technical challenge
#'   for that baker/episode. A value of `1` means the baker was the winner of
#'   the technical challenge. If `NA`, the baker did not appear in the
#'   episode.}
#'   \item{showstopper}{A character string containing the bake for the
#'   showstopper challenge for that baker/episode. If `NA`, the baker did not
#'   appear in episode.}
#' }
#' @source See
#'   \url{https://en.wikipedia.org/wiki/The_Great_British_Bake_Off#Format}
#' @examples
#' if (require('tibble')) {
#'   challenges
#'  }
#' head(challenges)
"challenges"
