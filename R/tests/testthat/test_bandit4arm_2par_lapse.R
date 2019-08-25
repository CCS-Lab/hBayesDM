context("Test bandit4arm_2par_lapse")
library(hBayesDM)

test_that("Test bandit4arm_2par_lapse", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(bandit4arm_2par_lapse(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
