#!/bin/bash
set -e
TARGET_URL="${1:-http://localhost:5000}"
docker run --rm -t owasp/zap2docker-stable zap-baseline.py -t "$TARGET_URL" -r zap_report.html || true
