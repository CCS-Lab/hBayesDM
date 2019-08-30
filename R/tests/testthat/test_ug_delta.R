context("Test ug_delta")
library(hBayesDM)

test_that("Test ug_delta", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(ug_delta(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
