#' Extract Model Comparison Estimates
#'
#' @param modelData Object returned by \code{'hBayesDM'} model function
#' @param ic Information Criterion. 'looic', 'waic', or 'both'
#' @param ncore Number of corse to use when computing LOOIC
#'
#' @importFrom loo extract_log_lik relative_eff loo waic
#'
#' @return IC Leave-One-Out and/or Watanabe-Akaike information criterion estimates.
#'
#' @export
#' @examples
#' \dontrun{
#' library(hBayesDM)
#' output = bandit2arm_delta("example", niter = 2000, nwarmup = 1000, nchain = 4, ncore = 1)
#' # To show the LOOIC model fit estimates (a detailed report; c)
#' extract_ic(output)
#' # To show the WAIC model fit estimates
#' extract_ic(output, ic = "waic")
#' }
#'
extract_ic <- function(modelData = NULL,
                       ic        = "looic", 
                       ncore     = 2) {
  
  # Access fit within modelData
  stanFit  <- modelData$fit
  n_chains <- length(stanFit@stan_args)
  
  # extract LOOIC and WAIC, from Stanfit
  IC <- list()
  
  lik     <- loo::extract_log_lik(stanfit = stanFit, parameter_name = 'log_lik')
  rel_eff <- loo::relative_eff(exp(lik), chain_id = rep(1:n_chains, nrow(lik)/n_chains), cores = getOption("mc.cores", ncore))
  
  if (ic == "looic") {
    IC$LOOIC <- loo::loo(lik, r_eff = rel_eff, cores = getOption("mc.cores", ncore))
  } else if (ic == "waic") {
    IC$WAIC <- loo::waic(lik)
  } else if (ic == "both") {
    IC$LOOIC <- loo::loo(lik, r_eff = rel_eff, cores = getOption("mc.cores", ncore))
    IC$WAIC  <- loo::waic(lik)
  } else {
    stop("Set 'ic' as 'looic', 'waic' or 'both' \n")
  }
  
  return(IC)
}
