#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d flames-src ]; then
    git clone https://github.com/LuyiTian/FLAMES.git flames-src
    cd flames-src && git checkout 18fb83c7f09baf8325efac1506ef5380de580661 && cd ..
fi
eval "$(conda shell.bash hook)"
conda env create -f="${SHDIR}"/FLAMES_conda_env.yaml
