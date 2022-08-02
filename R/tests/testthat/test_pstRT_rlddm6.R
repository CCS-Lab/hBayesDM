context("Test pstRT_rlddm6")
library(hBayesDM)

test_that("Test pstRT_rlddm6", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(pstRT_rlddm6(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
