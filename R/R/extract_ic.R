#' Extract Model Comparison Estimates
#'
#' @param model_data Object returned by \code{'hBayesDM'} model function
#' @param ic Information Criterion. 'looic', 'waic', or 'both'
#' @param ncore Number of cores to use when computing LOOIC
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
extract_ic <- function(model_data = NULL,
                       ic        = "looic",
                       ncore     = 2) {
  if (!(ic %in% c("looic", "waic", "both")))
    stop("Set 'ic' as 'looic', 'waic' or 'both' \n")

  # Access fit within model_data
  stan_fit  <- model_data$fit
  n_chains <- length(stan_fit@stan_args)

  # extract LOOIC and WAIC, from Stanfit
  IC <- list()

  lik     <- loo::extract_log_lik(
      stanfit = stan_fit,
      parameter_name = "log_lik")

  rel_eff <- loo::relative_eff(
      exp(lik),
      chain_id = rep(1:n_chains, each = nrow(lik) / n_chains),
      cores = getOption("mc.cores", ncore))

  if (ic %in% c("looic", "both"))
    IC$LOOIC <- loo::loo(lik, r_eff = rel_eff,
                         cores = getOption("mc.cores", ncore))

  if (ic %in% c("waic", "both"))
    IC$WAIC <- loo::waic(lik)

  return(IC)
}
