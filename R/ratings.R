#' Ratings
#'
#' This dataset has one row per episode and includes ratings plus
#' original airdates in the UK (by series) and US
#' (by season). This dataset is made by joining the \code{\link{ratings_raw}}
#' and \code{\link{seasons_raw}} datasets by both `series` and `episode`.
#'
#' @format A data frame with 94 rows representing individual episodes and 11
#'   variables:
#' \describe{
#'   \item{series}{An integer denoting UK series (`1`-`10`).}
#'   \item{episode}{An integer denoting episode number within a series.}
#'   \item{episode_count}{An integer denoting continuous episode number across series (`1`-`94`)}
#'   \item{uk_airdate}{A date denoting original airdate of episode in the UK.}
#'   \item{viewers_7day}{The number of viewers in millions within a 7-day window
#'   from airdate.}
#'   \item{viewers_28day}{The number of viewers in millions within a 28-day
#'   window from airdate.}
#'   \item{network_rank}{An integer denoting the episode's weekly ranking within
#'   network (note that the networks changed for series 8 and later).}
#'   \item{channels_rank}{An integer denoting the episode's weekly ranking
#'   across all channels.}
#'   \item{bbc_iplayer_requests}{Number of BBC iPlayer requests (note: not
#'   available for all series, and only for series that aired on the BBC).}
#'   \item{us_season}{An integer denoting US season (`1`-`5`).}
#'   \item{us_airdate}{A date denoting original airdate of episode in the US,
#'   according to
#'   [pbs.org](https://www.pbs.org/food/shows/great-british-baking-show/).}
#'   }
#' @source See
#'   \url{https://en.wikipedia.org/wiki/The_Great_British_Bake_Off_(series_1)#Ratings}
#' @examples
#' if (require('tibble')) {
#'   ratings
#'  }
#' head(ratings)
"ratings"
