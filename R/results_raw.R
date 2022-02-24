#' Each baker's results by episode (raw)
#'
#' Results of each episode per baker across all 10 GBBO series.
#'
#' @format A data frame with 1,136 rows representing individual bakers per
#'   episode and 4 variables:
#' \describe{
#'   \item{series}{A factor denoting UK series (1-10)}
#'   \item{episode}{A factor denoting episode number within a series}
#'   \item{baker}{A character string giving given or nickname only (note: see
#'   `bakers` for full baker names)}
#'   \item{result}{A factor denoting if the baker was `"IN"`, `"OUT"`,
#'   `"STAR BAKER"`, or `"SICK"` for a given episode. For finale episodes,
#'   values are either `"WINNER"` or `"RUNNER-UP"`. If `NA`, baker did not
#'   appear in episode.}
#' }
#' @source See
#'   \url{https://en.wikipedia.org/wiki/The_Great_British_Bake_Off_(series_1)#Results_summary},
#'    for example, for series 1 results summary.
#' @examples
#' if (require('tibble')) {
#'   results_raw
#'  }
"results_raw"
