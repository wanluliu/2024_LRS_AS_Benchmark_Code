#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
eval "$(conda shell.bash hook)"
conda activate traphlor_py

exec "${CONDA_PREFIX}"/bin/python2 "${SHDIR}"/Seq2DagChainer-src/traphlor/runTraphlor.py "${@}"
