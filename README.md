
# hBayesDM

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Build Status](https://travis-ci.org/CCS-Lab/hBayesDM.svg?branch=master)](https://travis-ci.org/CCS-Lab/hBayesDM)
[![CRAN Latest Release](https://www.r-pkg.org/badges/version-last-release/hBayesDM)](https://cran.r-project.org/package=hBayesDM)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/hBayesDM)](https://cran.r-project.org/web/packages/hBayesDM/index.html)
[![DOI](https://zenodo.org/badge/doi/10.1162/CPSY_a_00002.svg)](https://doi.org/10.1162/CPSY_a_00002)

#### Now supporting *R* and *python*!

**hBayesDM** (hierarchical Bayesian modeling of Decision-Making tasks) is a user-friendly package that offers hierarchical Bayesian analysis of various computational models on an array of decision-making tasks. hBayesDM uses [Stan](http://mc-stan.org/) for Bayesian inference.

Please see the respective sections below for installing hBayesDM with R/python.

## Getting Started - R

### Prerequisite

To install hBayesDM for R, **[RStan][rstan] needs to be properly installed before you proceed**.
For detailed instructions on having RStan ready prior to installing hBayesDM, please go to this link:
https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started

[rstan]: https://github.com/stan-dev/rstan

### Installation

The lastest **stable** version of hBayesDM can be installed from CRAN by running the following command in R:

```r
install.packages("hBayesDM")  # Install hBayesDM from CRAN
```

or you can also install from GitHub with:

```r
# `devtools` is required to install hBayesDM from GitHub
if (!require(devtools)) install.packages("devtools")

devtools::install_github("CCS-Lab/hBayesDM/R")
```

If you want to use the lastest *development* version of hBayesDM, run the following in R:

```r
# `devtools` is required to install hBayesDM from GitHub
if (!require(devtools)) install.packages("devtools")

devtools::install_github("CCS-Lab/hBayesDM/R@develop")
```

#### Building at once

By default, you will have to wait for compilation when you run each model for the first time.
If you plan on runnning several different models and want to pre-build all models during installation time,
set an environment variable `BUILD_ALL` to `true`, like the following.
We highly recommend you only do so when you have multiple cores available,
since building all models at once takes quite a long time to complete.

```r
Sys.setenv(BUILD_ALL = "true")  # Build *all* models at installation time
Sys.setenv(MAKEFLAGS = "-j 4")  # Use 4 cores for build (or any other number you want)

install.packages("hBayesDM")                    # Install from CRAN
# or
devtools::install_github("CCS-Lab/hBayesDM/R")  # Install from GitHub
```

## Getting Started - Python

**hBayesDM-py** supports Python 3.5 or higher. It requires several packages including:
[NumPy][numpy], [SciPy][scipy], [Pandas][pandas], [PyStan][pystan], [Matplotlib][matplotlib], [ArviZ][arviz].
*(But there's no need to pre-install anything as pip handles all the requirements for us.)*

[numpy]: https://www.numpy.org/
[scipy]: https://www.scipy.org/
[pandas]: https://pandas.pydata.org/
[pystan]: https://github.com/stan-dev/pystan
[matplotlib]: https://matplotlib.org/
[arviz]: https://arviz-devs.github.io/arviz/

### Installation

You can install the latest **stable** version of `hbayesdm` from PyPI, through the following command:

```sh
pip install hbayesdm                                # Install from PyPI
```

or if you want to install from source, by cloning the repo from GitHub:

```sh
git clone https://github.com/CCS-Lab/hBayesDM.git   # Clone repo
cd hBayesDM                                         # Move into repo
cd Python                                           # Move into Python subdirectory

python setup.py install                             # Install hbayesdm from source
```

or if you want to install the latest *development* version of `hbayesdm`:

```sh
git clone https://github.com/CCS-Lab/hBayesDM.git   # Clone repo
cd hBayesDM                                         # Move into repo
git checkout develop                                # Checkout develop branch
cd Python                                           # Move into Python subdirectory

python setup.py install                             # Install hbayesdm *develop* version from source
```

If you want to create a virtual environment using [`pipenv`](https://pipenv.readthedocs.io/en/latest/)
while installing `hbayesdm`:

```sh
git clone https://github.com/CCS-Lab/hBayesDM.git   # Clone repo
cd hBayesDM                                         # Move into repo
cd Python                                           # Move into Python subdirectory

pipenv install --skip-lock                          # Install hbayesdm inside pipenv
```

**[For contributors]** You can also install all dependencies (including dev) of `hbayesdm`:

```sh
git clone https://github.com/CCS-Lab/hBayesDM.git   # Clone repo
cd hBayesDM                                         # Move into repo
cd Python                                           # Move into Python subdirectory

pipenv install --dev --skip-lock                    # For developmental purpose
```

BTW, we encourage you try out [`pipenv`](https://pipenv.readthedocs.io/en/latest/), a well-documented, rich, high-level virtual environment wrapper for python & pip.

## Quick Links

- **Tutorial-R**: http://rpubs.com/CCSL/hBayesDM
- **Tutorial-py**: *...on its way...*
- **Mailing list**: https://groups.google.com/forum/#!forum/hbayesdm-users
- **Bug reports**: https://github.com/CCS-Lab/hBayesDM/issues
- **Contributing**: See the [Wiki](https://github.com/CCS-Lab/hBayesDM/wiki) of this repository.

## Citation

If you used hBayesDM or some of its codes for your research, please cite this paper: 

> Ahn, W.-Y., Haines, N., & Zhang, L. (2017). Revealing neuro-computational mechanisms of reinforcement learning and decision-making with the hBayesDM package. Computational Psychiatry, 1, 24-57. doi:10.1162/CPSY_a_00002. 

or using BibTeX:

```bibtex
@article{hBayesDM,
  title = {Revealing Neurocomputational Mechanisms of Reinforcement Learning and Decision-Making With the {hBayesDM} Package},
  author = {Ahn, Woo-Young and Haines, Nathaniel and Zhang, Lei},
  journal = {Computational Psychiatry},
  year = {2017},
  volume = {1},
  pages = {24--57},
  publisher = {MIT Press},
  url = {doi:10.1162/CPSY_a_00002},
}
```
