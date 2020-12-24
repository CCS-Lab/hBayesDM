context("Test bart_ewmv")
library(hBayesDM)

test_that("Test bart_ewmv", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(bart_ewmv(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
