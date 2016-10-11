#' General Purpose Plotting for hBayesDM. This function plots hyper parameters.
#'
#' @param x Model output of class hBayesDM
#' @param type Character value that specifies the plot type. Options are: "dist", "trace", or "simple". Defaults to "dist".
#' @param ncols Integer value specifying how many plots there should be per row. Defaults to the number of parameters.
#' @param fontSize Integer value specifying the size of the font used for plotting. Defaults to 10.
#' @param binSize Integer value specifyin ghow wide the bars on the histogram should be. Defaults to 30.
#' @param ... Additional arguments to be passed on 
#' 
#' @importFrom rstan traceplot
#' 
#' @method plot hBayesDM
#' @export

plot.hBayesDM <- function(x        = NULL,   # hBayesDM model output object
                          type     = "dist", # Default is ggplot hyperparameter distributions
                          ncols    = NULL,   # Defaults to the number of hyperparameters
                          fontSize = NULL,   # Defaults to 10
                          binSize  = NULL,   # Defaults to 30
                          ...) { 
                           
  
  # Find the number of parameters for the model
  numPars <- dim(x$allIndPars)[2] - 1
  
  # Find names of parameters for model
  parNames <- names(x$allIndPars)[1:numPars]
  
  if (type=="dist") {
    
    # Source functions containing model plotting functions
    source(file = system.file("plotting", "plot_functions.R", package="hBayesDM"),
           local = T)
    
    # Calling function for respective model
    eval(parse(text = paste0("plot_", x$model, "(obj = x",
                                               ", fontSize = ", fontSize,
                                               ", ncols = ", ncols, 
                                               ", binSize = ", binSize, ")")))
    invisible()
    
  } else if (type=="trace") {                                    
    rstan::traceplot(x$fit, pars = paste0("mu_", parNames), ncol = ncols, ...)  
    
  } else if (type=="simple") {                           
    rstan::plot(x$fit, pars = paste0("mu_", parNames), ...)         
  }
}


