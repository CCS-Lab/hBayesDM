#' Function to estimate mode of MCMC samples
#' 
#' Based on codes from 'http://stackoverflow.com/questions/2547402/is-there-a-built-in-function-for-finding-the-mode'
#' see the comment by Rasmus Baath
#' 
#' @param x MCMC samples or some numeric or array values. 
#' @importFrom stats density
#' @export 
#' 
estimate_mode <- function(x) {
  d = density(x)
  Estimate = d$x[which.max(d$y)]
  return(Estimate)
}
