#' Internal helpers for fitting hBayesDM Stan models via cmdstanr.
#'
#' Wraps the cmdstanr API so per-task R files don't have to know about it.
#' Compiled Stan binaries are cached next to the source `.stan` files.
#'
#' @keywords internal
#' @name hbayesdm-cmdstan
NULL

#' Locate the .stan file for a given hBayesDM model name.
#' @keywords internal
.hbayesdm_stan_file <- function(model_name) {
  path <- system.file("stan_files", paste0(model_name, ".stan"),
                      package = "hBayesDM")
  if (!nzchar(path) || !file.exists(path)) {
    stop("Stan file for model '", model_name, "' not found in package.")
  }
  path
}

#' Load (and compile if necessary) a CmdStanModel for an hBayesDM model.
#'
#' cmdstanr lazily compiles on first use and caches the binary, so subsequent
#' calls are fast.
#' @keywords internal
.hbayesdm_compile <- function(model_name) {
  stan_file <- .hbayesdm_stan_file(model_name)
  include_dir <- dirname(stan_file)
  cmdstanr::cmdstan_model(
    stan_file = stan_file,
    include_paths = include_dir,
    compile = TRUE
  )
}

#' Fit an hBayesDM Stan model via cmdstanr.
#'
#' Returns a list with fields `fit` (the CmdStanMCMC/CmdStanVB), `par_vals`
#' (named list of draws merged across chains), and `vb` (logical).
#' @keywords internal
.hbayesdm_fit <- function(model_name,
                          data_list,
                          pars,
                          gen_init,
                          vb,
                          nchain,
                          niter,
                          nwarmup,
                          nthin,
                          adapt_delta,
                          stepsize,
                          max_treedepth,
                          ncore,
                          seed = 42,
                          inc_postpred = FALSE,
                          postpreds = NULL) {
  stan_model <- .hbayesdm_compile(model_name)
  inits <- .hbayesdm_resolve_inits(gen_init, nchain)

  if (vb) {
    fit <- stan_model$variational(data = data_list, init = inits, seed = seed)
  } else {
    iter_sampling <- max(1L, niter - nwarmup)
    fit <- stan_model$sample(
      data            = data_list,
      chains          = nchain,
      parallel_chains = ncore,
      iter_warmup     = nwarmup,
      iter_sampling   = iter_sampling,
      thin            = nthin,
      adapt_delta     = adapt_delta,
      step_size       = stepsize,
      max_treedepth   = max_treedepth,
      init            = inits,
      seed            = seed,
      refresh         = 0,
      show_messages   = FALSE,
      show_exceptions = FALSE
    )
  }

  par_vals <- .hbayesdm_extract(fit, pars)

  if (inc_postpred && !is.null(postpreds)) {
    for (pp in postpreds) {
      if (!is.null(par_vals[[pp]])) {
        par_vals[[pp]][par_vals[[pp]] == -1] <- NA
      }
    }
  }

  list(fit = fit, par_vals = par_vals, vb = vb)
}

#' Resolve the `inits` argument into the format cmdstanr expects.
#' @keywords internal
.hbayesdm_resolve_inits <- function(gen_init, nchain) {
  if (is.null(gen_init) || identical(gen_init, "random")) {
    return(NULL)
  }
  if (is.function(gen_init)) {
    return(lapply(seq_len(nchain), function(i) gen_init()))
  }
  gen_init
}

#' Extract draws for the requested parameters from a cmdstanr fit.
#'
#' Returns a named list. Each element has draws on axis 1 followed by the
#' parameter's own dimensions.
#' @keywords internal
#' @importFrom posterior as_draws_rvars draws_of
.hbayesdm_extract <- function(fit, pars) {
  draws <- posterior::as_draws_rvars(fit$draws())
  out <- list()
  for (p in pars) {
    if (!is.null(draws[[p]])) {
      out[[p]] <- posterior::draws_of(draws[[p]], with_chains = FALSE)
    }
  }
  out
}
