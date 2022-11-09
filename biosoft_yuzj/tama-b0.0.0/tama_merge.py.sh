#!/usr/bin/env bash
set -e
SHDIR="$(dirname "$(readlink -f "${0}")")"
eval "$(conda shell.bash hook)"
conda activate tama

exec "${CONDA_PREFIX}"/bin/python3 "${SHDIR}"/tama-src/tama_merge.py "${@}"
