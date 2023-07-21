
#StringTie2 (Guided; Run in unguide mode without "-G")
sh stringtie.sh -L -G ${REFERENCE_GTF} -o $PREFIX_GTF ${INPUT_BAM} -p $THREADS

#Bambu (guided)
Rscript bambu_guide.R -b ${INPUT_BAM} -g ${REFERENCE_GTF} -f ${REFERENCE_FA} -o $PREFIX
Rscript extract_bambu_construct.R -i ${BAMBU_OUT_DIR} -t ${TXT_FOR_TARGET_TRANSCRIPT}_

#Bambu (unguided)
Rscript bambu_unguide.R -b ${INPUT_BAM} -f ${REFERENCE_FA} -o $PREFIX

#Flair (Guided)
python2 bam2Bed12.py -i ${INPUT_BAM} > $PREFIX_BED12
sh flair.py.sh correct -q ${INPUT_BED12} -g ${REFERENCE_FA} -f ${REFERENCE_GTF} -o $PREFIX
sh flair.py.sh collapse -g ${REFERENCE_FA} -r ${INPUT_FQ} -q ${CORRECTED_BED} -f ${REFERENCE_GTF} -o $PREFIX

#Flair (Unguided)
python2 bam2Bed12.py -i ${INPUT_BAM} > $PREFIX_BED12
sh flair.py.sh collapse -g ${REFERENCE_FA} -r ${INPUT_FQ} -q ${INPUT_BED12} -o $PREFIX

#FLAMES
sh bulk_long_pipeline.py.sh --gff3 ${REFERENCE_GTF} -b ${INPUT_BAM} --config config.json -f ${REFERENCE_FA} -o $OUT_DIRECTORY

#Freddie
sh freddie_wrapper.sh freddie_split.py --reads ${INPUT_FQ} --bam ${INPUT_BAM} --outdir $OUT_DIRECTORY -t $THREADS
sh freddie_wrapper.sh freddie_segment.py -s $SPLIT_DIRECTORY --outdir $OUT_DIRECTORY -t $THREADS
sh freddie_wrapper.sh freddie_cluster.py --segment-dir $SEGMENT_DIRECTORY --outdir $OUT_DIRECTORY
sh freddie_wrapper.sh freddie_isoforms.py --split-dir $SPLIT_DIRECTORY --cluster-dir $CLUSTER_DIRECTORY --output $OUT_GTF -t $THREADS

#Talon
talon_initialize_database --f ${REFERENCE_GTF} --a $ANNOTATION_NAME --g $GENOME_NAME --o $PREFIX
talon_label_reads --f ${INPUT_SAM} --g ${REFERENCE_FA} --t $THREADS --ar 20 --deleteTmp --o $PREFIX
talon --f ${INPUT_CSV} --db ${TALON_DATABASE} --build $GENOME_NAME --o $PREFIX
talon_summarize --db ${TALON_DATABASE} --v --o $PREFIX
talon_abundance --db ${TALON_DATABASE} --a $ANNOTATION_NAME --build $GENOME_NAME --o $PREFIX
talon_filter_transcripts -db ${TALON_DATABASE} -a $ANNOTATION_NAME --maxFracA 0.5 --minCount 5 --minDatasets 1 --o $OUT_FILTERED_TRANS_CSV
talon_create_GTF --db ${TALON_DATABASE} --whitelist ${FILTER_TRANS_CSV} -a $ANNOTATION_NAME --build $GENOME_NAME --o $PREFIX

#TAMA
sh tama_collapse.py.sh -s ${INPUT_SAM} -f ${REFERENCE_FA} -p $PREFIX -x no_cap
python2 tama_convert_bed_gtf_ensembl_no_cds.py ${TAMA_OUT_BED} $OUT_GTF

#UNAGI
sh unagi.sh -s -i ${INPUT_FQ} -o $PREFIX -g ${REFERENCE_GENOME} 
Rscript unagi_bed12.R -i ${raw_BED} -o ${OUT_BED12}
python2 UNAGIbed_gtf_ensembl_no_cds.py ${BED12} ${GTF}




