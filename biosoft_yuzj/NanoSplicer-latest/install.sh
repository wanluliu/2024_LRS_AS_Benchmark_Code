#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d NanoSplicer-src ]; then
    git clone https://github.com/shimlab/NanoSplicer NanoSplicer-src
    cd NanoSplicer-src && git checkout e9d7902d0b7dc90ea6d27ed84e9c21193f8d5593 && cd ..
fi

eval "$(conda shell.bash hook)"
conda env create -f="${SHDIR}"/nanosplicer_conda_env.yaml
