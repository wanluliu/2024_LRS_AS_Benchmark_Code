#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d SQANTI3-src ]; then
    [ -d SQANTI3-4.2 ] || curl -L https://github.com/ConesaLab/SQANTI3/archive/refs/tags/v4.2.tar.gz | tar -zxvf -
    mv SQANTI3-4.2 SQANTI3-src
fi

eval "$(conda shell.bash hook)"
conda env create -f="${SHDIR}"/SQANTI3-src/SQANTI3.conda_env.yml

if [ ! -f "${SHDIR}"/SQANTI3-src/utilities/gtfToGenePred ]; then
    wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/gtfToGenePred -O "${SHDIR}"/SQANTI3-src/utilities/gtfToGenePred
fi
chmod +x "${SHDIR}"/SQANTI3-src/utilities/gtfToGenePred

conda activate SQANTI3.env

if [ ! -d cDNA_Cupcake-src ]; then
    git clone https://github.com/Magdoll/cDNA_Cupcake.git cDNA_Cupcake-src
    cd cDNA_Cupcake-src && git checkout 29478d6f6a92e389396805049423303e7615577e && cd ..
fi

cd cDNA_Cupcake-src || exit 1
"${CONDA_PREFIX}"/bin/python3 setup.py build
"${CONDA_PREFIX}"/bin/python3 setup.py install
