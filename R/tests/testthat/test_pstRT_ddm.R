context("Test pstRT_ddm")
library(hBayesDM)

test_that("Test pstRT_ddm", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(pstRT_ddm(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
