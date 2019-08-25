context("Test prl_rp")
library(hBayesDM)

test_that("Test prl_rp", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(prl_rp(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
