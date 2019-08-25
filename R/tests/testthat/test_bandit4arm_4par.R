context("Test bandit4arm_4par")
library(hBayesDM)

test_that("Test bandit4arm_4par", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(bandit4arm_4par(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
