IN_A=$1
IN_B=$2
OUT=$3
tail -1 jaccard*"${IN_A}"*"${IN_B}"*.txt | awk -F '\t' '{print $3}' > jaccard
echo "${IN_A}" > IN_A
echo "${IN_B}" > IN_B
paste IN_A IN_B jaccard > result_tmp
cat result_tmp >> $OUT
rm -rf result_tmp IN_A IN_B
