#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d tama-src ]; then
    git clone https://github.com/GenomeRIK/tama tama-src
    cd tama-src && git checkout b2c021d56dfec99387b23301e07a3476a1e47a38 && cd ..
fi

eval "$(conda shell.bash hook)"
conda env create -f="${SHDIR}"/tama_conda_env.yaml
