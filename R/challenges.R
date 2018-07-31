#' Each baker's signature, technical, and showstopper challenges, by episode
#'
#' Details about the three challenges (signature, technical, and showstopper) for each baker/episode across all GBBO series
#'
#' @format A data frame with 548 rows representing individual bakers per episode and 6 variables:
#' \describe{
#'   \item{series}{an integer denoting UK series (1-8)}
#'   \item{episode}{an integer denoting episode number within a series}
#'   \item{baker}{a character string giving given or nickname}
#'   \item{signature}{a character string containing the bake for the signature challenge for that baker/episode}
#'   \item{technical}{an integer denoting the rank on the technical challenge for that baker/episode; rank = 1 is winner of the technical challenge}
#'   \item{showstopper}{a character string containing the bake for the showstopper challenge for that baker/episode}
#' }
#' @source See \url{https://en.wikipedia.org/wiki/The_Great_British_Bake_Off#Format}
"challenges"
