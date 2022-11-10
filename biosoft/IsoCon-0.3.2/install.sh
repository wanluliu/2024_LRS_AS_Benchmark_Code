#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d IsoCon-src ]; then
    git clone https://github.com/ksahlin/IsoCon IsoCon-src
    cd IsoCon-src && git checkout 0.3.2 && cd ..
fi

eval "$(conda shell.bash hook)"
conda env create -f="${SHDIR}"/IsoCon_conda_env.yaml
