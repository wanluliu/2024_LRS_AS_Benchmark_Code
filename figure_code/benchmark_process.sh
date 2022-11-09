#Alignment
minimap2 -ax splice --MD "${REF_FASTA}" "${INPUT_FASTQ}" > "${OUT_SAM}"
samtools view -bS "${SAM}" > "${BAM}"
samtools sort "${BAM}" -o "${SORTED_BAM}"
samtools sort "${SAM}" -o "${SORED_SAM}"
samtools index "${SORTED_BAM}"

# gffcompare
sh gffcompare.sh -r "${REFERENCE_GTF}" "${QUERY_GTF}" -o "${OUT_PREFIX}"
sh get_gffcmp_csv.sh "${GFFCMP.STATS}" "${SOFTWARE}" "${SIMULATED_PARAM}" "${DATA_TYPE}" "${OUT}"
##Obtain mean and sd
Rscript get_mean_sd.R -i "${IN_CSV}" -o "${OUT_DIR}" -s "${SOFTWARE_NAME}" --type {AS,ANNO,DEPTH}

# SQANTI3
sh sqanti3_qc.py.sh "${QUERY_GTF}" "${REFERENCE_GTF}" "${REFERENCE_FA}" -o "${OUT_PREFIX}"
sh sqanti_result_conclude.sh "${SOFTWARE}" "${DATA_TYPE}"

# BEDtools jaccard
bedtools sort -i "${INPUT}" > "${OUTPUT_SORTED}"
bedtools jaccard -a "${SORTED1_BED}" -b "${SORTED2_BED}" > "${OUTPUT}"


