#!/bin/bash
mkdir -p .cache || true
. .env/bin/activate
#python -m unittest tests.test_ring
python -m unittest discover -s tests -p "test_*.py"