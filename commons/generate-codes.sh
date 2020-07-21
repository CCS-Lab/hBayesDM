#!/bin/bash

python convert-to-r.py
cp _r-codes/*.R ../R/R/
cp _r-tests/*.R ../R/tests/testthat/

python convert-to-py.py
cp _py-codes/_*.py ../Python/hbayesdm/models/
cp _py-tests/*.py ../Python/tests/

rm -rf _r-codes _r-tests _py-codes _py-tests

