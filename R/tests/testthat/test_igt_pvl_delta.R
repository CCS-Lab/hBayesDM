context("Test igt_pvl_delta")
library(hBayesDM)

test_that("Test igt_pvl_delta", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(igt_pvl_delta(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
