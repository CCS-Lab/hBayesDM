#' Plots the histogram of MCMC samples.
#'
#' @param sample MCMC samples
#' @param Title Character value containing the main title for the plot
#' @param xLab Character value containing the x label
#' @param yLab Character value containing the y label
#' @param xLim Vector containing the lower and upper x-bounds of the plot
#' @param fontSize Size of the font to use for plotting. Defaults to 10
#' @param binSize Size of the bins for creating the histogram. Defaults to 30
#' @param ... Arguments that can be additionally supplied to geom_histogram
#'
#' @importFrom ggplot2 ggplot geom_histogram theme xlab ylab geom_segment ggtitle aes
#'
#' @return h1 Plot object
#' @export

plotDist <- function(sample   = NULL,
                     Title    = NULL,
                     xLab     = "Value",
                     yLab     = "Density",
                     xLim     = NULL,
                     fontSize = NULL,
                     binSize  = NULL,
                     ...) {

  sample_df <- data.frame(sample)

  # To pass R CMD Checks (serves no other purpose than to create binding)
  ..density.. <- NULL

  if (is.null(xLim)) {
    xLim = range(sample)
  }
  h1 = ggplot(sample_df, aes(x = sample)) +
    ggplot2::theme_bw() +
    geom_histogram(aes(y = ..density..), colour = "black", fill = "grey", bins = binSize, na.rm = TRUE, ...) +
    ggtitle(Title) + xlab(xLab) + ylab(yLab) +
    ggplot2::xlim(xLim) +
    theme(axis.text.x = ggplot2::element_text(size = fontSize)) +
    theme(axis.text.y = ggplot2::element_text(size = fontSize)) +
    theme(axis.title.y = ggplot2::element_text(size = fontSize)) +
    theme(axis.title.x = ggplot2::element_text(size = fontSize)) +
    theme(plot.title = ggplot2::element_text(size = fontSize))

  return(h1)
}
