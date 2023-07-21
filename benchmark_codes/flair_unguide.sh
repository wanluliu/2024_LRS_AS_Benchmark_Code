#!/usr/bin/env bash

INPUT=$1

cat $INPUT | cut -f 4 > C4_tmp
sed -i 's/;[0-9]*//g' C4_tmp
cp C4_tmp C4_tmp.cp
paste -d ';' C4_tmp C4_tmp.cp > C4_reform_tmp
cat $INPUT | cut -f 1,2,3 > C123_tmp
cat $INPUT | cut -f 5,6,7,8,9,10,11,12 > Crest_tmp
cat C123_tmp | paste - C4_reform_tmp | paste - Crest_tmp > $INPUT.reform
rm -rf C*tmp*
python2 /home/tgs/biosoft_yuzj/tama-b0.0.0/tama-src/tama_go/format_converter/tama_convert_bed_gtf_ensembl_no_cds.py $INPUT.reform $INPUT.gtf
rm -rf $INPUT.reform
