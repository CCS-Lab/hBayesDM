context("Test cgt_cm")
library(hBayesDM)

test_that("Test cgt_cm", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(cgt_cm(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
