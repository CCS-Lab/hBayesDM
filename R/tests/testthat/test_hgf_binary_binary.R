context("Test hgf_binary_binary")
library(hBayesDM)

test_that("Test hgf_binary_binary", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(hgf_binary_binary(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
