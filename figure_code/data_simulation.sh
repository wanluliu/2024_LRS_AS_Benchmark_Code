#!/usr/bin/env bash
axel https://hgdownload.soe.ucsc.edu/goldenPath/ce11/bigZips/ce11.fa.gz
gzip -dk ce11.fa.gz
samtools faidx ce11.fa
axel https://hgdownload.soe.ucsc.edu/goldenPath/ce11/bigZips/genes/ce11.ncbiRefSeq.gtf.gz
python3 -m yasim generate_as_events -f ce11.fa -g ce11.ncbiRefSeq.gtf.gz -o ce11.sel.gtf
for d in 20 40 60 80 100; do
    python3 -m yasim generate_depth -g ce11.sel.gtf -d "${d}" -o depth_"${d}".tsv
    python3 -m yasim transcribe -f ce11.fa -g ce11.sel.gtf -d depth_"${d}".tsv -o depth_"${d}"_cnda.fa
    python3 -m yasim pbsim -e /root/miniconda3/envs/pbsim/bin/pbsim -F depth_"${d}"_cnda.fa.d -o depth_"${d}"_pbsim_clr &
done

for d in 20 40 60 80 100; do
    for m in nanopore2018 nanopore2020 pacbio2016; do
        python3 -m yasim badread -e /root/miniconda3/envs/badread/bin/badread -F depth_"${d}"_cnda.fa.d -o depth_"${d}"_badread_"${m}" -m "${m}"
    done
done

for d in 20 40 60 80 100; do
    for m in R94; do
        python3 -m yasim pbsim2 -e /root/miniconda3/envs/pbsim2/bin/pbsim -F depth_"${d}"_cnda.fa.d -o depth_"${d}"_pbsim2_"${m}" -m "${m}"
    done
done


# Extract percent GTF
for i in 20 40 60 80 100;do
    python -m bioutils sample_transcript -g ce11.sel.gtf --percent $i --out "${i}".gtf
done

# Isoform per gene
python -m yasim.helper.as_events ce11.ncbiRefSeq.gtf.gz # Generates 1 3 5 7 9.gtf
