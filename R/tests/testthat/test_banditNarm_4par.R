context("Test banditNarm_4par")
library(hBayesDM)

test_that("Test banditNarm_4par", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(banditNarm_4par(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
