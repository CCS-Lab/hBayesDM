#!/usr/bin/env bash

# Scripts for R
if [ "$TARGET" = "R" ]; then
  Rscript -e 'remotes::install_cran("pkgdown", quiet = T, repos = "https://cran.rstudio.com")'
  Rscript -e 'pkgdown::deploy_site_github()'

# Otherwise
else
  echo 'No script required'
fi
