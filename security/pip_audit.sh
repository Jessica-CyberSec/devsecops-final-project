#!/bin/bash
set -e
pip install pip-audit
pip-audit -r app/requirements.txt
