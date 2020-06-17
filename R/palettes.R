#' Define hex codes for named bakeoff colors
bakeoff_hex_cols <- c(
  riptide     = "#84d6d3",
  bluesapphire= "#126180",
  baltic      = "#1a9a9d",
  placidblue  = "#8daed7",
  berry       = "#ee5863",
  tangerine   = "#ef8759",
  garanceyellow = "#fbed87",
  yellow      = "#fedb11",
  garden      = "#629d62",
  agategreen  = "#5da19a",
  prismpink   = "#efa5c8",
  magenta     = "#fb82b7",
  violet      = "#c6b7d5",
  marigold    = "#ff7436",
  orange      = "#f0a561",
  rose        = "#fdaba3",
  peach       = "#edbba8",
  garancemelon = "#f27168",
  garancepeach = "#f7d2b1",
  desertflower = "#ff9a90",
  tenderpeach = "#f8d6b8",
  livingcoral = "#fa7268",
  red         = "#e74a2f",
  maroon      = "#5f1f29",
  burgundy    = "#8e4866"
  )

#' Extract named bakeoff colors as hex codes
#'
#' @param ... Character names of bakeoff_colors
#' If none specified, returns all
#' If any specified, can be listed by names in quotes (no combine required)
#'
#' @export
bakeoff_colors <- function(...) {
  cols <- c(...)

  if (is.null(cols))
    return (bakeoff_hex_cols)

  bakeoff_hex_cols[cols]
}
#' @examples
#' bakeoff_colors()
#' bakeoff_colors("riptide")
#' bakeoff_colors("baltic", "yellow")
#'
#' library(scales)
#' show_col(bakeoff_colors())

#' Make bakeoff color palettes
bakeoff_palettes <- list(
  showstopper  = bakeoff_colors("bluesapphire", "magenta",
                       "berry", "riptide",
                       "baltic", "marigold",
                       "burgundy", "yellow",
                       "garden", "violet"),
  signature  = bakeoff_colors("maroon", "orange",
                            "tenderpeach", "riptide",
                            "baltic", "marigold",
                            "burgundy", "yellow",
                            "garden", "violet")
)
bakeoff_palette_names <- function() names(bakeoff_palettes)
#' @examples
#' bakeoff_palette_names()
#'
#'
#' Return function that creates a bakeoff color palette
#'
#' @param palette Character name of palette in bakeoff_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments to pass to colorRampPalette()
#'
#' @export
bakeoff_pal <- function(palette = "showstopper", direction = 1) {

  if (abs(direction) != 1) {
    stop("direction must be 1 or -1")
  }

  pal <- bakeoff_palettes[[palette]]
  color_list <- unname(unlist(pal))

  if (direction == -1) {
    color_list <- rev(color_list)
  }

  scales::manual_pal(color_list)
}
#' @examples
#' bakeoff_pal("showstopper") # returns a function
#' bakeoff_pal("showstopper")(4)
