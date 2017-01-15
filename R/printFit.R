#' Print model-fits (mean LOOIC and WAIC values) of hBayesDM Models
#' 
#' @param ... Model objects output by hBayesDM functions (e.g. output1, output2, etc.) 
#' @param ncore Numer of cores to use when computing leave-one-out cross-validation 
#' @param ic Which information criterion to use? 'looic', 'waic', or 'both'
#' @param roundTo Number of digits to the right of the decimal point in the output
#'
#' @return modelTable A table with relevant model comparison data 
#'
#' @export 
#' 
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
  
  for (i in 1:length(modelList)) {
    if (ic =="looic") {
      modelTable = data.frame(Model = NULL, LOOIC = NULL)
      modelTable[i, "Model"] = modelList[[i]]$model
      modelTable[i, "LOOIC"] = round(extract_ic(modelList[[i]], core=ncore)$LOOIC$looic, roundTo)
    } else if (ic == "waic") {
      modelTable = data.frame(Model = NULL, WAIC = NULL)
      modelTable[i, "Model"] = modelList[[i]]$model
      modelTable[i, "WAIC"]  = round(extract_ic(modelList[[i]], core=ncore)$WAIC$waic, roundTo)
    } else if (ic == "both") {
      modelTable = data.frame(Model = NULL, LOOIC = NULL, WAIC = NULL)
      modelTable[i, "Model"] = modelList[[i]]$model
      modelTable[i, "LOOIC"] = round(extract_ic(modelList[[i]], core=ncore)$LOOIC$looic, roundTo)
      modelTable[i, "WAIC"]  = round(extract_ic(modelList[[i]], core=ncore)$WAIC$waic, roundTo)
    }
  } 
  return( modelTable )
}
