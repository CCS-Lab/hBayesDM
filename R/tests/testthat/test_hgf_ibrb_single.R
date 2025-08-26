context("Test hgf_ibrb_single")
library(hBayesDM)

test_that("Test hgf_ibrb_single", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(hgf_ibrb_single(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
