context("Test cra_linear")
library(hBayesDM)

test_that("Test cra_linear", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(cra_linear(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
