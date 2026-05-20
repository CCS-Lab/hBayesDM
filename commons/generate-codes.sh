#!/bin/bash
set -e
cd "$(dirname "$0")"

# Resolve the Python interpreter: prefer `uv run` against Python/pyproject.toml
# (which carries pyyaml in the dev group), fall back to system python if uv
# isn't installed.
if command -v uv >/dev/null 2>&1; then
  PY=(uv run --project ../Python python)
else
  PY=(python)
fi

"${PY[@]}" convert-to-r.py
cp _r-codes/*.R ../R/R/
cp _r-tests/*.R ../R/tests/testthat/

"${PY[@]}" convert-to-py.py
cp _py-codes/_*.py ../Python/hbayesdm/models/
cp _py-tests/*.py ../Python/tests/

rm -rf _r-codes _r-tests _py-codes _py-tests

