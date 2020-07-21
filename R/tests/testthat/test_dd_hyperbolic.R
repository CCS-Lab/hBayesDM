context("Test dd_hyperbolic")
library(hBayesDM)

test_that("Test dd_hyperbolic", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(dd_hyperbolic(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
