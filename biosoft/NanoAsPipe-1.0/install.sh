#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d NanoAsPipe-src ]; then
    curl -L http://sysbio.unl.edu/NanoAsPipe/NanoAsPipe.tar.gz | tar -zxvf -
    mv NanoAsPipe NanoAsPipe-src
fi

dos2unix NanoAsPipe-src/*

eval "$(conda shell.bash hook)"
conda env create -f="${SHDIR}"/NanoAsPipe_conda_env.yaml
