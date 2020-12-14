#!/bin/bash

# Setup codes for R
if [ "$TARGET" = "R" ]; then
  # Setup a config for R
  mkdir -p ~/.R/
  echo "CC = ${CC}" >> ~/.R/Makevars
  echo "CXX = ${CXX} -fPIC " >> ~/.R/Makevars
  echo "CXX14 = ${CXX} -fPIC -flto=2" >> ~/.R/Makevars
  echo "CXX14FLAGS = -mtune=native -march=native -Wno-ignored-attributes -O0 -Wall" >> ~/.R/Makevars

  Rscript \
    -e 'install.packages("devtools", repos = "https://cloud.r-project.org/", quiet = TRUE)' \
    -e 'devtools::install_deps(quiet = TRUE)'

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

  # Install poetry
  curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
  source $HOME/.poetry/env

  # Install dependencies
  poetry install

# Otherwise
else
  echo 'No setup required'
fi
