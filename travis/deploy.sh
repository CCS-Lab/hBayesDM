#!/bin/bash

function bell() {
  while true; do
    echo -e "\a"
    sleep 60
  done
}
bell &

cd $ROOTPATH/R
Rscript -e 'pkgdown::deploy_site_github(verbose = TRUE)'

kill %1

