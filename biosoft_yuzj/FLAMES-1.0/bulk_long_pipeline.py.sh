#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
eval "$(conda shell.bash hook)"
conda activate FLAMES

export PYTHONPATH="${SHDIR}"/flames-src/python:"${PYTHONPATH}"
export PATH="${SHDIR}"/flames-src/python:"${PATH}"

python2 "${SHDIR}"/flames-src/python/bulk_long_pipeline.py "${@}"
