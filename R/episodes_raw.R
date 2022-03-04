#' Each episodes' challenges (raw)
#'
#' Details about the three challenges (signature, technical, and showstopper)
#' for each baker/episode across all 10 GBBO series.
#'
#' @format A data frame with 704 rows representing individual bakers per episode
#'   and 6 variables:
#' \describe{
#'   \item{series}{A factor denoting UK series (`1`-`10`).}
#'   \item{episode}{A factor denoting episode number within a series.}
#'   \item{baker}{A character string giving given or nickname.}
#'   \item{signature}{A character string containing the bake for the signature
#'   challenge for that baker/episode.}
#'   \item{technical}{An integer denoting the rank on the technical challenge
#'   for that baker/episode. A rank of `1` is winner of the technical
#'   challenge.}
#'   \item{showstopper}{A character string containing the bake for the
#'   showstopper challenge for that baker/episode.}
#' }
#'
#' @source See
#'   \url{https://en.wikipedia.org/wiki/The_Great_British_Bake_Off#Format}
#' @examples
#' if (require('tibble')) {
#'   episodes_raw
#'  }
#' head(episodes_raw)
"episodes_raw"
