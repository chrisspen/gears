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

render_one() {
  local scad="$1"
  local base
  base="$(basename "${scad}" .scad)"
  if [[ "${base}" == "demo" ]]; then
    return 0
  fi
  local out="${SCRIPT_DIR}/${base}.png"
  "${OPENSCAD_BIN}" -o "${out}" --imgsize 800,800 "${scad}"
  echo "Rendered ${out}"
}

if [[ "${1:-}" != "" ]]; then
  target="${1}"
  if [[ "${target}" != /* ]]; then
    if [[ "${target}" != *.scad ]]; then
      target="${SCRIPT_DIR}/${target}.scad"
    else
      target="${SCRIPT_DIR}/${target}"
    fi
  fi
  if [[ ! -f "${target}" ]]; then
    echo "Error: SCAD file not found: ${target}" >&2
    exit 1
  fi
  render_one "${target}"
else
  for scad in "${SCRIPT_DIR}"/*.scad; do
    render_one "${scad}"
  done
fi
