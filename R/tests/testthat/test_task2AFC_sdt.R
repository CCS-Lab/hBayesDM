context("Test task2AFC_sdt")
library(hBayesDM)

test_that("Test task2AFC_sdt", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(task2AFC_sdt(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
