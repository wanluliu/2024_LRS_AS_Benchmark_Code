#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
mkdir -p "${SHDIR}"/usr


if [ ! -d htslib-src ]; then
    git clone --recursive http://github.com/samtools/htslib htslib-src
    cd htslib-src && git checkout 1.12 && cd ..
fi

if [ ! -f "${SHDIR}"/usr/bin/htsfile ]; then
    cd htslib-src || exit 1
    make -j16 install prefix="${SHDIR}"/usr
    cd .. || exit 1
fi
. "${SHDIR}"/source_me.sh

if [ ! -d samtools-src ]; then
    git clone http://github.com/samtools/samtools samtools-src
    cd samtools-src && git checkout 1.12 && cd ..
fi

if [ ! -f "${SHDIR}"/usr/bin/samtools ]; then
    cd samtools-src || exit 1
    autoreconf --install --force --verbose
    ./configure --prefix="${SHDIR}"/usr --with-htslib=system
    make -j16 install
    cd .. || exit 1
fi

if [ ! -d minimap2-src ]; then
    git clone http://github.com/lh3/minimap2 minimap2-src
    cd minimap2-src && git checkout 06fedaadd0f88074bd68527e6e34634ffe21273e && cd ..
fi

if [ ! -f "${SHDIR}"/usr/bin/minimap2 ]; then
    cd minimap2-src || exit 1
    make -j16 all extra
    cp minimap2 sdust minimap2-lite "${SHDIR}"/usr/bin/
    cp minimap2.1 "${SHDIR}"/usr/share/man/man1/
    cd .. || exit 1
fi

if [ ! -d bedtools-src ]; then
    git clone https://github.com/arq5x/bedtools2 bedtools-src
    cd bedtools-src && git checkout v2.25.0 && cd ..
fi

if [ ! -f "${SHDIR}"/usr/bin/bedtools ]; then
    cd bedtools-src || exit 1
    make -j16 install prefix="${SHDIR}"/usr
    cd .. || exit 1
fi

if [ ! -d flair-src ]; then
    git clone https://github.com/BrooksLabUCSC/flair flair-src
    cd flair-src && git checkout v1.5 && cd ..
fi

eval "$(conda shell.bash hook)"
conda env create -f="${SHDIR}"/flair_conda_env.yaml
