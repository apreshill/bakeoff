#' Color scale constructor for bakeoff colors
#'
#' @param palette Character name of palette in bakeoff_palettes
#' @param discrete Boolean indicating whether color aesthetic is discrete or not
#' @param direction Either `1` or `-1`. If `-1`, the palette will be reversed.
#' @param ... Additional arguments passed to discrete_scale() or
#'            scale_color_gradientn(), used respectively when discrete is TRUE or FALSE
#'
#' @family colour scales
#' @name scale_bakeoff
#' @examples
#'
#' if (require('ggplot2')) {
#'
#'   ggplot(ratings, aes(x = episode, y = viewers_7day, group = series, color = series)) +
#'     geom_line(lwd = 3) +
#'     theme_minimal() +
#'     scale_color_bakeoff("finale", guide = FALSE)
#' }
#' @export
scale_color_bakeoff <- function(palette = "showstopper", discrete = TRUE, direction = 1, ...) {
  pal <- bakeoff_generate_pal(palette = palette, direction = direction)

  if (discrete) {
    ggplot2::discrete_scale(aesthetics = "colour",
                   scale_name = paste0("bakeoff_", palette),
                   palette = pal, ...)
  } else {
    ggplot2::scale_color_gradientn(colours = pal(10), ...)
  }
}


#' Fill scale constructor for bakeoff colors
#'
#' @param palette Character name of palette in bakeoff_palette
#' @param discrete Boolean indicating whether color aesthetic is discrete or not
#' @param direction Either `1` or `-1`. If `-1`, the palette will be reversed.
#' @param ... Additional arguments passed to discrete_scale() or
#'            scale_fill_gradientn(), used respectively when discrete is TRUE or FALSE
#' @rdname scale_bakeoff
#' @examples
#'
#' if (require('ggplot2')) {
#'
#'   ggplot(ratings, aes(x = episode_count, y = viewers_7day, fill = series)) +
#'     geom_col() +
#'     theme_minimal() +
#'     scale_fill_bakeoff("finale", guide = FALSE)
#' }
#' @export
scale_fill_bakeoff <- function(palette = "showstopper", discrete = TRUE, direction = 1, ...) {
  pal <- bakeoff_generate_pal(palette = palette, direction = direction)

  if (discrete) {
    ggplot2::discrete_scale(aesthetics = "fill",
                            scale_name = paste0("bakeoff_", palette),
                            palette = pal, ...)
  } else {
    ggplot2::scale_color_gradientn(colours = pal(10), ...)
  }
}

