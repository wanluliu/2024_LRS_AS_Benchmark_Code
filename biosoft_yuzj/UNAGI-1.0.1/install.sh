#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d UNAGI-src ]; then
    git clone https://github.com/iMetOsaka/UNAGI UNAGI-src
    cd UNAGI-src && git checkout 4ebd5fa794fcf892828d0fa395e3b461f3c25767 && cd ..
fi

eval "$(conda shell.bash hook)"
conda env create -f="${SHDIR}"/unagi_conda_env.yaml
