context("Test prl_fictitious")
library(hBayesDM)

test_that("Test prl_fictitious", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(prl_fictitious(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
