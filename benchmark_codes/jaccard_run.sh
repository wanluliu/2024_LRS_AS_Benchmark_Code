SAMPLE=$1
cd $SAMPLE
cp ~/benchmark_codes/gather_jaccard.sh .
for i in $SAMPLE.*gtf;do bedtools sort -i $i > sorted.$i;done
for i in sorted.*;do for n in sorted.*;do bedtools jaccard -a $i -b $n > jaccard_"${i}"_"${n}".txt;done;done
for i in freddie FLAMES stringtie_guide stringtie_unguide bambu_unguide talon flair_guide flair_unguide bambu_guide;do for n in freddie FLAMES stringtie_guide stringtie_unguide bambu_unguide talon flair_guide flair_unguide bambu_guide;do sh gather_jaccard.sh $i $n gather_jaccard.txt;done;done
