#' Color scale constructor for **bakeoff** colors
#'
#' @param palette Character name of palette in \code{\link{bakeoff_palette_names}}.
#' @param discrete Boolean indicating whether color aesthetic is discrete or
#'   not.
#' @param direction Either `1` or `-1`. If `-1`, the palette will be reversed.
#' @param ... Additional arguments passed to [ggplot2::discrete_scale()] or
#'   [ggplot2::scale_color_gradientn()], used respectively when discrete is
#'   `TRUE` or `FALSE`.
#'
#' @return A function for constructing a color or a fill scale used for ggplot2 graphics.
#'
#' @examples
#' if (require('ggplot2')) {
#'
#'   ggplot(ratings, aes(x = episode, y = viewers_7day, group = series, color = as.factor(series))) +
#'     geom_line(lwd = 3) +
#'     theme_minimal() +
#'     scale_color_bakeoff("finale", guide = "none")
#' }
#'
#' @family colour scales
#' @name scale_bakeoff
NULL

#' @rdname scale_bakeoff
#' @export
scale_color_bakeoff <- function(palette = "showstopper",
                                discrete = TRUE,
                                direction = 1,
                                ...) {

  pal <- bakeoff_generate_pal(palette = palette, direction = direction)

  if (discrete) {

    ggplot2::discrete_scale(
      aesthetics = "colour",
      scale_name = paste0("bakeoff_", palette),
      palette = pal,
      ...
    )

  } else {
    ggplot2::scale_color_gradientn(colours = pal(10), ...)
  }
}

#' @rdname scale_bakeoff
#' @export
scale_fill_bakeoff <- function(palette = "showstopper",
                               discrete = TRUE,
                               direction = 1,
                               ...) {

  pal <- bakeoff_generate_pal(palette = palette, direction = direction)

  if (discrete) {

    ggplot2::discrete_scale(
      aesthetics = "fill",
      scale_name = paste0("bakeoff_", palette),
      palette = pal,
      ...
    )

  } else {
    ggplot2::scale_color_gradientn(colours = pal(10), ...)
  }
}

