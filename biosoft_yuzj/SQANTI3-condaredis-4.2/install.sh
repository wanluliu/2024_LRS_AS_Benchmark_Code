#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d SQANTI3-src ]; then
    [ -d SQANTI3-4.2 ] || curl -L https://github.com/ConesaLab/SQANTI3/archive/refs/tags/v4.2.tar.gz | tar -zxvf -
    mv SQANTI3-4.2 SQANTI3-src
fi

eval "$(conda shell.bash hook)"
conda env create -f="${SHDIR}"/SQANTI3_conda_env.yaml
