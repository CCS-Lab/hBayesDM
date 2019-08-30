#!/bin/bash

# Scripts for R
if [ "$TARGET" = "R" ]; then
  cd $ROOTPATH/R
  Rscript -e 'remotes::install_cran("pkgdown", quiet = T, repos = "https://cran.rstudio.com")'
  R CMD build .
  Rscript -e 'pkgdown::deploy_site_github()'

# Otherwise
else
  echo 'No script required'
fi

exit 0

