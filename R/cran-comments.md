## R CMD check results

There were no ERRORs or WARNINGs. 

There was 2 NOTEs:

- The installed package size is about 5.5Mb including example data.
```
N  checking installed package size ...
     installed size is  5.5Mb
     sub-directories of 1Mb or more:
       R         3.1Mb
       extdata   1.3Mb
```
- To compile hBayesDM using rstan, GNU make is required.
```
N  checking for GNU extensions in Makefiles ...
   GNU make is a SystemRequirements.
```
