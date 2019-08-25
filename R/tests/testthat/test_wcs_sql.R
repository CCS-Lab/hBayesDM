context("Test wcs_sql")
library(hBayesDM)

test_that("Test wcs_sql", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(wcs_sql(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
