context("Test aversivelearning_gamma")
library(hBayesDM)

test_that("Test aversivelearning_gamma", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(aversivelearning_gamma(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
