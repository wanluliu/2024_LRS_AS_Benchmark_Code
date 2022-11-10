#!/usr/bin/env bash
set -e
SHDIR="$(dirname "$(readlink -f "${0}")")"
eval "$(conda shell.bash hook)"
conda activate freddie

export GRB_LICENSE_FILE="${SHDIR}"/gurobi.lic 

#shellcheck disable=SC2145
exec "${CONDA_PREFIX}"/bin/python3 "${SHDIR}"/freddie-src/py/"${@}"
