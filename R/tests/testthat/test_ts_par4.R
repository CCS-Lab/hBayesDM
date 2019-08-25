context("Test ts_par4")
library(hBayesDM)

test_that("Test ts_par4", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(ts_par4(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
