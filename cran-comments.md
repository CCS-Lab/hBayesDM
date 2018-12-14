## Test environments

* Local mac OS install, R 3.5.1
* Local Ubuntu 16.04 install, R 3.4.4
* Ubuntu 14.04 (on Travis CI), R 3.5.1

## R CMD check results

There were 2 NOTES:

* checking installed package size ... NOTE
  installed size is  6.0Mb
  sub-directories of 1Mb or more:
    extdata      1.2Mb
    R            1.5Mb
    stan_files   2.8Mb
  
  hBayesDM use the Stan files for models.

* checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Woo-Young Ahn <wooyoung.ahn@gmail.com>'
  
  GNU make is a SystemRequirements.

  To compile hBayesDM using rstan, GNU make is required.
