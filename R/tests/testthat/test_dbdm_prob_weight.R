context("Test dbdm_prob_weight")
library(hBayesDM)

test_that("Test dbdm_prob_weight", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(dbdm_prob_weight(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
