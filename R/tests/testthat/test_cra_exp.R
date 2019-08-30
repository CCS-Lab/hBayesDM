context("Test cra_exp")
library(hBayesDM)

test_that("Test cra_exp", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(cra_exp(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
