context("Test ug_bayes")
library(hBayesDM)

test_that("Test ug_bayes", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(ug_bayes(
      use_example = TRUE,
      niter=10, nwarmup=5, nchain=1, ncore=1))
})
