#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d gffcompare-src ]; then
    git clone https://github.com/gpertea/gffcompare gffcompare-src
    cd gffcompare-src && git checkout v0.12.6 && cd ..
fi
cd gffcompare-src && make -j16
