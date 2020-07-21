context("Test ts_par6")
library(hBayesDM)

test_that("Test ts_par6", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(ts_par6(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
