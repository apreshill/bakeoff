#' Define the colors
bakeoff_colors <- c(
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
  burgundy    = "#8e4866")

#' Function to extract bakeoff colors as hex codes
#'
#' @param ... Character names of bakeoff_colors
#' If none specified, returns all
#' If any specified, can be listed by names in quotes (no combine required)
#'
#' @export
bakeoff_cols <- function(...) {
  cols <- c(...)

  if (is.null(cols))
    return (bakeoff_colors)

  bakeoff_colors[cols]
}
#' @examples
#' bakeoff_cols()
#' bakeoff_cols("riptide")
#' bakeoff_cols("baltic", "yellow")

bakeoff_palette <- list(
  main  = bakeoff_cols("bluesapphire", "magenta",
                       "berry", "riptide",
                       "baltic", "marigold",
                       "burgundy", "yellow")
)


#' Return function to interpolate a bakeoff color palette
#'
#' @param palette Character name of palette in bakeoff_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments to pass to colorRampPalette()
#'
#' @export
bakeoff_pal <- function(palette = "main", reverse = FALSE, ...) {
  pal <- bakeoff_palette[[palette]]

  if (reverse)
    pal <- rev(pal)
  colorRampPalette(pal, ...)
}
#' @examples
#' bakeoff_pal("main") # returns a function
#' bakeoff_pal("main")(8)

#' Color scale constructor for bakeoff colors
#'
#' # Use bakeoff_d with discrete data
#' @param palette Character name of palette in bakeoff_palettes
#' @param discrete Boolean indicating whether color aesthetic is discrete or not
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to discrete_scale() or
#'            scale_color_gradientn(), used respectively when discrete is TRUE or FALSE
#'
#' @family colour scales
#' @rdname scale_bakeoff
#' @export
scale_color_bakeoff <- function(palette = "main", discrete = TRUE, reverse = FALSE, ...) {
  pal <- bakeoff_pal(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale(aesthetics = "colour",
                   scale_name = paste0("bakeoff_", palette),
                   palette = pal, ...)
  } else {
    ggplot2::scale_color_gradientn(colours = pal(256), ...)
  }
}

#' # Use viridis_c with continous data

#' Fill scale constructor for bakeoff colors
#'
#' @param palette Character name of palette in bakeoff_palette
#' @param discrete Boolean indicating whether color aesthetic is discrete or not
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to discrete_scale() or
#'            scale_fill_gradientn(), used respectively when discrete is TRUE or FALSE
#'
#' @export
scale_fill_bakeoff <- function(palette = "main", discrete = TRUE, reverse = FALSE, ...) {
  pal <- bakeoff_pal(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale(aesthetics = "fill",
                            scale_name = paste0("bakeoff_", palette),
                            palette = pal, ...)
  } else {
    scale_fill_gradientn(colours = pal(256), ...)
  }
}
