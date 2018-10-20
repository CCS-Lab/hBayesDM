#' Print model-fits (mean LOOIC or WAIC values in addition to Akaike weights) of hBayesDM Models
#'
#' @param ... Model objects output by hBayesDM functions (e.g. output1, output2, etc.)
#' @param ic Which model comparison information criterion to use? 'looic', 'waic', or 'both
#' @param ncore Number of corse to use when computing LOOIC
#' @param roundTo Number of digits to the right of the decimal point in the output
#'
#' @return modelTable A table with relevant model comparison data. LOOIC and WAIC weights are computed as Akaike weights. 

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
#' printFit(output1, output2, ic = "waic")
#'
#' # To show both LOOIC and WAIC
#' printFit(output1, output2, ic = "both")
#' }

printFit <- function(..., 
                     ic      = "looic",
                     ncore   = 2,
                     roundTo = 3) {
  
  # Computes "Akaike weights" with LOOIC/WAIC values
  akaike_weights <- function (dev) {
    d <- dev - min(dev)
    f <- exp(-0.5 * d)
    w <- f/sum(f)
    return(w)
  }
  
  modelList <- list(...)

  if (ic == "looic") {  # compute only LOOIC
    modelTable = data.frame(Model = NULL, LOOIC = NULL)
    for (i in 1:length(modelList)) {
      modelTable[i, "Model"] = modelList[[i]]$model
      modelTable[i, "LOOIC"] = extract_ic(modelList[[i]], ic = "looic")$LOOIC$estimates[3,1]
    }
    modelTable[, "LOOIC Weights"] = akaike_weights(modelTable$LOOIC)
    modelTable[,2] <- round(modelTable[,2], roundTo)
  } else if (ic == "waic") { # compute only WAIC
    modelTable = data.frame(Model = NULL, WAIC = NULL)
    for (i in 1:length(modelList)) {
      modelTable[i, "Model"] = modelList[[i]]$model
      modelTable[i, "WAIC"]  = extract_ic(modelList[[i]], ic = "waic")$WAIC$estimates[3,1]
    }
    modelTable[, "WAIC Weights"] = akaike_weights(modelTable$WAIC)
    modelTable[,2] <- round(modelTable[,2], roundTo)
  } else if (ic == "both") { # compute both LOOIC and WAIC
    modelTable = data.frame(Model = NULL, LOOIC = NULL, WAIC = NULL)
    for (i in 1:length(modelList)) {
      modelTable[i, "Model"] = modelList[[i]]$model
      modelTable[i, "LOOIC"] = extract_ic(modelList[[i]], ic = "both")$LOOIC$estimates[3,1]
      modelTable[i, "WAIC"]  = extract_ic(modelList[[i]], ic = "both")$WAIC$estimates[3,1]
    }
    modelTable[, "LOOIC Weights"] = akaike_weights(modelTable$LOOIC)
    modelTable[, "WAIC Weights"] = akaike_weights(modelTable$WAIC)
    modelTable[,2:3] <- round(modelTable[,2:3], roundTo)
  } else {
    stop("Set 'ic' as 'looic', 'waic', or 'both' \n")
  }
  return(modelTable)
}
