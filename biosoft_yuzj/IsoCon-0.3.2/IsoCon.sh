#!/usr/bin/env bash
set -e
SHDIR="$(dirname "$(readlink -f "${0}")")"
eval "$(conda shell.bash hook)"
conda activate IsoCon

exec "${CONDA_PREFIX}"/bin/python3 "${SHDIR}"/IsoCon-src/IsoCon "${@}"
