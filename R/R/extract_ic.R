#' Extract Model Comparison Estimates
#'
#' @param model_data Object returned by \code{'hBayesDM'} model function
#' @param ic Information Criterion. 'looic', 'waic', or 'both'
#' @param ncore Number of cores to use when computing LOOIC
#'
#' @importFrom loo relative_eff loo waic
#' @importFrom posterior as_draws_array
#'
#' @return IC Leave-One-Out and/or Watanabe-Akaike information criterion estimates.
#'
#' @export
#' @examples
#' \dontrun{
#' library(hBayesDM)
#' output = bandit2arm_delta("example", niter = 2000, nwarmup = 1000, nchain = 4, ncore = 1)
#' extract_ic(output)
#' extract_ic(output, ic = "waic")
#' }
extract_ic <- function(model_data = NULL,
                       ic        = "looic",
                       ncore     = 2) {
  if (!(ic %in% c("looic", "waic", "both")))
    stop("Set 'ic' as 'looic', 'waic' or 'both' \n")

  fit <- model_data$fit
  # cmdstanr fits expose draws via $draws(); extract log_lik with chain dim.
  draws_arr <- posterior::as_draws_array(fit$draws("log_lik"))
  # posterior arrays are [iter, chain, var]; loo expects [iter*chain, obs]
  n_iter <- dim(draws_arr)[1]
  n_chains <- dim(draws_arr)[2]
  n_obs <- dim(draws_arr)[3]
  lik <- matrix(aperm(draws_arr, c(2, 1, 3)),
                nrow = n_iter * n_chains, ncol = n_obs)

  rel_eff <- loo::relative_eff(
    exp(lik),
    chain_id = rep(seq_len(n_chains), each = n_iter),
    cores = getOption("mc.cores", ncore)
  )

  IC <- list()
  if (ic %in% c("looic", "both"))
    IC$LOOIC <- loo::loo(lik, r_eff = rel_eff,
                         cores = getOption("mc.cores", ncore))
  if (ic %in% c("waic", "both"))
    IC$WAIC <- loo::waic(lik)

  IC
}
