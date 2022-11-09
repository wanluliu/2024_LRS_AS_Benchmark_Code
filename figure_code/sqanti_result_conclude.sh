#!/bin/bash
# shellcheck disable=SC2126
set -e
SOFTWARE=$1
DATA=$2
CLASSIFICATION_RESULT="/home/tgs/biosoft_yuzj/SQANTI3-4.2/SQANTI_${DATA}_${SOFTWARE}_classification.txt"
FSM=$(grep "full-splice_match" < "${CLASSIFICATION_RESULT}" | wc -l)
ISM=$(grep "incomplete-splice_match" < "${CLASSIFICATION_RESULT}" | wc -l)
NIC=$(grep "novel_in_catalog" < "${CLASSIFICATION_RESULT}" | wc -l)
NNC=$(grep "novel_not_in_catalog" < "${CLASSIFICATION_RESULT}" | wc -l)
INTERGENIC=$(grep "intergenic" < "${CLASSIFICATION_RESULT}" | wc -l)
echo "$SOFTWARE,$DATA,$FSM,$ISM,$NIC,$NNC,$INTERGENIC" >> result.csv
