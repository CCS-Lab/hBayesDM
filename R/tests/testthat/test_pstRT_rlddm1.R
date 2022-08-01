context("Test pstRT_rlddm1")
library(hBayesDM)

test_that("Test pstRT_rlddm1", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(pstRT_rlddm1(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
