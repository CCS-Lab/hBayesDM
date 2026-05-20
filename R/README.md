
# hBayesDM

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![R](https://github.com/CCS-Lab/hBayesDM/actions/workflows/R.yaml/badge.svg)](https://github.com/CCS-Lab/hBayesDM/actions/workflows/R.yaml)
[![Documentation](https://github.com/CCS-Lab/hBayesDM/workflows/Documentation/badge.svg)](https://github.com/CCS-Lab/hBayesDM/actions?query=workflow%3ADocumentation)
[![CRAN Latest
Release](https://www.r-pkg.org/badges/version-last-release/hBayesDM)](https://cran.r-project.org/package=hBayesDM)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/hBayesDM)](https://cran.r-project.org/web/packages/hBayesDM/index.html)
[![DOI](https://zenodo.org/badge/doi/10.1162/CPSY_a_00002.svg)](https://doi.org/10.1162/CPSY_a_00002)

**hBayesDM** (hierarchical Bayesian modeling of Decision-Making tasks)
is a user-friendly package that offers hierarchical Bayesian analysis of
various computational models on an array of decision-making tasks.
hBayesDM uses [Stan](https://mc-stan.org/) for Bayesian inference.

## Quick Links

- **Mailing list**:
  <https://groups.google.com/forum/#!forum/hbayesdm-users>
- **Bug reports**: <https://github.com/CCS-Lab/hBayesDM/issues>
- **Contributing**: See the
  [Wiki](https://github.com/CCS-Lab/hBayesDM/wiki) of this repository.
- **Python interface for hBayesDM**:
  [PyPI](https://pypi.org/project/hbayesdm/),
  [documentation](https://hbayesdm.readthedocs.io)

## Getting Started

### Prerequisites

hBayesDM 2.0 requires **R ≥ 4.4** and uses
[**CmdStan**](https://mc-stan.org/users/interfaces/cmdstan) (via the
[**cmdstanr**](https://mc-stan.org/cmdstanr/) R package) as its Stan
backend, replacing rstan in 1.x. CmdStan ships as a system dependency,
so models compile on first use rather than at package install time.

``` r
# 1. Install cmdstanr (not on CRAN — use the Stan r-universe)
install.packages(
  "cmdstanr",
  repos = c("https://stan-dev.r-universe.dev", getOption("repos"))
)

# 2. Install CmdStan itself (one-time, ~5 min)
cmdstanr::install_cmdstan()
```

### Installation

The latest **stable** version of hBayesDM can be installed from CRAN:

``` r
install.packages("hBayesDM")
```

or from GitHub:

``` r
if (!require(remotes)) install.packages("remotes")
remotes::install_github("CCS-Lab/hBayesDM", subdir = "R")
```

For the latest *development* version:

``` r
remotes::install_github("CCS-Lab/hBayesDM", ref = "develop", subdir = "R")
```

### First-fit compile cost

Each Stan model compiles on first use (~30 s) and cmdstanr caches the
binary for subsequent fits. This replaces the install-time `BUILD_ALL`
precompile that earlier versions used.

## Citation

If you used hBayesDM or some of its codes for your research, please cite
[this
paper](https://www.mitpressjournals.org/doi/full/10.1162/CPSY_a_00002):

``` bibtex
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
