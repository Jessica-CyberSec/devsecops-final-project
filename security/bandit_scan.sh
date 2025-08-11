#!/bin/bash
set -e
mkdir -p reports
python3 -m pip install --user bandit
# Exclude tests, report JSON, do not fail the build
python3 -m bandit -r app -x app/tests \
  --severity-level medium --confidence-level high \
  -f json -o reports/bandit.json --exit-zero

