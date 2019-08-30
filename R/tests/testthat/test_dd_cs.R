context("Test dd_cs")
library(hBayesDM)

test_that("Test dd_cs", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(dd_cs(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
