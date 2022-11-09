#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
mkdir -p "${SHDIR}"/usr


if [ ! -d C3POa-src ]; then
    git clone --recursive https://github.com/christopher-vollmers/C3POa C3POa-src
    cd C3POa-src && git checkout v2.3.0 && cd ..
fi

if [ ! -d racon-src ]; then
    git clone https://github.com/lbcb-sci/racon racon-src
    cd racon-src && git checkout 1.5.0 && cd ..
fi

if [ ! -d conk-src ]; then
    git clone https://github.com/rvolden/conk conk-src
    cd conk-src && git checkout 0a24a3ff7c9b8d799ce78eb269402dda645a7a1a && cd ..
fi

if [ ! -f racon-src/build/bin/racon ]; then 
    cd racon-src || exit 1
    rm -rf build 
    mkdir -p build 
    cd build || exit 1
    cmake -DCMAKE_BUILD_TYPE=Release .. 
    make -j16 
    cd "${SHDIR}" || exit 1
fi

if [ ! -f blat ]; then 
    wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v385/blat/blat
    chmod +x blat
fi

mkdir -p "${SHDIR}"/bin
ln -s "${SHDIR}"/blat bin/
ln -s "${SHDIR}"/racon-src/build/bin/* "${SHDIR}"/bin/
ln -s "${SHDIR}"/racon-src/build/lib/* "${SHDIR}"/bin/

eval "$(conda shell.bash hook)"
conda env create -f="${SHDIR}"/c3poa_conda_env.yaml
conda activate c3poa
"${CONDA_PREFIX}"/bin/python3 -m pip install ./conk-src
