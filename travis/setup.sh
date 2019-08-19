#!/usr/bin/env bash

# Setup codes for R
if [ "$TARGET" = "R" ]; then
  export R_LIBS_USER=~/R/Library
  export R_LIBS_SITE=/usr/local/lib/R/site-library:/usr/lib/R/site-library
  export _R_CHECK_CRAN_INCOMING_=false
  export NOT_CRAN=true
  export R_PROFILE=~/.Rprofile.site

  # Add CRAN as an APT source
  sudo echo 'deb https://cloud.r-project.org/bin/linux/ubuntu trusty-cran35/' >> /etc/apt/sources.list
  sudo apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'
  sudo apt-get update

  # Install R with the latest version
  sudo apt-get install -y -q --allow-unauthenticated r-base r-base-core r-base-dev
  hash -r

  # Setup a config for R
  mkdir -p ~/.R/
  echo "CC = ${CC}" >> ~/.R/Makevars
  echo "CXX = ${CXX} -fPIC " >> ~/.R/Makevars
  echo "CXX14 = ${CXX} -fPIC -flto=2" >> ~/.R/Makevars
  echo "CXX14FLAGS = -mtune=native -march=native -Wno-ignored-attributes -O0" >> ~/.R/Makevars

  # Install R packages
  Rscript \
    -e 'install.packages(c("devtools", "roxygen2", "covr"), quiet = T, repos = "https://cran.rstudio.com")' \
    -e 'devtools::install_deps(dep = T, quiet = T)'

# Setup codes for Python
elif [ "$TARGET" = "Python" ]; then

  if [ ! -d "$HOME/miniconda" ]; then
    # Download Miniconda & Install it
    wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh;
    bash miniconda.sh -b -p $HOME/miniconda
  fi

  # Add PATH for Miniconda
  export PATH="$HOME/miniconda/bin:$PATH"
  hash -r

  # Conda config & Update conda
  conda config --set always_yes yes --set changeps1 no
  conda update -q conda

  # Debug
  conda info -a

  if [[ -z "$PYTHON_VERSION" ]]; then
    echo "Use latest Python version"
    conda create -q -n test-$PYTHON_VERSION python
  else
    echo "Use Python ${PYTHON_VERSION}"
    conda create -q -n test-$PYTHON_VERSION python="$PYTHON_VERSION"
  fi
  conda activate test-$PYTHON_VERSION

  # Install dependencies
  pip install -r requirements.txt --upgrade
  pip install -r requirements-dev.txt --upgrade

# Otherwise
else
  echo 'No setup required'
fi
