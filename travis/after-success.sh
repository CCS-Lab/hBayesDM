#!/bin/bash

# Scripts for R
if [ "$TARGET" = "R" ]; then
  travis_wait 40 Rscript -e 'covr::codecov()'
  cat hBayesDM.Rcheck/00*

  if [ "$TRAVIS_BRANCH" = "develop" ]; then
    Rscript -e 'install.packages("pkgdown")'
    Rscript -e "pkgdown::deploy_site_github()"
  fi

# Scripts for Python
elif [ "$TARGET" = "Python" ]; then
  flake8 hbayesdm --format=pylint --statistics --exit-zero
  pylint hbayesdm --rcfile=setup.cfg --exit-zero

# Otherwise
else
  echo 'No after-success job required'
fi
