#!/bin/bash

python3 convert-to-r.py
cp _r-codes/*.R ../R/R/
cp _r-tests/*.R ../R/tests/testthat/

python3 convert-to-py.py
cp _py-codes/_*.py ../Python/hbayesdm/models/
cp _py-tests/*.py ../Python/tests/
