context("Test ra_noRA")
library(hBayesDM)

test_that("Test ra_noRA", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(ra_noRA(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
