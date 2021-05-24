context("Test banditNarm2_kalman_filter")
library(hBayesDM)

test_that("Test banditNarm2_kalman_filter", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(banditNarm2_kalman_filter(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
