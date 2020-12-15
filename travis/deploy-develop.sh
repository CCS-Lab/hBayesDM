#!/bin/bash

# Scripts for R
if [ "$TARGET" = "R" ]; then
  echo "$(pwd)"
  # export PKG_TARBALL=$(Rscript -e 'pkg <- devtools::as.package("."); cat(paste0(pkg$package,"_",pkg$version,".tar.gz"))')
  R CMD build .
  Rscript -e 'install.packages("pkgdown")'
  Rscript -e "pkgdown::deploy_site_github()"

# Otherwise
else
  echo 'No script required'
fi

