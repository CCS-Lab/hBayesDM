context("Test rdt_happiness")
library(hBayesDM)

test_that("Test rdt_happiness", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(rdt_happiness(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
