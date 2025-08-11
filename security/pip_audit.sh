#!/bin/bash
set -e
python3 -m pip install --user pip-audit
python3 -m pip_audit -r app/requirements.txt

