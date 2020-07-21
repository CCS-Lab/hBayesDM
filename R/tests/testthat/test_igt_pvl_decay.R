context("Test igt_pvl_decay")
library(hBayesDM)

test_that("Test igt_pvl_decay", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(igt_pvl_decay(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
