#!/bin/bash

python3 generate-r-codes.py -a
cp R-codes/*.R ../R/R/
cp R-tests/*.R ../R/tests/testthat/

python3 generate-python-codes.py -a
cp Python-codes/_*.py ../Python/hbayesdm/models/
cp Python-tests/*.py ../Python/tests/
