# Contributing to hBayesDM

Thanks for your interest in contributing to hBayesDM. This guide replaces the
[older wiki pages][wiki] and reflects the 2.0 stack (cmdstanr / cmdstanpy,
R ≥ 4.4, Python ≥ 3.13).

[wiki]: https://github.com/CCS-Lab/hBayesDM/wiki

## Prerequisites

- **R ≥ 4.4** with [**cmdstanr**](https://mc-stan.org/cmdstanr/) and a working
  [**CmdStan**](https://mc-stan.org/users/interfaces/cmdstan) installation.
- **Python ≥ 3.13** with [**uv**](https://docs.astral.sh/uv/) for dependency
  management.
- **Git**, optionally **RStudio**, and a code editor.

One-time CmdStan install (do this once per machine, not per clone):

```bash
# R side
Rscript -e 'install.packages("cmdstanr", repos = c("https://stan-dev.r-universe.dev", getOption("repos")))'
Rscript -e 'cmdstanr::install_cmdstan()'

# Python side (after `uv sync` in Python/, see below)
uv run python -c "import cmdstanpy; cmdstanpy.install_cmdstan()"
```

## Workflow

hBayesDM follows the [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)
model: feature branches branch off `develop`, merge back into `develop`, and
`develop` merges into `master` at release.

1. **Fork** [`CCS-Lab/hBayesDM`](https://github.com/CCS-Lab/hBayesDM) on GitHub.
2. **Clone your fork** and add upstream:
   ```bash
   git clone https://github.com/<your-username>/hBayesDM.git
   cd hBayesDM
   git remote add upstream https://github.com/CCS-Lab/hBayesDM.git
   ```
3. **Branch off `develop`** with a descriptive name:
   ```bash
   git fetch upstream
   git checkout -b feature/<short-description> upstream/develop
   ```
   Conventions:
   - **Never** push directly to `develop` or `master`.
   - Branch names: `feature/<description>` for new work,
     `bugfix/<description>` for fixes, `hotfix/<description>` for urgent
     production fixes.
4. **Implement** your changes (see [Adding a new model](#adding-a-new-model)
   below for the model-specific workflow).
5. **Run the tests** locally (see [Testing](#testing)).
6. **Push** to your fork and **open a PR** against `CCS-Lab/hBayesDM:develop`.
   Maintainers will review and merge.

## Repository structure

```
hBayesDM/
├── DEVELOPERS.md              # developer quick reference (toolchain, gotchas)
├── CONTRIBUTING.md            # this file
├── README.md
├── commons/                   # single source of truth shared by R + Python
│   ├── extdata/               # example data files (tab-separated .txt)
│   ├── models/                # one .yml per model (model spec)
│   ├── stan_files/            # one .stan per model
│   ├── templates/             # R/Python code templates used by generators
│   ├── convert-to-py.py       # YAML -> Python wrapper
│   ├── convert-to-r.py        # YAML -> R wrapper
│   ├── example.yml            # template you copy when adding a new model
│   ├── generate-codes.sh      # runs both converters
│   └── utils.py
├── R/                         # R package (cmdstanr backend)
│   ├── R/                     # source (per-model wrappers + helpers)
│   ├── inst/                  # symlinks to commons/{stan_files,extdata}
│   ├── man/                   # auto-generated; do NOT hand-edit
│   ├── man-roxygen/           # shared roxygen template
│   ├── tests/testthat/
│   ├── vignettes/
│   ├── DESCRIPTION
│   ├── NAMESPACE              # auto-generated; do NOT hand-edit
│   └── README.Rmd
├── Python/                    # Python package (cmdstanpy backend)
│   ├── hbayesdm/              # source
│   │   ├── common/            # symlinks to commons/{stan_files,extdata}
│   │   └── models/            # auto-generated wrappers
│   ├── tests/
│   ├── docs/
│   ├── pyproject.toml         # uv + hatchling
│   └── Makefile
└── .github/workflows/         # CI
```

The **single source of truth** for Stan files and example data is `commons/`.
`R/inst/{stan_files,extdata}` and `Python/hbayesdm/common/{stan_files,extdata}`
are symlinks into `commons/`. Edit once in `commons/`; both packages pick it
up.

## Adding a new model

1. **Write a model spec YAML** in `commons/models/`.
2. **Write the Stan file** in `commons/stan_files/`.
3. **Provide example data** in `commons/extdata/` (only once per task).
4. **Generate R + Python wrappers** with `commons/generate-codes.sh`.
5. **Implement the preprocess function** in `R/R/preprocess_funcs.R` and
   `Python/hbayesdm/preprocess_funcs.py`.
6. **Regenerate roxygen man pages** in R.
7. **Install both packages and run the tests.**

### Step 1) Write the model-spec YAML

Copy `commons/example.yml` to `commons/models/<task_code>_<model_code>[_<model_type>].yml`
and edit. Required fields are:

- `task_name` (with `code`, `desc`, optional `cite`)
- `model_name` (with `code`, `desc`, optional `cite`)
- `model_type` — one of:
  - empty `code` + `desc: Hierarchical` (default)
  - `code: single` + `desc: Individual`
  - `code: multipleB` + `desc: Multiple-block Hierarchical`
- `data_columns` — must include `subjID`; `block` is required for `multipleB`.
- `parameters` — for each: `desc`, `info: [lower, plausible, upper]`.

Optional fields: `regressors`, `postpreds`, `additional_args`, `notes`,
`contributors`. See `commons/example.yml` for inline documentation of every
field.

**Naming convention** (used as the function name, the Stan filename, the
generated `.R` and `.py` filenames, etc.):

```
<task_code>_<model_code>[_<model_type>]
```

Examples: `ra_prospect`, `choiceRT_ddm_single`, `prl_fictitious_multipleB`.

### Step 2) Write the Stan file

Drop your `.stan` file into `commons/stan_files/` with the same base name as
the YAML. Use **canonical Stan syntax** (current as of CmdStan 2.32+):

- `array[N, T] real x;` (not `real x[N, T];`)
- `abs(...)` (not `fabs(...)`)
- Hierarchical models should use **non-centered parameterization**
  ([guide][non-centered-param]) with a `mu_pr` vector, a `sigma` vector, and
  per-subject `<param>_pr` vectors:

```stan
parameters {
  // Group-level priors
  vector[3] mu_pr;
  vector<lower=0>[3] sigma;

  // Subject-level raw parameters (Matt trick)
  vector[N] alpha_pr;
  vector[N] beta_pr;
  vector[N] gamma_pr;
}
```

[non-centered-param]: https://mc-stan.org/users/documentation/case-studies/divergences_and_bias.html

### Step 3) Provide example data (once per task)

Add `commons/extdata/<task_code>[_<model_type>]_exampleData.txt`. Format:

- Tab-separated.
- Includes a `subjID` column (required) and any other columns referenced in
  your YAML's `data_columns`.
- Reasonably small (~5–10 subjects, ~50–250 trials per subject) so example
  fits run in seconds.

### Step 4) Generate R + Python wrappers

```bash
cd commons
bash generate-codes.sh
```

Requires `pyyaml`, which is part of the dev dependency group in
`Python/pyproject.toml` — running `uv sync` in `Python/` installs it
into `Python/.venv` and `bash generate-codes.sh` will pick it up.

The script:

1. Runs `convert-to-r.py` to render `R_CODE_TEMPLATE.txt` /
   `R_DOCS_TEMPLATE.txt` / `R_TEST_TEMPLATE.txt` into per-model files in
   `_r-codes/` and `_r-tests/`.
2. Runs `convert-to-py.py` similarly for Python.
3. Copies the generated files into:
   - `R/R/<model>.R`
   - `R/tests/testthat/test_<model>.R`
   - `Python/hbayesdm/models/_<model>.py`
   - `Python/tests/test_<model>.py`
4. Cleans up the staging directories.

### Step 5) Implement the preprocess function

Both packages have a single shared file with all preprocess functions:

- **R**: `R/R/preprocess_funcs.R`
- **Python**: `Python/hbayesdm/preprocess_funcs.py`

Add a function named `<task_code>[_<model_type>]_preprocess_func` (one per
*task*, not per model — multiple models on the same task share it). The
function takes `raw_data`, `general_info`, and any `additional_args` from
the YAML, and returns a dict (Python) / named list (R) that gets passed
straight to Stan as `data`.

> **Watch out — R `additional_args` plumbing**: when defaulting per-model
> args, use single-bracket list assignment so a `NULL` default is preserved:
> ```r
> args[nm] <- list(additional_args[[nm]])    # keeps NULL
> # args[[nm]] <- NULL                        # would *delete* the entry
> ```
> See `DEVELOPERS.md` for more gotchas.

### Step 6) Regenerate roxygen documentation

```bash
cd R
Rscript -e 'roxygen2::roxygenize(".")'
```

This rewrites `R/man/<your-model>.Rd` and `R/NAMESPACE` from the roxygen
tags in your generated `R/R/<model>.R`. **Never hand-edit the `.Rd` files
or `NAMESPACE`** — they'll be overwritten on the next regenerate.

Background (you shouldn't need to act on this): roxygen2 ≥ 8.0 errors on
empty `@templateVar X` lines. `commons/convert-to-r.py` strips them before
writing the file, and the shared template at
`R/man-roxygen/model-documentation.R` uses `get0()` so the resulting
*missing* (rather than empty) templateVars degrade gracefully. If you ever
see this error in practice, regenerate with `bash commons/generate-codes.sh`
rather than hand-editing.

### Step 7) Install and test

```bash
# R side
cd R
R CMD INSTALL --no-docs --no-test-load .
NOT_CRAN=true Rscript -e 'testthat::test_file("tests/testthat/test_<your-model>.R")'

# Python side
cd ../Python
uv sync --all-groups
uv run pytest tests/test_<your-model>.py -v
```

The first model fit will take ~30 s while CmdStan compiles the binary;
subsequent fits reuse the cached binary instantly.

## Testing

| Scope | R | Python |
|---|---|---|
| Just your new model | `testthat::test_file(...)` | `pytest tests/test_<model>.py` |
| User-facing API | `testthat::test_file("tests/testthat/test_user_facing.R")` | `pytest tests/test_user_facing.py` |
| Everything | `testthat::test_dir("tests/testthat")` | `pytest tests` |

`NOT_CRAN=true` is required locally for the R test suite — the per-model
tests are gated by `skip_on_cran()` so CRAN check machines don't try to fit
Stan models.

CI (GitHub Actions) runs the user-facing suite plus a couple of model smoke
tests on every PR. The full per-model suite is local-only.

## Style

- **R**: 2-space indent, tidyverse-ish style. roxygen comments on exported
  functions.
- **Python**: 4-space indent, ruff-formatted. Type hints on public APIs.
- **Stan**: 2-space indent, lowercase variable names, blank line between
  blocks.
- **Comments**: describe current behavior, not history. Don't write "this
  used to be X", "after the refactor", etc. — git log and `R/NEWS.md` are the
  sources of truth for change history.

## License

By contributing, you agree that your contributions will be licensed under
the same terms as hBayesDM (GPL-3).
