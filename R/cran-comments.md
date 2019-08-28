## Test environments

* Local mac OS install, R 3.5.2
* Local Ubuntu 16.04 install, R 3.4.4
* Ubuntu 14.04 (on Travis CI), R 3.5.2

## R CMD check results

There were 2 NOTE:

- These messages occur since it uses 'data.table'. It works fine when users run it
  with 'data.table' installed.
```
* checking R code for possible problems ... NOTE
bandit2arm_preprocess_func: no visible binding for global variable
  ‘subjid’
bandit4arm2_preprocess_func: no visible binding for global variable
  ‘subjid’
bandit4arm_preprocess_func: no visible binding for global variable
  ‘subjid’
bart_preprocess_func: no visible binding for global variable ‘subjid’
cgt_preprocess_func: no visible binding for global variable ‘subjid’
choiceRT_single_preprocess_func: no visible binding for global variable
  ‘choice’
cra_preprocess_func: no visible binding for global variable ‘subjid’
dbdm_preprocess_func: no visible binding for global variable ‘subjid’
dd_preprocess_func: no visible binding for global variable ‘subjid’
gng_preprocess_func: no visible binding for global variable ‘subjid’
igt_preprocess_func: no visible binding for global variable ‘subjid’
peer_preprocess_func: no visible binding for global variable ‘subjid’
prl_multipleB_preprocess_func: no visible binding for global variable
  ‘subjid’
prl_multipleB_preprocess_func: no visible binding for global variable
  ‘block’
prl_preprocess_func: no visible binding for global variable ‘subjid’
pst_preprocess_func: no visible binding for global variable ‘subjid’
ra_preprocess_func: no visible binding for global variable ‘subjid’
rdt_preprocess_func: no visible binding for global variable ‘subjid’
ts_preprocess_func: no visible binding for global variable ‘subjid’
ug_preprocess_func: no visible binding for global variable ‘subjid’
wcs_preprocess_func: no visible binding for global variable ‘subjid’
Undefined global functions or variables:
  block choice subjid
```

- To compile hBayesDM using rstan, GNU make is required.
```
* checking for GNU extensions in Makefiles ... NOTE
GNU make is a SystemRequirements.
```
