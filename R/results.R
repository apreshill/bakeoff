#' Each baker's fate, by episode
#'
#' Results for all bakers per episode across all GBBO series
#'
#' @format A data frame with 886 rows representing individual bakers per episode and 4 variables:
#' \describe{
#'   \item{series}{an integer denoting UK series (1-8)}
#'   \item{episode}{an integer denoting episode number within a series}
#'   \item{baker}{a character string giving given or nickname only (note: see `bakers` for full baker names)}
#'   \item{result}{a character string denoting if the baker was `IN`, `OUT`, `STAR BAKER`, or `SICK` for a given episode. For finale episodes, values are either `WINNER` or `RUNNER-UP`. If `NA`, baker did not appear in episode.}
#' }
#' @source See \url{https://en.wikipedia.org/wiki/The_Great_British_Bake_Off_(series_1)#Results_summary}, for example, for series 1 results summary.
"results"
