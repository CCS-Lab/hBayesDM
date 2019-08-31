#!/bin/bash

# Scripts for R
if [ "$TARGET" = "R" ]; then
  travis_wait 59 R CMD build .
  travis_wait 59 R CMD check hBayesDM*.tar.gz --no-tests

# Scripts for Python
elif [ "$TARGET" = "Python" ]; then
  pytest tests/test_ra_prospect.py --reruns 5

# Otherwise
else
  echo 'No script required'
fi

