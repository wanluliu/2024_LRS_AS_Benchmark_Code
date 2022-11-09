#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
eval "$(conda shell.bash hook)"
conda activate flair_env
. "${SHDIR}"/source_me.sh

exec "${CONDA_PREFIX}"/bin/python2 "${SHDIR}"/flair-src/flair.py "${@}"
