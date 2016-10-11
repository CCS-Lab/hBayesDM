#' Extract Model Comparison Estimates
#' 
#' @param modelData Object returned by \code{'hBayesDM'} model function
#' @param core Number of cores to use for leave-one-out estimation 
#' 
#' @importFrom loo extract_log_lik loo waic 
#'
#' @return IC Leave-One-Out and Watanabe-Akaike information criterion estimates. 
#'
#' @export 

extract_ic <- function(modelData = NULL,  
                       core      = 2) {
  
  # Access fit within modelData
    stanFit <- modelData$fit
  
  # extract LOOIC and WAIC, from Stanfit
    IC <- list()
        
    lik    <- loo::extract_log_lik(stanfit = stanFit, parameter_name = 'log_lik')
    LOOIC  <- loo::loo(lik, cores = core)
    WAIC   <- loo::waic(lik)
    
    IC$LOOIC <- LOOIC
    IC$WAIC  <- WAIC
    
    return(IC)
}


