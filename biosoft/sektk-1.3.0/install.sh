#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d seqtk-src ]; then
    git clone https://github.com/lh3/seqtk seqtk-src
    cd seqtk-src && git checkout v1.3 && cd ..
fi
cd seqtk-src || exit 1
make -j16
cd .. || exit 1

