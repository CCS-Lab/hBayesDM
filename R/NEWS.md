# hBayesDM 2.0.0 (in development)

Major refactor; **breaking changes**.

## Backend swap: rstan → cmdstanr

* The Stan backend is now [**CmdStan**](https://mc-stan.org/users/interfaces/cmdstan)
  via [**cmdstanr**](https://mc-stan.org/cmdstanr/), replacing rstan. CmdStan is
  a system dependency, not a CRAN package — install it once with
  `cmdstanr::install_cmdstan()` after installing cmdstanr from the Stan
  r-universe (see README).
* The `fit` slot on the result object is now a **`CmdStanMCMC`** object (or
  **`CmdStanVB`** when `vb = TRUE`), no longer a `rstan::stanfit`. Methods that
  used to apply directly (e.g. `rstan::extract(fit)`) need to be replaced with
  the cmdstanr / posterior equivalents — `fit$draws()`, `fit$summary()`,
  `posterior::as_draws_*()`, etc.
* Stan files have been canonicalized to the modern syntax (`array[N, T] real x`
  instead of `real x[N, T]`; `abs` replacing `fabs`).

## Tooling and prerequisites

* **R ≥ 4.4** is now required.
* hBayesDM no longer compiles Stan models at install time. Each model compiles
  on first use (~30 s) and cmdstanr caches the binary for subsequent fits.
  The `BUILD_ALL` install-time flag is gone.
* `LinkingTo: rstan, StanHeaders, ...` and the C++ machinery they entailed have
  been removed from the package.

## API changes

* `rhat()` — internally uses `posterior::rhat` via `fit$summary()` (a
  workaround for a name-collision bug between `hBayesDM::rhat` and the string
  `"rhat"` looked up by `cmdstanr::CmdStanFit$summary()`).
* `extract_ic()` — now extracts `log_lik` from `fit$draws()` via
  `posterior::as_draws_array()`. The `ic = "looic" | "waic" | "both"` API is
  unchanged.
* `plot.hBayesDM()` and `plot_ind()` — now plot via **bayesplot**
  (`mcmc_trace`, `mcmc_intervals`, `mcmc_areas`) instead of `rstan::stan_plot`.
* **Breaking — snake_case sweep.** The R public API is now fully snake_case,
  matching modern R style (tidyverse / Google guides) and the Python
  package character-for-character. User-visible renames:
  * Functions: `printFit` → `print_fit`, `plotHDI` → `plot_hdi`,
    `plotInd` → `plot_ind`, `plotDist` → `plot_dist`, `HDIofMCMC` → `hdi`.
  * Arguments: `modelRegressor` → `model_regressor`, `indPars` → `ind_pars`,
    `credMass` → `ci_prob` (on `hdi()` and `plot_hdi()`),
    `fontSize` → `font_size`, `xLab` → `x_lab`, `yLab` → `y_lab`,
    `xLim` → `x_lim`, `binSize` → `bin_size`, `sampleVec` → `sample_vec`,
    `roundTo` → `round_to`, `Title` → `title`.
  * Result-object slots: `$allIndPars` → `$all_ind_pars`,
    `$parVals` → `$par_vals`, `$modelRegressor` → `$model_regressor`,
    `$rawdata` → `$raw_data`. (`$model` and `$fit` unchanged.)
* **HDI default credible mass.** `hdi()` and `plot_hdi()` default
  `ci_prob = 0.95` (unchanged on the R side). The Python package now also
  defaults to `0.95` (previously `0.94`, inherited from arviz) so the two
  languages produce matching HDI bands out of the box.
* `additional_args` plumbing fixed: model wrappers that declared a `NULL`
  default (e.g. `banditNarm_2par_lapse` `Narm`, `pstRT_ddm` `initQ`) were
  silently dropping it because `args[[nm]] <- NULL` removes a list element in
  R; now uses `args[nm] <- list(NULL)` to preserve the entry.

## Migration notes

If you have downstream code that calls `rstan::extract(output$fit)`, replace
it with one of:

```r
posterior::as_draws_df(output$fit$draws())   # tidy data.frame
posterior::as_draws_rvars(output$fit$draws())
output$par_vals[["mu_k"]]                     # already-extracted samples
```

# hBayesDM 1.3.1

* Add plot functions for Hierarchical Gaussian Filter models: `plot_hgf_ibrb`, `plot_hgf_ibrb_single`.

# hBayesDM 1.3.0

* Added a Hierarchical Gaussian Filter model for binary inputs and binary responses: `hgf_ibrb` for hierarchical Bayesian analysis and `hgf_ibrb_single` for individual Bayesian analysis.
* Added new article: [Hierarchical Bayesian Analysis on Hierarchical Gaussian Filter](https://ccs-lab.github.io/hBayesDM/articles/hgf_tutorial.html)

# hBayesDM 1.2.1

* Fixed a pkgdown error.

# hBayesDM 1.2.0

* Added a drift diffusion model and two reinforcement learning-drift diffision models for the probabilistic selection task: `pstRT_ddm`, `pstRT_rlddm1`, and `pstRT_rlddm6`.
* Added multiple models for the banditNarm task: `banditNarm_2par_lapse`, `banditNarm_4par`, `banditNarm_delta`, `banditNarm_kalman_filter`, `banditNarm_lapse`, `banditNarm_lapse_decay`, and `banditNarm_singleA_lapse`.
* Fixed `bart_ewmv` to avoid dividing by zero.

# hBayesDM 1.1.1

* Fix symbolic link errors for stan files and example data.

# hBayesDM 1.1.0

* Added the cumulative model for the Cambridge gambling task: `cgt_cm`.
* Added two new models for aversive learning tasks: `alt_delta` and `alt_gamma`.
* Added exponential-weight mean-variance model for BART task: `bart_ewmv`.
* Added simple Q learning model for the probabilistic selection task: `prl_Q`.
* Added signal detection theory model for 2-alternative forced choice task:
`task2AFC_sdt`.

# hBayesDM 1.0.2

- Fixed an error on using data.frame objects as data (#112).

# hBayesDM 1.0.1

- Minor fix on the plotting function.

# hBayesDM 1.0.0

##  Major changes

* Now, hBayesDM has both R and Python version, with same models included!
You can run hBayesDM with a language you prefer!
* Models in hBayesDM are now specified as YAML files. Using the YAML files,
R and Python codes are generated automatically. If you want to contribute
hBayesDM by adding a model, what you have to do is just to write a Stan file
and to specify its information! You can find how to do in the hBayesDM wiki
(https://github.com/CCS-Lab/hBayesDM/wiki).
* Model functions try to use parameter estimates using variational Bayesian
methods as its initial values for MCMC sampling by default (#96). If VB
estimation fails, then it uses random values instead.
* The `data` argument for model functions can handle a data.frame object (#2, #98).
* `choiceRT_lba` and `choiceRT_lba_single` are temporarily removed since their codes
are not suitable to the new package structure. We plan to re-add the models
in future versions.
* The Cumulative Model for Cambridge Gambling Task is added (`cgt_cm`; #108).

## Minor changes

* The `tau` parameter in all models for the risk aversion task is modified to
be bounded to [0, 30] (#77, #78).
* `bart_4par` is fixed to compute subject-wise log-likelihood (#82).
* `extract_ic` is fixed for its wrong `rep` function usage (#94, #100).
* The drift rate (`delta` parameter) in `choiceRT_ddm` and `choiceRT_ddm_single` is
unbounded and now it is estimated between [-Inf, Inf] (#95, #107).
* Fix a preprocessing error in  `choiceRT_ddm` and `choiceRT_ddm_single` (#95, #109).
* Fix `igt_orl` for a wrong Matt trick operation (#110).

# hBayesDM 0.7.2

* Add three new models for the bandit4arm task: `bandit4arm_2par_lapse`,
    `bandit4arm_lapse_decay` and `bandit4arm_singleA_lapse`.
* Fix various (minor) errors.

# hBayesDM 0.7.1

* Make it usable without manually loading `rstan`.
* Remove an annoying warning about using `..insensitive_data_columns`.

# hBayesDM 0.7.0

* Now, in default, you should build a Stan file into a binary for the first time to use it. To build all the models on installation, you should set an environmental variable `BUILD_ALL` to `true` before installation.
* Now all the implemented models are refactored using `hBayesDM_model` function. You don't have to change anything to use them, but developers can easily implement new models now!
* We added a Kalman filter model for 4-armed bandit task (`bandit4arm2_kalman_filter`; Daw et al., 2006) and a probability weighting function for general description-based tasks (`dbdm_prob_weight`; Erev et al., 2010; Hertwig et al., 2004; Jessup et al., 2008).
* Initial values of parameter estimation for some models are updated as plausible values, and the parameter boundaries of several models are fixed (see more on issue #63 and #64 in Github).
* Exponential and linear models for choice under risk and ambiguity task now have four model regressors: `sv`, `sv_fix`, `sv_var`, and `p_var`.
* Fix the Travix CI settings and related codes to be properly passed.

# hBayesDM 0.6.3

* Update the dependencies on rstan (>= 2.18.1)
* No changes on model files, as same as the version 0.6.2

# hBayesDM 0.6.2

* Fix an error on choiceRT_ddm (#44)

# hBayesDM 0.6.1

* Solve an issue with built binary files.
* Fix an error on peer_ocu with misplaced parentheses.

# hBayesDM 0.6.0

* Add new tasks (Balloon Analogue Risk Task, Choice under Risk and Ambiguity Task, Probabilistic Selection Task, Risky Decision Task (a.k.a. Happiness task), Wisconsin Card Sorting Task)
* Add a new model for the Iowa Gambling Task (igt_orl)
* Change priors (Half-Cauchy(0, 5) --> Half-Cauchy(0, 1) or Half-Normal(0, 0.2)
* printFit function now provides LOOIC weights and/or WAIC weights

# hBayesDM 0.5.1

* Add models for the Two Step task
* Add models without indecision point parameter (alpha) for the PRL task (prl_*_woa.stan)
* Model-based regressors for the PRL task are now available
* For the PRL task & prl_fictitious.stan & prl_fictitious_rp.stan --> change the range of alpha (indecision point) from [0, 1] to [-Inf, Inf]

# hBayesDM 0.5.0

* Support variational Bayesian methods (vb=TRUE)
* Allow posterior predictive checks, except for drift-diffusion models (inc_postpred=TRUE)
* Add the peer influence task (Chung et al., 2015, USE WITH CAUTION for now and PLEASE GIVE US FEEDBACK!)
* Add 'prl_fictitious_rp' model
* Made changes to be compatible with the newest Stan version (e.g., // instead of # for commenting).
* In 'prl_*' models, 'rewlos' is replaced by 'outcome' so that column names and labels would be consistent across tasks as much as possible.
* Email feature is disabled as R mail package does not allow users to send anonymous emails anymore.
* When outputs are saved as a file (*.RData), the file name now contains the name of the data file.

# hBayesDM 0.4.0

* Add a choice reaction time task and evidence accumulation models
  - Drift diffusion model (both hierarchical and single-subject)
  - Linear Ballistic Accumulator (LBA) model (both hierarchical and single-subject)
* Add PRL models that can fit multiple blocks
* Add single-subject versions for the delay discounting task (`dd_hyperbolic_single` and `dd_cs_single`).
* Standardize variable names across all models (e.g., `rewlos` --> `outcome` for all models)
* Separate versions for CRAN and GitHub. All models/features are identical but the GitHub version contains precompilled models.

# hBayesDM 0.3.1

* Remove dependence on the modeest package. Now use a built-in function to estimate the mode of a posterior distribution.
* Rewrite the "printFit" function.

# hBayesDM 0.3.0

* Made several changes following the guidelines for R packages providing interfaces to Stan.
* Stan models are precompiled and models will run immediately when called.
* The default number of chains is set to 4.
* The default value of `adapt_delta` is set to 0.95 to reduce the potential for divergences.
* The “printFit” function uses LOOIC by default. Users can select WAIC or both (LOOIC & WAIC) if needed.

# hBayesDM 0.2.3.3

* Add help files
* Add a function for checking Rhat values (rhat).
* Change a link to its tutorial website

# hBayesDM 0.2.3.2

* Use wide normal distributions for unbounded parameters (gng_* models).
* Automatic removal of rows (trials) containing NAs.

# hBayesDM 0.2.3.1

* Add a function for plotting individual parameters (plotInd)

# hBayesDM 0.2.3

* Add a new task: the Ultimatum Game
* Add new models for the Probabilistic Reversal Learning and Risk Aversion tasks
* ‘bandit2arm’ -> change its name to ‘bandit2arm_delta’. Now all model names are in the same format (i.e., TASK_MODEL).
* Users can extract model-based regressors from gng_m* models
* Include the option of customizing control parameters (adapt_delta, max_treedepth, stepsize)
* ‘plotHDI’ function -> add ‘fontSize’ argument & change the color of histogram

# hBayesDM 0.2.1

## Bug fixes

* All models: Fix errors when indPars=“mode”
* ra_prospect model: Add description for column names of a data (*.txt) file

## Change

* Change standard deviations of ‘b’ and ‘pi’ priors in gng_* models

# hBayesDM 0.2.0

Initially released.

