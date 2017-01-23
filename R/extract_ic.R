#' Extract Model Comparison Estimates
#' 
#' @param modelData Object returned by \code{'hBayesDM'} model function
#' @param ic Information Criterion. 'looic', 'waic', or 'both'
#' @param core Number of cores to use for leave-one-out estimation 
#' 
#' @importFrom loo extract_log_lik loo waic 
#'
#' @return IC Leave-One-Out and/or Watanabe-Akaike information criterion estimates. 
#'
#' @export 
#' @examples 
#' \dontrun{
#' library(hBayesDM)
#' output = bandit2arm_delta("example", niter=2000, nwarmup=1000, nchain=4, ncore = 1)
#' # To show the LOOIC model fit estimates (a detailed report; c)
#' extract_ic(output)
#' # To show the WAIC model fit estimates
#' extract_ic(output, ic="waic")
#' }
#' 
extract_ic <- function(modelData = NULL,  
                       ic = "looic",
                       core      = 2) {
  
  # Access fit within modelData
    stanFit <- modelData$fit
  
  # extract LOOIC and WAIC, from Stanfit
    IC <- list()
        
    lik    <- loo::extract_log_lik(stanfit = stanFit, parameter_name = 'log_lik')
    
    if (ic == "looic") {
      LOOIC  <- loo::loo(lik, cores = core)  
      IC$LOOIC <- LOOIC
    } else if (ic == "waic") {
      WAIC   <- loo::waic(lik)  
      IC$WAIC  <- WAIC
    } else if (ic == "both") {
      LOOIC  <- loo::loo(lik, cores = core)  
      WAIC   <- loo::waic(lik)  
      IC$LOOIC <- LOOIC
      IC$WAIC  <- WAIC  
    } else {
      stop("Set 'ic' as 'looic', 'waic' or 'both' \n")
    }

    return(IC)
}
