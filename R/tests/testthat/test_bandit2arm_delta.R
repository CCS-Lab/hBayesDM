context("Test bandit2arm_delta")
library(hBayesDM)

test_that("Test bandit2arm_delta", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(bandit2arm_delta(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
