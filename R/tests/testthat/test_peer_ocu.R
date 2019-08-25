context("Test peer_ocu")
library(hBayesDM)

test_that("Test peer_ocu", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(peer_ocu(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
