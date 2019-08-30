context("Test ra_prospect")
library(hBayesDM)

test_that("Test ra_prospect", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(ra_prospect(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
