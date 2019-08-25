context("Test prl_fictitious_rp")
library(hBayesDM)

test_that("Test prl_fictitious_rp", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(prl_fictitious_rp(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
