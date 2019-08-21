context("Test choiceRT_ddm")
library(hBayesDM)

test_that("Test choiceRT_ddm", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(choiceRT_ddm(
      use_example = TRUE,
      niter=10, nwarmup=5, nchain=1, ncore=1))
})
