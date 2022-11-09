#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d TALON-src ]; then
    git clone https://github.com/mortazavilab/TALON TALON-src
    cd TALON-src && git checkout v5.0 && cd ..
fi

eval "$(conda shell.bash hook)"
conda env create -f="${SHDIR}"/talon_conda_env.yaml
conda activate talon
cd TALON-src && "${CONDA_PREFIX}"/bin/python3 -m pip install . && cd ..
