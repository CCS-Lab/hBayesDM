context("Test igt_vpp")
library(hBayesDM)

test_that("Test igt_vpp", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(igt_vpp(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
