#' Baker results
#'
#' Statistics summarizing each baker's performance during the series they appeared on.
#'
#' @format A data frame with 95 rows representing individual bakers and 24 variables:
#' \describe{
#'   \item{series}{an integer denoting UK series (1-10)}
#'   \item{baker_full}{a character string giving full name}
#'   \item{baker}{a character string giving given or nickname}
#'   \item{age}{an integer denoting age in years at first episode appeared}
#'   \item{occupation}{a character string giving occupation}
#'   \item{hometown}{a character string giving hometown}
#'   \item{baker_last}{a character string giving family name}
#'   \item{baker_first}{a character string giving given name}
#'   \item{star_baker}{an integer denoting the number of times a given baker won Star Baker}
#'   \item{technical_winner}{an integer denoting the number of times a given baker won first place in the technical challenge}
#'   \item{technical_top3}{an integer denoting the number of times a given baker was in the top 3 (1st, 2nd, or 3rd) on the technical challenge}
#'   \item{technical_bottom}{an integer denoting the number of times a given baker was in the bottom 3 on the technical challenge}
#'   \item{technical_highest}{an integer denoting the best technical rank earned by a given baker across all episodes appeared (higher is better)}
#'   \item{technical_lowest}{an integer denoting the worst technical rank earned by a given baker across all episodes appeared (higher is better)}
#'   \item{technical_median}{an integer denoting the median technical rank earned by a given baker across all episodes appeared (higher is better)}
#'   \item{series_winner}{an integer; 0 if not the series winner, 1 if series winner}
#'   \item{series_runner_up}{an integer; 0 if not a runner-up, 1 if a runner-up}
#'   \item{total_episodes_appeared}{an integer denoting the total number of episodes in which a given baker appeared}
#'   \item{first_date_appeared}{a date denoting original airdate of the first episode in which a given baker appeared (equivalent to the series premiere episode in the UK)}
#'   \item{last_date_appeared}{a date denoting original airdate of the last episode in which a given baker appeared (in the UK)}
#'   \item{first_date_us}{a date denoting original airdate of the first episode in which a given baker appeared (equivalent to the series premiere episode in the US)}
#'   \item{last_date_us}{a date denoting original airdate of the last episode in which a given baker appeared (in the US)}
#'   \item{percent_episodes_appeared}{a percentage denoting the number of episodes in a given series/season in which a given baker appeared out of all episodes aired in that series/season}
#'   \item{percent_technical_top3}{a percentage denoting the number of episodes in which a given baker placed in the top 3 for the technical challenge, out of the number of total episodes that the baker appeared in}
#' }
#' @source See \url{https://en.wikipedia.org/wiki/The_Great_British_Bake_Off_(series_1)#The_Bakers}, for example, for series 1 bakers.
"baker_results"
