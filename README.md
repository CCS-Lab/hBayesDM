<!-- README.md is generated from README.Rmd. Please edit that file -->
hBayesDM
========

[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)[![Build
Status](https://travis-ci.org/CCS-Lab/hBayesDM.svg?branch=master)](https://travis-ci.org/CCS-Lab/hBayesDM)[![Build
status](https://ci.appveyor.com/api/projects/status/hi3vp6ikm396pqcu?svg=true)](https://ci.appveyor.com/project/paulhendricks/hbayesdm)[![codecov](https://codecov.io/gh/CCS-Lab/hBayesDM/branch/master/graph/badge.svg)](https://codecov.io/gh/CCS-Lab/hBayesDM)

The **hBayesDM** (hierarchical Bayesian modeling of Decision-Making
tasks) is a user-friendly R package that offers hierarchical Bayesian
analysis of various computational models on an array of decision-making
tasks. The hBayesDM package uses [Stan](http://mc-stan.org/) for
Bayesian inference.

Installation
------------

**(For Windows users)** First download and install Rtools from this
link: <http://cran.r-project.org/bin/windows/Rtools/>. For detailed
instructions, please go to this link:
<https://github.com/stan-dev/rstan/wiki/Installing-RStan-on-Windows>.

**You need to install the hBayesDM from CRAN.** The GitHub version
precompiles all Stan models, which makes it faster to start MCMC
sampling. But it may cause some memory allocation issues on a Windows
machine.

**(For Mac/Linux users)** If you are a Mac user, [make sure Xcode is
installed](https://github.com/stan-dev/rstan/wiki/RStan-Mac-OS-X-Prerequisite-Installation-Instructions#step2_3).
We strongly recommend users install this GitHub version. The GitHub
version in the master repository is identical to the CRAN version,
except that all models are precompiled in the GitHub version, which
saves time for compiling Stan models.

You can install the latest version from github with:

    # install 'devtools' if required
    if (!require(devtools)) install.packages("devtools")  
    devtools::install_github("CCS-Lab/hBayesDM")

Please go to **[hBayesDM Tutorial](http://rpubs.com/CCSL/hBayesDM)** for
more information about the package.

If you encounter a problem or a bug, please use our mailing list:
<https://groups.google.com/forum/#!forum/hbayesdm-users>, or you can
directly create an issue on
[GitHub](https://github.com/CCS-Lab/hBayesDM/issues/new).


How to cite hBayesDM
------------
If you used hBayesDM or some of its codes for your research, please cite this paper: 

Ahn, W.-Y., Haines, N., & Zhang, L. (2017). Revealing neuro-computational mechanisms of reinforcement learning and decision-making with the hBayesDM package. Computational Psychiatry, 1, 24-57. https://doi.org/10.1162/CPSY_a_00002. 
