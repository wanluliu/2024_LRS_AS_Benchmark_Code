#!/usr/bin/env bash
set -e
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d gmap-src ]; then
    curl -L http://research-pub.gene.com/gmap/src/gmap-gsnap-2021-12-17.tar.gz | tar -zxvf -
    mv gmap-2021-12-17 gmap-src
fi

cd gmap-src || exit 1
./configure --prefix="${SHDIR}/usr/"
make -j160 install
cd ..
