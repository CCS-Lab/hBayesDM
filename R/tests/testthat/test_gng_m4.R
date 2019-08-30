context("Test gng_m4")
library(hBayesDM)

test_that("Test gng_m4", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(gng_m4(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
