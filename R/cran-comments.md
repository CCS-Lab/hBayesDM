## Resubmission
This is a resubmission. In this version I have:

* Replace all 'http' with 'https' in the links in the documentations.
* Fixed URL-related issues in the documentations.
* Fixed minor errors in the generated documentations.

## Test environments

* Local macOS 10.16 install, R 4.0.5
* Local Ubuntu 16.04 install, R 4.0.5
* Ubuntu 18.04 (on Travis CI), R 4.0.5

## R CMD check results

There was 2 NOTEs:

- The installed package size is about 5.3Mb to include example data.
```
N  checking installed package size ...
     installed size is  5.3Mb
     sub-directories of 1Mb or more:
       R         3.1Mb
       extdata   1.2Mb
```
- To compile hBayesDM using rstan, GNU make is required.
```
N  checking for GNU extensions in Makefiles
   GNU make is a SystemRequirements.
```
