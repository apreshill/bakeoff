#' Bakers (raw)
#'
#' Information about each baker who has appeared on the show.
#'
#' @format A data frame with 120 rows representing individual bakers and 8
#'   variables:
#' \describe{
#'   \item{series}{A factor denoting UK series (`1`-`10`).}
#'   \item{baker_full}{A character string giving full name.}
#'   \item{baker}{A character string with a given name or nickname.}
#'   \item{age}{An integer denoting age in years at first episode appeared.}
#'   \item{occupation}{A character string giving occupation.}
#'   \item{hometown}{A character string giving hometown.}
#'   \item{baker_last}{A character string giving family name.}
#'   \item{baker_first}{A character string giving given name.}
#' }
#'
#' @source See
#'   \url{https://en.wikipedia.org/wiki/The_Great_British_Bake_Off_(series_1)#The_Bakers},
#'   for example, for series 1 bakers.
#' @examples
#' if (require('tibble')) {
#'   bakers_raw
#'  }
#' head(bakers_raw)
"bakers_raw"
