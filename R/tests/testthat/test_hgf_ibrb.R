context("Test hgf_ibrb")
library(hBayesDM)

test_that("Test hgf_ibrb", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(hgf_ibrb(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
