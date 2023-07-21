#!/bin/bash
set -e
SOFTWARE=$1
DATA=$2
FSM=$(cat /home/tgs/biosoft_yuzj/SQANTI3-4.2/SQANTI_"${DATA}"_"${SOFTWARE}"_classification.txt | grep "full-splice_match" | wc -l)
ISM=$(cat /home/tgs/biosoft_yuzj/SQANTI3-4.2/SQANTI_"${DATA}"_"${SOFTWARE}"_classification.txt | grep "incomplete-splice_match" | wc -l)
NIC=$(cat /home/tgs/biosoft_yuzj/SQANTI3-4.2/SQANTI_"${DATA}"_"${SOFTWARE}"_classification.txt | grep "novel_in_catalog" | wc -l)
NNC=$(cat /home/tgs/biosoft_yuzj/SQANTI3-4.2/SQANTI_"${DATA}"_"${SOFTWARE}"_classification.txt | grep "novel_not_in_catalog" | wc -l)
INTERGENIC=$(cat /home/tgs/biosoft_yuzj/SQANTI3-4.2/SQANTI_"${DATA}"_"${SOFTWARE}"_classification.txt | grep "intergenic" | wc -l)
echo "$SOFTWARE,$DATA,$FSM,$ISM,$NIC,$NNC,$INTERGENIC" >> result.csv
