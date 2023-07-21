#! /usr/bin/env Rscript
library(argparse)
parser <- ArgumentParser()
parser$add_argument("-i","--input",help="The input unagi BED file")
parser$add_argument("-o","--output",help="output directory")
args<-parser$parse_args()
iso<-read.table(args$input,sep="\t")
for (i in 1:nrow(iso)){
	  gene<-as.character(iso[i,1])
  trans<-paste0(gene,".",i)
    iso[i,4]<-paste0(gene,";",trans)
}
write.table(iso,args$output,row.names = F,col.names = F,quote=F,sep = "\t")
