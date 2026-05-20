## Submission notes — 2.0.0

This is a **major version** with breaking changes. The Stan backend has been
swapped from rstan to **cmdstanr**, and CmdStan is now a system dependency
rather than something compiled at install time.

* No C++ code is compiled when the package is installed; `LinkingTo` is empty.
* Stan models compile on first use via cmdstanr's lazy compilation (cached on
  disk by cmdstanr after the initial build).
* Users must install CmdStan once via `cmdstanr::install_cmdstan()` before
  fitting models. Tests and examples that fit models are wrapped in
  `\dontrun{}` / `skip_on_cran()` so CRAN check machines do not need CmdStan.
* Minimum R version raised to 4.4.

## R CMD check results

No ERRORs or WARNINGs expected. The package size NOTE persists due to the
bundled example data and `inst/stan` files; the previous "GNU make required"
NOTE is gone since rstan is no longer linked against.
