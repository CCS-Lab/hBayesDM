context("Test igt_orl")
library(hBayesDM)

test_that("Test igt_orl", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(igt_orl(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
