context("Test ehgf_ibrb_vds")
library(hBayesDM)

test_that("Test ehgf_ibrb_vds", {
  # Do not run this test on CRAN
  skip_on_cran()

  expect_output(ehgf_ibrb_vds(
      data = "example", niter = 10, nwarmup = 5, nchain = 1, ncore = 1))
})
