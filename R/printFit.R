#' Print model-fits (mean LOOIC and WAIC values) of hBayesDM Models
#' 
#' @param ... Model objects output by hBayesDM functions (e.g. output1, output2, etc.) 
#' @param ncore Numer of cores to use when computing leave-one-out cross-validation 
#' @param ic Which information criterion to use? 'looic', 'waic', or 'both'
#' @param roundTo Number of digits to the right of the decimal point in the output
#'
#' @return modelTable A table with relevant model comparison data 

#' @importFrom rstan rstan_options
#' @export  
#' @examples 
#' \dontrun{
#' # Run two models and store results in "output1" and "output2"
#' output1 <- dd_hyperbolic("example", 2000, 1000, 3, 3)
#'
#' output2 <- dd_exp("example", 2000, 1000, 3, 3)
#'
#' # Show the LOOIC model fit estimates 
#' printFit(output1, output2)
#' 
#' # To show the WAIC model fit estimates
#' printFit(output1, output2, ic="waic")
#' 
#' # To show both LOOIC and WAIC
#' printFit(output1, output2, ic="both")
#' }

printFit <- function(..., 
                        ncore    = 2, 
                        ic = "looic",
                        roundTo = 3) {
  
  modelList <- list(...)

  if (ic == "looic") {  # compute only LOOIC
    modelTable = data.frame(Model = NULL, LOOIC = NULL)
    for (i in 1:length(modelList)) {
      modelTable[i, "Model"] = modelList[[i]]$model
      modelTable[i, "LOOIC"] = round(extract_ic(modelList[[i]], core=ncore, ic="looic")$LOOIC$looic, roundTo)
    } 
  } else if (ic == "waic") { # compute only WAIC
    modelTable = data.frame(Model = NULL, WAIC = NULL)
    for (i in 1:length(modelList)) {
      modelTable[i, "Model"] = modelList[[i]]$model
      modelTable[i, "WAIC"]  = round(extract_ic(modelList[[i]], core=ncore, ic="waic")$WAIC$waic, roundTo)
    } 
  } else if (ic == "both") { # compute both LOOIC and WAIC
    modelTable = data.frame(Model = NULL, LOOIC = NULL, WAIC = NULL)
    for (i in 1:length(modelList)) {
      modelTable[i, "Model"] = modelList[[i]]$model
      modelTable[i, "LOOIC"] = round(extract_ic(modelList[[i]], core=ncore, ic="both")$LOOIC$looic, roundTo)
      modelTable[i, "WAIC"]  = round(extract_ic(modelList[[i]], core=ncore, ic="both")$WAIC$waic, roundTo)
    } 
  } else {
    stop("Set 'ic' as 'looic', 'waic' or 'both' \n")
  }
  return( modelTable )
}
