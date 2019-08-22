#!/bin/bash

python3 convert-to-r.py
cp _r-codes/*.R ../R/R/
cp _r-tests/*.R ../R/tests/testthat/

python3 generate-python-codes.py -a
cp Python-codes/_*.py ../Python/hbayesdm/models/
cp Python-tests/*.py ../Python/tests/
