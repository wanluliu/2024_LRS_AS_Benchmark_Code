#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d STAR-src ]; then
    git clone https://github.com/alexdobin/STAR STAR-src
    cd STAR-src && git checkout 2.7.10a && cd ..
fi
cd STAR-src/source || exit 1
make STAR -j16
cd .. || exit 1
