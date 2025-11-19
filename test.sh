#!/bin/bash
mkdir -p .cache || true
. .env/bin/activate
python -m unittest tests.test_ring