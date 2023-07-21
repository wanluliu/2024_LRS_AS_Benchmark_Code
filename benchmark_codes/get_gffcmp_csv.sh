#!/bin/bash
input=$1
soft=$2
depth=$3
data=$4
out=$5
cat $input | grep 'Transcript level' | grep -o '[0-9.]*' > $input.trans
sed -n '1p' $input.trans > $input.sensitivity
sed -n '2p' $input.trans > $input.precision
echo "$soft,$depth,$data" > $input.csv
paste -d "," $input.sensitivity $input.precision $input.csv >> $out
rm -rf $input.csv $input.sensitivity $input.precision $input.trans

