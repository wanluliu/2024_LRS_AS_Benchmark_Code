#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d minimap2-src ]; then
    git clone http://github.com/lh3/minimap2 minimap2-src
    cd minimap2-src && git checkout 06fedaadd0f88074bd68527e6e34634ffe21273e && cd ..
fi
cd minimap2-src || exit 1
make -j16
cd .. || exit 1

