#!/usr/bin/env bash
set -euo pipefail

VENV_DIR="${1:-.env}"

if [ ! -f "requirements-dev.txt" ]; then
  echo "requirements-dev.txt not found in $(pwd)" >&2
  exit 1
fi

if [ ! -d "$VENV_DIR" ]; then
  mkdir -p "$(dirname "$VENV_DIR")"
  python3 -m venv "$VENV_DIR"
fi

# shellcheck disable=SC1091
source "$VENV_DIR/bin/activate"

python -m pip install --upgrade pip
python -m pip install -r requirements-dev.txt
