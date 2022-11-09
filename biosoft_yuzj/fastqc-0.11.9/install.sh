#!/usr/bin/env bash
SHDIR="$(dirname "$(readlink -f "${0}")")"
cd "${SHDIR}" || exit 1

if [ ! -d fastqc-src ]; then
    wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
    unzip fastqc_v0.11.9.zip
    mv FastQC fastqc-src
fi

chmod +x fastqc-src/fastqc
ln -sf "${SHDIR}"/fastqc-src/fastqc "${SHDIR}"/fastqc 
