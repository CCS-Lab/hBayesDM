context("Test banditNarm_delta")
library(hBayesDM)

test_that("Test banditNarm_delta", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(banditNarm_delta(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
