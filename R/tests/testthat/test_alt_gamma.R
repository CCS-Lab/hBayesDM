context("Test alt_gamma")
library(hBayesDM)

test_that("Test alt_gamma", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(alt_gamma(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
