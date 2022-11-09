#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
eval "$(conda shell.bash hook)"
conda activate flame

exec "${CONDA_PREFIX}"/bin/python3 "${SHDIR}"/flame-src/FLAME/FLAME.py "${@}"
