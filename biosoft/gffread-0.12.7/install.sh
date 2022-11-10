#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d gffread-src ]; then
    git clone https://github.com/gpertea/gffread gffread-src
    cd gffread-src && git checkout v0.12.7 && cd ..
fi
cd gffread-src || exit 1
make -j16
cd .. || exit 1

