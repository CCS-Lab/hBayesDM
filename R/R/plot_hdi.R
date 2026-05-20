#' Plots highest density interval (HDI) from (MCMC) samples and prints HDI in the R console.
#' HDI is indicated by a red line.
#' Based on John Kruschke's codes.
#'
#' @param sample MCMC samples
#' @param ci_prob A scalar between 0 and 1, indicating the mass within the credible interval that is to be estimated.
#' @param title Character value containing the main title for the plot
#' @param x_lab Character value containing the x label
#' @param y_lab Character value containing the y label
#' @param font_size Integer value specifying the font size to be used for the plot labels
#' @param bin_size Integer value specifyin ghow wide the bars on the histogram should be. Defaults to 30.
#' @param ... Arguments that can be additionally supplied to geom_histogram
#'
#' @return A vector containing the limits of the HDI
#'
#' @importFrom ggplot2 ggplot geom_histogram theme xlab ylab geom_segment ggtitle aes
#'
#' @export

plot_hdi <- function(sample   = NULL,
                    ci_prob  = 0.95,
                    title    = NULL,
                    x_lab     = "Value",
                    y_lab     = "Density",
                    font_size = NULL,
                    bin_size  = 30,
                    ...) {

  # To pass R CMD Checks (serves no other purpose than to create binding)
  ..density.. <- NULL

  HDI <- hdi(as.vector(t(sample)), ci_prob = ci_prob)  # 'sample' w/ data.frame class is also fine..
  sample_df <- data.frame(sample)

  h1 <- ggplot(sample_df, aes(x = sample)) +
               ggplot2::theme_bw() +
               geom_histogram(aes(y = ..density..), colour = "black", fill = "grey", bins = bin_size, ...) +
               ggtitle(title) + xlab(x_lab) + ylab(y_lab) +
               geom_segment(aes(x = HDI[1], y = 0, xend = HDI[2], yend = 0), linewidth = 1.5, colour = "red") +
               theme(axis.text.x = ggplot2::element_text(size = font_size)) +
               theme(axis.text.y = ggplot2::element_text(size = font_size)) +
               theme(axis.title.y = ggplot2::element_text(size = font_size)) +
               theme(axis.title.x = ggplot2::element_text(size = font_size)) +
               theme(plot.title = ggplot2::element_text(size = font_size))

  print(paste0(ci_prob*100, "% Highest Density Interval (HDI):"))
  print(paste0("Lower bound = ", round(HDI[1], 4), ", Upper bound = ", round(HDI[2], 4)))
  return(h1)
}
