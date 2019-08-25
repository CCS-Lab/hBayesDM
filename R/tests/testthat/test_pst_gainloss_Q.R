context("Test pst_gainloss_Q")
library(hBayesDM)

test_that("Test pst_gainloss_Q", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(pst_gainloss_Q(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
