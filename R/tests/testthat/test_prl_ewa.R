context("Test prl_ewa")
library(hBayesDM)

test_that("Test prl_ewa", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(prl_ewa(
      use_example = TRUE,
      niter=10, nwarmup=5, nchain=1, ncore=1))
})
