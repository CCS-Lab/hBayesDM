context("Test ehgf_ibrb")
library(hBayesDM)

test_that("Test ehgf_ibrb", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(ehgf_ibrb(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
