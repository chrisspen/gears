#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENSCAD_BIN=""
if command -v openscad-nightly >/dev/null 2>&1; then
  OPENSCAD_BIN="openscad-nightly"
elif command -v openscad >/dev/null 2>&1; then
  OPENSCAD_BIN="openscad"
else
  echo "Error: openscad-nightly or openscad not found in PATH." >&2
  exit 1
fi

for scad in "${SCRIPT_DIR}"/*.scad; do
  base="$(basename "${scad}" .scad)"
  if [[ "${base}" == "demo" ]]; then
    continue
  fi
  out="${SCRIPT_DIR}/${base}.png"
  "${OPENSCAD_BIN}" -o "${out}" --imgsize 800,800 "${scad}"
  echo "Rendered ${out}"
done
