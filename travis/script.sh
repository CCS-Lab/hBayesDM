#!/usr/bin/env bash

# Scripts for R
if [ "$TARGET" = "R" ]; then
  travis_wait 42 R CMD build . --no-build-vignettes --no-manual
  travis_wait 59 R CMD check hBayesDM*.tar.gz --as-cran --no-build-vignettes --no-manual

# Scripts for Python
elif [ "$TARGET" = "Python" ]; then
  travis_wait 30 pytest tests/test_ra_prospect.py --reruns 5

# Otherwise
else
  echo 'No script required'
fi

