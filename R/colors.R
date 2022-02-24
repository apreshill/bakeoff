#' Define hex codes for named bakeoff colors
#' @noRd
bakeoff_color_data <- c(
  # peaches & corals,
  rose            = "#fdaba3",
  peach           = "#edbba8",
  garancemelon    = "#f27168",
  garancepeach    = "#f7d2b1",
  desertflower    = "#ff9a90",
  tenderpeach     = "#f8d6b8",
  livingcoral     = "#fa7268",

  # yellows & golds,
  garanceyellow   = "#fbed87",
  yellow          = "#fedb11",
  lemon           = "#e2bf54",
  garancegold     = "#b79f26",
  gold            = "#9d8e42",

  # oranges,
  garancemarigold = "#f4b31a",
  marigold        = "#ff7436",
  orange          = "#f0a561",
  tangerine       = "#ef8759",
  vibrantorange   = "#ff6d2d",

  # pinks & purples,
  berry           = "#ee5863",
  prismpink       = "#efa5c8",
  magenta         = "#fb82b7",
  violet          = "#c6b7d5",
  brightpink      = "#ed259d",
  flush           = "#ca225e",

  # reds,
  red             = "#e74a2f",
  maroon          = "#5f1f29",
  burgundy        = "#8e4866",
  cardinal        = "#b92f3b",

  # greens,
  mint            = "#deeee2",
  garden          = "#629d62",
  green           = "#5b8c4d",
  hunter          = "#284a29",
  pear            = "#d3dcaa",
  pine            = "#4c9a89",

  # blue greens,
  mason           = "#98c0b8",
  baltic          = "#1a9a9d",
  agategreen      = "#5da19a",
  riptide         = "#84d6d3",
  marina          = "#519199",
  opal            = "#bdd9d4",

  # light/bright blues,
  bluegrey        = "#6999cd",
  cobalt          = "#4254a7",
  sky             = "#7f8cb4",
  starlightblue   = "#b5d2dc",
  placidblue      = "#8daed7",
  bluebell        = "#8d91c9",
  matisse         = "#187ba2",

  # deep blues,
  brightnavy      = "#2f77c1",
  deepblue        = "#343c56",
  garanceblue     = "#283338",
  bluesapphire    = "#126180",
  blue            = "#1c5c6e",

  # neutrals,
  brick           = "#bc643a",
  almond          = "#543f29",
  charcoal        = "#313131",
  cocoa           = "#a5774c",
  garanceblack    = "#1a1917",
  garancegrey     = "#a09e9f",
  garancewhite    = "#efede8",
  grey            = "#95918d",
  nude            = "#fdd9b9",
  white           = "#f0eee9",
  linen           = "#f0d8c3",
  tobacco         = "#9a7c37"
)

#' Extract named **bakeoff** colors as hex codes
#'
#' Get a vector of hexadecimal color codes, or, extract a subset of colors as a
#' using defined color names (available using `names(bakeoff_colors())`).
#'
#' @param ... Character names of **bakeoff** colors. If none are specified,
#'   returns all. If any are specified, they can be listed by names in quotes
#'   (no need to combine with `c()`).
#'
#' @return A named character vector of hex colors.
#'
#' @examples
#' bakeoff_colors()
#' bakeoff_colors("riptide")
#' bakeoff_colors("baltic", "yellow")
#' names(bakeoff_colors())
#'
#' if (require('scales')) {
#'   scales::show_col(bakeoff_colors(), label = FALSE)
#' }
#'
#' @export
bakeoff_colors <- function(...) {
  cols <- c(...)

  if (is.null(cols))
    return (bakeoff_color_data)

  bakeoff_color_data[cols]
}

