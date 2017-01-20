#' Plots highest density interval (HDI) from (MCMC) samples and prints HDI in the R console. HDI is indicated by a red line. 
#' 
#' Based on John Kruschke's codes \url{http://www.indiana.edu/~kruschke/DoingBayesianDataAnalysis/}
#' @param sample MCMC samples
#' @param credMass A scalar between 0 and 1, indicating the mass within the credible interval that is to be estimated.
#' @param Title Character value containing the main title for the plot
#' @param xLab Character value containing the x label 
#' @param yLab Character value containing the y label 
#' @param fontSize Integer value specifying the font size to be used for the plot labels
#' @param binSize Integer value specifyin ghow wide the bars on the histogram should be. Defaults to 30.
#' @param ... Arguments that can be additionally supplied to geom_histogram
#' 
#' @return A vector containing the limits of the HDI
#' 
#' @importFrom ggplot2 ggplot geom_histogram theme xlab ylab geom_segment ggtitle aes
#'
#' @export 

plotHDI <- function(sample   = NULL, 
                    credMass = 0.95, 
                    Title    = NULL, 
                    xLab     = "Value", 
                    yLab     = "Density",
                    fontSize = NULL,
                    binSize  = 30,
                    ...) {
  
  # To pass R CMD Checks (serves no other purpose than to create binding)
  ..density.. <- NULL
  
  HDI <- HDIofMCMC( as.vector(t(sample)), credMass = credMass)  # 'sample' w/ data.frame class is also fine..
  sample_df <- data.frame(sample)
  
  h1 <- ggplot(sample_df, aes(x=sample)) + 
               ggplot2::theme_bw() +
               geom_histogram(aes(y=..density..), colour="black", fill="grey", bins = binSize, ...) + 
               ggtitle(Title) + xlab(xLab) + ylab(yLab) +
               geom_segment( aes(x = HDI[1], y = 0, xend = HDI[2], yend = 0), size=1.5, colour="red" ) +
               theme(axis.text.x=ggplot2::element_text(size=fontSize)) +
               theme(axis.text.y=ggplot2::element_text(size=fontSize)) +
               theme(axis.title.y=ggplot2::element_text(size=fontSize)) + 
               theme(axis.title.x=ggplot2::element_text(size=fontSize)) +
               theme(plot.title=ggplot2::element_text(size=fontSize)) 

  print( paste0(credMass*100, "% Highest Density Interval (HDI):") )
  print( paste0( "Lower bound=", round(HDI[1], 4), ", Upper bound=", round(HDI[2], 4)))
  return(h1)
}
