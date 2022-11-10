#!/usr/bin/env bash
set -e
SHDIR="$(dirname "$(readlink -f "${0}")")"
eval "$(conda shell.bash hook)"
conda activate unagi

exec "${CONDA_PREFIX}"/bin/python3 "${SHDIR}"/UNAGI-src/app/unagi.py "${@}"
