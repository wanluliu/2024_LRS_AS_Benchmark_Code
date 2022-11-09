#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d flame-src ]; then
    git clone https://github.com/marabouboy/FLAME flame-src
    cd flame-src && git checkout b4a08dd54a0d0be8e5caba69368aaf7477c55d17 && cd ..
fi
eval "$(conda shell.bash hook)"
conda env create -f="${SHDIR}"/flame_conda_env.yaml
