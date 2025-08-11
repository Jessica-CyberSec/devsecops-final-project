#!/bin/bash
set -e
pip install bandit
bandit -r app
