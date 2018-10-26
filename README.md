
# hBayesDM

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Build Status](https://travis-ci.org/CCS-Lab/hBayesDM.svg?branch=master)](https://travis-ci.org/CCS-Lab/hBayesDM)
[![CRAN Latest Release](https://www.r-pkg.org/badges/version-last-release/hBayesDM)](https://cran.r-project.org/package=hBayesDM)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/hBayesDM)](http://cran.rstudio.com/package=rstan)
<!-- [![Build Status](https://ci.appveyor.com/api/projects/status/hi3vp6ikm396pqcu?svg=true)](https://ci.appveyor.com/project/paulhendricks/hbayesdm)
[![CodeCov](https://codecov.io/gh/CCS-Lab/hBayesDM/branch/master/graph/badge.svg)](https://codecov.io/gh/CCS-Lab/hBayesDM) -->

The **hBayesDM** (hierarchical Bayesian modeling of Decision-Making tasks) is a user-friendly R package that offers hierarchical Bayesian analysis of various computational models on an array of decision-making tasks. The hBayesDM package uses [Stan](http://mc-stan.org/) for Bayesian inference.

## Getting Started

### Prerequisite

To install hBayesDM, **[RStan][rstan] should be properly installed before you proceed**.
For detailed instructions, please go to this link:
https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started

[rstan]: https://github.com/stan-dev/rstan

For the moment, RStan requires you to specify that the C++14 standard should be used to compile Stan programs (based on [this link][rstan-loading]):
```r
Sys.setenv(USE_CXX14 = 1)
library("rstan") # observe startup messages
```

[rstan-loading]: https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started#loading-the-package

### Installation

hBayesDM can be installed from CRAN by running the following command in R:

```r
install.packages('hBayesDM')  # Install hBayesDM from CRAN
```

**We strongly recommend users to install hBayesDM from GitHub**. All models in this GitHub version are precompiled, which saves time for compiling Stan models. However, it may cause some memory allocation issues on a Windows machine.

You can install the latest version from GitHub with:

```r
# `devtools` is required to install hBayesDM from GitHub
if (!require(devtools)) install.packages("devtools")
devtools::install_github("CCS-Lab/hBayesDM")
```

### Quick Links

- **Tutorial**: http://rpubs.com/CCSL/hBayesDM
- **Mailing list**: https://groups.google.com/forum/#!forum/hbayesdm-users
- **Bug reports**: https://github.com/CCS-Lab/hBayesDM/issues

## Citation

If you used hBayesDM or some of its codes for your research, please cite this paper: 

> Ahn, W.-Y., Haines, N., & Zhang, L. (2017). Revealing neuro-computational mechanisms of reinforcement learning and decision-making with the hBayesDM package. Computational Psychiatry, 1, 24-57. https://doi.org/10.1162/CPSY_a_00002. 

or for BibTeX:

```bibtex
@article{hBayesDM,
  title = {Revealing Neurocomputational Mechanisms of Reinforcement Learning and Decision-Making With the {hBayesDM} Package},
  author = {Ahn, Woo-Young and Haines, Nathaniel and Zhang, Lei},
  journal = {Computational Psychiatry},
  year = {2017},
  volume = {1},
  pages = {24--57},
  publisher = {MIT Press},
  url = {https://doi.org/10.1162/CPSY_a_00002},
}
```
