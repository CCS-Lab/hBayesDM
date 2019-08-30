#!/bin/bash

# Scripts for R
if [ "$TARGET" = "R" ]; then
  R CMD build .
  R CMD check hBayesDM*.tar.gz

# Scripts for Python
elif [ "$TARGET" = "Python" ]; then
  pytest tests/test_ra_prospect.py --reruns 5

# Otherwise
else
  echo 'No script required'
fi

