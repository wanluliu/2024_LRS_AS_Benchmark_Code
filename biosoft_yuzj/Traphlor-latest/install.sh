#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d Seq2DagChainer-src ]; then
    git clone https://github.com/Anna-Kuosmanen/Seq2DagChainer Seq2DagChainer-src
    cd Seq2DagChainer-src && git checkout 9f041c7deecca2d8d4235e7e5e0658db57c4b924 && cd ..
fi

cd "${SHDIR}"/Seq2DagChainer-src/traphlor/RNA_MPC_SC || exit 1
make -j16

eval "$(conda shell.bash hook)"
conda env create -f="${SHDIR}"/traphlor_py_conda_env.yaml

