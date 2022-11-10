#!/usr/bin/env bash
set -e
SHDIR="$(dirname "$(readlink -f "${0}")")"
eval "$(conda shell.bash hook)"
conda activate mandalorion
export PATH="${SHDIR}/bin:${PATH}"

exec "${CONDA_PREFIX}"/bin/python3 "${SHDIR}"/Mandalorion-src/Mando.py "${@}"
