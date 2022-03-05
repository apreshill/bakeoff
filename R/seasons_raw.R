#' Data about each season aired in the US (raw)
#'
#' This data has one row per season aired in the US as 'The Great British
#' Baking Show'.
#'
#' @format A data frame with 8 rows representing individual series and 11
#'   variables:
#' \describe{
#'   \item{series}{an integer denoting UK series (`1`-`8`)}
#'   \item{episode}{an integer denoting total number of episodes within series}
#'   \item{us_season}{an integer denoting US season (`1`-`5`)}
#'   \item{us_airdate}{a date denoting original airdate of episode in the US,
#'   according to
#'   [pbs.org](https://www.pbs.org/food/shows/great-british-baking-show/)}
#' }
#'
#' @source US airdates manually recorded from
#'   \url{https://www.pbs.org/food/shows/great-british-baking-show/}
#' @examples
#' if (require('tibble')) {
#'   seasons_raw
#'  }
#' head(seasons_raw)
"seasons_raw"
