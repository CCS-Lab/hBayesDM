#' Print model-fits (mean LOOIC or WAIC values in addition to Akaike weights) of hBayesDM Models
#'
#' @param ... Model objects output by hBayesDM functions (e.g. output1, output2, etc.)
#' @param ic Which model comparison information criterion to use? 'looic', 'waic', or 'both
#' @param ncore Number of corse to use when computing LOOIC
#' @param round_to Number of digits to the right of the decimal point in the output
#'
#' @return model_table A table with relevant model comparison data. LOOIC and WAIC weights are computed as Akaike weights. 

#' @export
#' @examples
#' \dontrun{
#' # Run two models and store results in "output1" and "output2"
#' output1 <- dd_hyperbolic("example", 2000, 1000, 3, 3)
#'
#' output2 <- dd_exp("example", 2000, 1000, 3, 3)
#'
#' # Show the LOOIC model fit estimates
#' print_fit(output1, output2)
#'
#' # To show the WAIC model fit estimates
#' print_fit(output1, output2, ic = "waic")
#'
#' # To show both LOOIC and WAIC
#' print_fit(output1, output2, ic = "both")
#' }

print_fit <- function(..., 
                     ic      = "looic",
                     ncore   = 2,
                     round_to = 3) {
  
  # Computes "Akaike weights" with LOOIC/WAIC values
  akaike_weights <- function (dev) {
    d <- dev - min(dev)
    f <- exp(-0.5 * d)
    w <- f/sum(f)
    return(w)
  }
  
  model_list <- list(...)

  if (ic == "looic") {  # compute only LOOIC
    model_table = data.frame(Model = NULL, LOOIC = NULL)
    for (i in 1:length(model_list)) {
      model_table[i, "Model"] = model_list[[i]]$model
      model_table[i, "LOOIC"] = extract_ic(model_list[[i]], ic = "looic")$LOOIC$estimates[3,1]
    }
    model_table[, "LOOIC Weights"] = akaike_weights(model_table$LOOIC)
    model_table[,2] <- round(model_table[,2], round_to)
  } else if (ic == "waic") { # compute only WAIC
    model_table = data.frame(Model = NULL, WAIC = NULL)
    for (i in 1:length(model_list)) {
      model_table[i, "Model"] = model_list[[i]]$model
      model_table[i, "WAIC"]  = extract_ic(model_list[[i]], ic = "waic")$WAIC$estimates[3,1]
    }
    model_table[, "WAIC Weights"] = akaike_weights(model_table$WAIC)
    model_table[,2] <- round(model_table[,2], round_to)
  } else if (ic == "both") { # compute both LOOIC and WAIC
    model_table = data.frame(Model = NULL, LOOIC = NULL, WAIC = NULL)
    for (i in 1:length(model_list)) {
      model_table[i, "Model"] = model_list[[i]]$model
      model_table[i, "LOOIC"] = extract_ic(model_list[[i]], ic = "both")$LOOIC$estimates[3,1]
      model_table[i, "WAIC"]  = extract_ic(model_list[[i]], ic = "both")$WAIC$estimates[3,1]
    }
    model_table[, "LOOIC Weights"] = akaike_weights(model_table$LOOIC)
    model_table[, "WAIC Weights"] = akaike_weights(model_table$WAIC)
    model_table[,2:3] <- round(model_table[,2:3], round_to)
  } else {
    stop("Set 'ic' as 'looic', 'waic', or 'both' \n")
  }
  return(model_table)
}
