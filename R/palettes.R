#' Define bakeoff color palettes from named colors
bakeoff_palettes <- list(
  showstopper  = bakeoff_colors("cobalt", "magenta",
                       "berry", "riptide",
                       "baltic", "marigold",
                       "burgundy", "yellow",
                       "garden", "violet"),
  signature  = bakeoff_colors("blue", "garancemelon",
                            "garanceyellow", "prismpink",
                            "hunter", "bluegrey",
                            "agategreen", "maroon",
                            "garancegrey", "tangerine"),
  finale = bakeoff_colors("brightnavy", "prismpink",
                          "pine", "opal",
                          "brightpink", "bluebell",
                          "garancemarigold", "desertflower",
                          "baltic", "cardinal")
)
#' Print names of all bakeoff color palettes
#'
#' @examples
#' bakeoff_palette_names()
#' @export
bakeoff_palette_names <- function() names(bakeoff_palettes)
#'
#'
#' A bakeoff palette generator
#'
#' @param n Number of colors desired. All palettes have 10 colors,
#' matching the total number of series and maximum number of episodes per series.
#' If omitted, uses all colors.
#'
#' @param name Name of desired palette.
#' @param direction Either `1` or `-1`. If `-1`, the palette will be reversed.
#' @param type Either "continuous" or "discrete". Use continuous if you want
#'   to automatically interpolate between colors.
#' @return A vector of colors.
#' @keywords colors
#' @examples
#' bakeoff_palette("showstopper")
#'
#' if (require('scales')) {
#'   show_col(bakeoff_palette("finale"))
#'   }
#'
#' if (require('ggplot2')) {
#' line_plot <- ggplot(ratings, aes(x = episode, y = viewers_7day,
#' color = series, group = series)) + facet_wrap(~series) + geom_line(lwd = 2)
#' line_plot + scale_color_manual(values = bakeoff_palette(), guide = FALSE)
#'
#' ggplot(episodes, aes(episode, fill = series)) + geom_bar() + facet_wrap(~series) +
#' scale_fill_manual(values = bakeoff_palette("signature"), guide = FALSE)
#' }
#'
#' # If you need more colors than normally found in a palette, you
#' # can use a continuous palette to interpolate between existing
#' # colours
#' pal <- bakeoff_palette(palette = "finale", n = 20, type = "continuous")
#' if (require('scales')) {
#' show_col(pal)
#' }
#' @export
bakeoff_palette <- function(palette = "showstopper", n, direction = 1, type = c("discrete", "continuous")) {

  if (abs(direction) != 1) {
    stop("direction must be 1 or -1")
  }

  pal <- bakeoff_palettes[[palette]]
  color_list <- unname(unlist(pal))
  if (is.null(color_list))
    stop("Palette not found.")

  if (missing(n)) {
    n <- length(color_list)
  }

  type <- match.arg(type)

  if (type == "discrete" && n > length(color_list)) {
    stop(paste0("Number of requested colors greater than what palette can offer, which is ",
                length(color_list), "."))
  }

  out <- switch(type,
                continuous = grDevices::colorRampPalette(color_list)(n),
                discrete = color_list[1:n]
  )

  if (direction == -1) {
    out <- rev(out)
  }

  structure(out, class = "palette", name = palette)
}

#' Return function that creates a bakeoff color palette
#' Mainly useful for creating ggplot2 scales
#'
#' @param palette Character name of palette in bakeoff_palettes
#' @param direction Either `1` or `-1`. If `-1`, the palette will be reversed.
#'
bakeoff_generate_pal <- function(palette, direction) {

  function(n) {
    bakeoff_palette(palette = palette, direction = direction)
  }

}


#' @export
print.palette <- function(x, ...) {
  n <- length(x)
  old <- graphics::par(mar = c(0.5, 0.5, 0.5, 0.5))
  on.exit(graphics::par(old))

  graphics::image(1:n, 1, as.matrix(1:n), col = x,
        ylab = "", xaxt = "n", yaxt = "n", bty = "n")

  graphics::rect(0, 0.9, n + 1, 1.1, col = grDevices::rgb(1, 1, 1, 0.8), border = NA)
  graphics::text((n + 1) / 2, 1, labels = attr(x, "name"), cex = 1, family = "serif")
}
