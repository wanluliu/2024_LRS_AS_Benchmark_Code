#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d freddie-src ]; then
    git clone https://github.com/vpc-ccg/freddie.git freddie-src
    cd freddie-src && git checkout 501d9f0867335f35d113e4708cc9a116cca7b47a && cd ..
fi

eval "$(conda shell.bash hook)"
conda env create -f="${SHDIR}"/freddie-src/envs/freddie.yml
