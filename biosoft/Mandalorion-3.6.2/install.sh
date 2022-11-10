#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d Mandalorion-src ]; then
    git clone https://github.com/christopher-vollmers/Mandalorion Mandalorion-src
    cd Mandalorion-src && git checkout v3.6.2 && cd ..
fi

if [ ! -d emtrey-src ]; then
    git clone https://github.com/rvolden/emtrey emtrey-src
    cd emtrey-src && git checkout v1.1 && cd ..
fi


if [ ! -d racon-src ]; then
    git clone https://github.com/lbcb-sci/racon racon-src
    cd racon-src && git checkout 1.5.0 && cd ..

fi

if [ ! -d minimap2-src ]; then
    git clone http://github.com/lh3/minimap2 minimap2-src
    cd minimap2-src && git checkout v2.24 && cd ..
fi

if [ ! -f minimap2-src/minimap2 ] ;then
    cd minimap2-src || exit 1
    make -j16
    cd .. || exit 1
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

if [ ! -f emtrey-src/emtrey ]; then
    cd "${SHDIR}"/emtrey-src|| exit 1
    make emtrey
    cd ..|| exit 1
fi

mkdir -p "${SHDIR}"/bin
ln -s "${SHDIR}"/blat bin/
ln -s "${SHDIR}"/minimap2-src/minimap2 "${SHDIR}"/bin/
ln -s "${SHDIR}"/racon-src/build/bin/* "${SHDIR}"/bin/
ln -s "${SHDIR}"/racon-src/build/lib/* "${SHDIR}"/bin/
ln -s "${SHDIR}"/emtrey-src/emtrey "${SHDIR}"/bin/

eval "$(conda shell.bash hook)"
conda env create -f="${SHDIR}"/mandalorion_conda_env.yaml

