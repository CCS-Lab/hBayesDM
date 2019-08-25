context("Test ts_par7")
library(hBayesDM)

test_that("Test ts_par7", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(ts_par7(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
