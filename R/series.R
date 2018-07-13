#' Series
#'
#' Metadata for all GBBO series
#'
#' @format A data frame with 8 rows representing individual series and 11 variables:
#' \describe{
#'   \item{series}{an integer denoting UK series (1-8)}
#'   \item{episodes}{an integer denoting total number of episodes within series}
#'   \item{premiere}{a date denoting original airdate of series premiere episode in the UK}
#'   \item{finale}{a date denoting original airdate of series finale episode in the UK}
#'   \item{winner}{a character string denoting name of series winner}
#'   \item{avg_uk_viewers}{average UK viewers in millions; also see `ratings`}
#'   \item{day_of_week}{a character string denoting weekday that series' episodes aired in UK}
#'   \item{timeslot}{time of day that series' episodes aired in UK (24-hour clock)}
#'   \item{channel}{a character string denoting channel that series aired on: one of `BBC One`, `BBC Two`, or `Channel 4`}
#'   \item{runner_up_1}{a character string denoting the name of one of the bakers who was a series runner-up; number is not meaningful}
#'   \item{runner_up_2}{a character string denoting the name of one of the bakers who was a series runner-up; number is not meaningful}
#' }
#' @source See \url{https://en.wikipedia.org/wiki/The_Great_British_Bake_Off}
"series"
