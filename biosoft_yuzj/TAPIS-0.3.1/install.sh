#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1
if [ ! -d tapis-src ]; then
    git clone https://bitbucket.org/comp_bio/tapis.git tapis-src
    cd tapis-src && git checkout 44cc05ebc78c27b693fdfd62413a171e5de651be && cd ..
fi

if [ ! -d SpliceGrapher-0.2.7-src ]; then
    curl -L https://sourceforge.net/projects/splicegrapher/files/SpliceGrapher-0.2.7.tgz/download | tar xzvf -
    mv SpliceGrapher-0.2.7 SpliceGrapher-0.2.7-src
fi

if [ ! -d PyML-0.7.14-src ]; then
    curl -L https://sourceforge.net/projects/pyml/files/PyML-0.7.14.tar.gz/download | tar xzvf -
    mv PyML-0.7.14 PyML-0.7.14-src
fi


eval "$(conda shell.bash hook)"
conda env create -f="${SHDIR}"/tapis_conda_env.yaml
conda activate tapis

"${CONDA_PREFIX}"/bin/python2 -m pip install ./PyML-0.7.14-src ./SpliceGrapher-0.2.7-src ./tapis-src
