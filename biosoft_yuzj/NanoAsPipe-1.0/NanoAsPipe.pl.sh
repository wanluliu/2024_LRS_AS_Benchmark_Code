#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
eval "$(conda shell.bash hook)"
conda activate NanoAsPipe
echo "${CONDA_PREFIX}"/bin/perl "${SHDIR}"/NanoAsPipe-src/NanoAsPipe.pl -SamtoolsDir "${CONDA_PREFIX}"/bin/samtools -BedtoolsDir "${CONDA_PREFIX}"/bin/bedtools -GraphMapDir "${CONDA_PREFIX}"/bin/graphmap -codeDir "${SHDIR}"/NanoAsPipe-src "${@}"
"${CONDA_PREFIX}"/bin/perl "${SHDIR}"/NanoAsPipe-src/NanoAsPipe.pl -SamtoolsDir "${CONDA_PREFIX}"/bin/samtools -BedtoolsDir "${CONDA_PREFIX}"/bin/bedtools -GraphMapDir "${CONDA_PREFIX}"/bin/graphmap -codeDir "${SHDIR}"/NanoAsPipe-src "${@}"
