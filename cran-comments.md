## Test environments

* Local mac OS install, R 3.5.1
* Local Ubuntu 16.04 install, R 3.4.4
* Ubuntu 14.04 (on Travis CI), R 3.5.1

## R CMD check results

There was no ERROR.

There were 2 NOTES:

* checking installed package size ... NOTE
  installed size is 26.7Mb
  sub-directories of 1Mb or more:
    extdata   1.2Mb
    libs     23.6Mb
    R         1.5Mb

  hBayesDM use compiled binaries for Stan models.

* checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Woo-Young Ahn <wooyoung.ahn@gmail.com>'
  
  GNU make is a SystemRequirements.

  To compile hBayesDM using rstan, GNU make is required.

## Misc

Because installation of hBayesDM may take approximately 80 minutes for compilation when using one core, could you allow a higher timeout (e.g., 3 hrs)?
