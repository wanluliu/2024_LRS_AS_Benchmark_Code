#Alignment
minimap2 -ax splice --MD ${REF_FASTA} ${INPUT_FASTQ} > ${OUT_SAM}
samtools view -bS ${SAM} > ${BAM}
samtools sort ${BAM} -o ${SORTED_BAM}
samtools sort ${SAM} -o ${SORED_SAM}
samtools index ${SORTED_BAM}

# gffcompare
sh gffcompare.sh -r ${REFERENCE_GTF} ${QUERY_GTF} -o $OUT_PREFIX
sh get_gffcmp_csv.sh ${GFFCMP.STATS} $SOFTWARE $SIMULATED_PARAM $DATA_TYPE ${OUT} 

# SQANTI3
Rscript filter_mono_exon.R/filter_mono_exon_freddie.R -i ${INPUT_GTF} -o $PREFIX
sh sqanti3_qc.py.sh ${QUERY_GTF} ${REFERENCE_GTF} ${REFERENCE_FA} -o $OUT_PREFIX
sh sqanti_result_conclude.sh $SOFTWARE $DATA_TYPE

# BEDtools jaccard
bedtools sort -i $INPUT > $OUTPUT_SORTED
bedtools jaccard -a ${SORTED1_BED} -b ${SORTED2_BED} > $OUTPUT
sh jaccard_run.sh
Rscript jaccard_plot.R -i ${INPUT_TXT} -o ${OUTPUT}

