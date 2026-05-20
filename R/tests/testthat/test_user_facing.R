context("Test user-facing API (plots, diagnostics, IC, HDI helpers)")
library(hBayesDM)

# Fit one small hierarchical model and reuse across assertions to avoid
# repeated cmdstanr compile cost.
fitted <- suppressWarnings(suppressMessages(
  dd_hyperbolic(data  = "example",
                   niter = 300, nwarmup = 150,
                   nchain = 2, ncore = 2)
))

test_that("result object has expected structure", {
  skip_on_cran()
  expect_s3_class(fitted, "hBayesDM")
  expect_true(inherits(fitted$fit, "CmdStanMCMC"))
  expect_s3_class(fitted$all_ind_pars, "data.frame")
  expect_true(is.list(fitted$par_vals))
  expect_true("log_lik" %in% names(fitted$par_vals))
  expect_equal(fitted$model, "dd_hyperbolic")
})

test_that("plot dispatcher accepts trace and simple", {
  skip_on_cran()
  expect_silent(p_trace <- plot(fitted, type = "trace"))
  expect_silent(p_simple <- plot(fitted, type = "simple"))
  expect_true(inherits(p_trace, "ggplot") || inherits(p_trace, "gg"))
  expect_true(inherits(p_simple, "ggplot") || inherits(p_simple, "gg"))
})

test_that("plot_ind returns a ggplot for an individual-level parameter", {
  skip_on_cran()
  # Pick the first per-subject parameter that actually has draws stored.
  ind_par <- names(fitted$par_vals)[
    !startsWith(names(fitted$par_vals), "mu_") &
      !names(fitted$par_vals) %in% c("sigma", "log_lik")
  ][1]
  p <- plot_ind(fitted, ind_par)
  expect_true(inherits(p, "ggplot") || inherits(p, "gg"))
})

test_that("rhat returns data.frame, and threshold form returns logical", {
  skip_on_cran()
  rd <- rhat(fitted)
  expect_s3_class(rd, "data.frame")
  expect_true("Rhat" %in% colnames(rd))
  res <- suppressWarnings(rhat(fitted, less = 1e9))
  expect_true(isTRUE(res))
})

test_that("extract_ic returns LOOIC by default", {
  skip_on_cran()
  ic <- extract_ic(fitted)
  expect_true("LOOIC" %in% names(ic))
  expect_true(is.finite(ic$LOOIC$estimates[3, 1]))
})

test_that("print_fit returns a data.frame with weights column", {
  skip_on_cran()
  tab <- print_fit(fitted)
  expect_s3_class(tab, "data.frame")
  expect_equal(nrow(tab), 1L)
  expect_true(any(grepl("Weights", colnames(tab))))
})

test_that("hdi returns 2-vector from samples", {
  set.seed(1)
  hdi_lim <- hdi(rnorm(2000), ci_prob = 0.5)
  expect_length(hdi_lim, 2)
  expect_true(hdi_lim[1] < hdi_lim[2])
})

test_that("model_regressor=TRUE extracts regressors for gng_m1", {
  skip_on_cran()
  m <- suppressWarnings(suppressMessages(
    gng_m1(data = "example", niter = 40, nwarmup = 20,
           nchain = 1, ncore = 1, model_regressor = TRUE)
  ))
  reg <- m$model_regressor
  expect_true(is.list(reg))
  expect_setequal(names(reg), c("Qgo", "Qnogo", "Wgo", "Wnogo"))
  for (arr in reg) {
    expect_true(is.numeric(arr))
    expect_gte(length(dim(arr)), 2L)
    expect_true(all(is.finite(arr)))
  }
})

test_that("model_regressor=TRUE errors when model has no regressors", {
  skip_on_cran()
  expect_error(
    dd_hyperbolic(data = "example", niter = 20, nwarmup = 10,
                  nchain = 1, ncore = 1, model_regressor = TRUE),
    "regressors"
  )
})

test_that("vb=TRUE returns a CmdStanVB fit with usable summaries", {
  skip_on_cran()
  m <- suppressWarnings(suppressMessages(
    dd_hyperbolic(data = "example", niter = 20, nwarmup = 10,
                  nchain = 1, ncore = 1, vb = TRUE)
  ))
  expect_s3_class(m, "hBayesDM")
  expect_true(inherits(m$fit, "CmdStanVB"))
  expect_s3_class(m$all_ind_pars, "data.frame")
  expect_true(is.list(m$par_vals))
})

test_that("plot_dist and plot_hdi return ggplot objects", {
  set.seed(1)
  s <- rnorm(500)
  p1 <- plot_dist(s, bin_size = 30)
  expect_true(inherits(p1, "ggplot") || inherits(p1, "gg"))
  p2 <- suppressMessages(plot_hdi(s))
  expect_true(inherits(p2, "ggplot") || inherits(p2, "gg"))
})
