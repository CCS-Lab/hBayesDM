context("Test banditNarm_singleA_lapse")
library(hBayesDM)

test_that("Test banditNarm_singleA_lapse", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(banditNarm_singleA_lapse(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
