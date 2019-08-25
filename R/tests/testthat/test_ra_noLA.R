context("Test ra_noLA")
library(hBayesDM)

test_that("Test ra_noLA", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(ra_noLA(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
