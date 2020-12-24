context("Test pst_Q")
library(hBayesDM)

test_that("Test pst_Q", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(pst_Q(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
