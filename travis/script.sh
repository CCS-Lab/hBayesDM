#!/usr/bin/env bash

# Scripts for R
if [ "$TARGET" = "R" ]; then
  travis_wait 42 R CMD build . --no-build-vignettes --no-manual
  travis_wait 59 R CMD check hBayesDM*.tar.gz --as-cran --no-build-vignettes --no-manual

# Scripts for Python
elif [ "$TARGET" = "Python" ]; then
  travis_wait 30 pytest tests

# Check sync for models and data
elif [ "$TARGET" = "Sync" ]; then
  diff -r Python/hbayesdm/common/extdata R/inst/extdata
  diff -r Python/hbayesdm/common/stan_files R/inst/stan_files

# Otherwise
else
  echo 'No script required'
fi
