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

