#!/usr/bin/env bash

# Setup codes for R
if [ "$TARGET" = "R" ]; then
  # Add CRAN as an APT source
  sudo echo 'deb https://cloud.r-project.org/bin/linux/ubuntu trusty-cran35/' >> /etc/apt/sources.list
  sudo apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'
  sudo apt-get update

  # Install R with the latest version
  sudo apt-get install -y --allow-unauthenticated r-base-dev

  # Setup a config for R
  mkdir -p ~/.R/
  echo "CC = ${CC}" >> ~/.R/Makevars
  echo "CXX = ${CXX} -fPIC " >> ~/.R/Makevars
  echo "CXX14 = ${CXX} -fPIC -flto=2" >> ~/.R/Makevars
  echo "CXX14FLAGS = -mtune=native -march=native -Wno-ignored-attributes -O0" >> ~/.R/Makevars

  # Install R packages
  sudo R \
    -e 'install.packages(c("devtools", "roxygen2", "covr"), quiet = T, repos = "https://cran.rstudio.com")' \
    -e 'devtools::install_deps(dep = T, quiet = T)'

# Setup codes for Python
elif [ "$TARGET" = "Python" ]; then
  # Download Miniconda and install it
  wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
  chmod +x miniconda.sh
  ./miniconda.sh -b

  # Set PATH for Miniconda
  export PATH=$HOME/miniconda3/bin:$PATH
  conda init

  # Update conda
  conda update --yes conda

  if [[ -z "$PYTHON_VERSION" ]]; then
    echo "Use latest Python version"
    conda create -y -n test python
  else
    echo "Use Python ${PYTHON_VERSION}"
    conda create -y -n test python="$PYTHON_VERSION"
  fi
  conda activate test

  # Install dependencies
  pip install -r requirements.txt
  pip install -r requirements-dev.txt

# Otherwise
else
  echo 'No setup required'
fi
