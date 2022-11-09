#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d stringtie-src ]; then
    git clone https://github.com/gpertea/stringtie stringtie-src
    cd stringtie-src && git checkout d979ac8dd139b67ad4233fcf423714961d53ede8 && cd ..
fi
cd stringtie-src || exit 1
make release -j16
cd .. || exit 1
