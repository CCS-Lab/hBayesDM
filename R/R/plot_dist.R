#' Plots the histogram of MCMC samples.
#'
#' @param sample MCMC samples
#' @param title Character value containing the main title for the plot
#' @param x_lab Character value containing the x label
#' @param y_lab Character value containing the y label
#' @param x_lim Vector containing the lower and upper x-bounds of the plot
#' @param font_size Size of the font to use for plotting. Defaults to 10
#' @param bin_size Size of the bins for creating the histogram. Defaults to 30
#' @param ... Arguments that can be additionally supplied to geom_histogram
#'
#' @importFrom ggplot2 ggplot geom_histogram theme xlab ylab geom_segment ggtitle aes
#'
#' @return h1 Plot object
#' @export

plot_dist <- function(sample   = NULL,
                     title    = NULL,
                     x_lab     = "Value",
                     y_lab     = "Density",
                     x_lim     = NULL,
                     font_size = NULL,
                     bin_size  = NULL,
                     ...) {

  sample_df <- data.frame(sample)

  # To pass R CMD Checks (serves no other purpose than to create binding)
  ..density.. <- NULL

  if (is.null(x_lim)) {
    x_lim = range(sample)
  }
  h1 = ggplot(sample_df, aes(x = sample)) +
    ggplot2::theme_bw() +
    geom_histogram(aes(y = ..density..), colour = "black", fill = "grey", bins = bin_size, na.rm = TRUE, ...) +
    ggtitle(title) + xlab(x_lab) + ylab(y_lab) +
    ggplot2::xlim(x_lim) +
    theme(axis.text.x = ggplot2::element_text(size = font_size)) +
    theme(axis.text.y = ggplot2::element_text(size = font_size)) +
    theme(axis.title.y = ggplot2::element_text(size = font_size)) +
    theme(axis.title.x = ggplot2::element_text(size = font_size)) +
    theme(plot.title = ggplot2::element_text(size = font_size))

  return(h1)
}
