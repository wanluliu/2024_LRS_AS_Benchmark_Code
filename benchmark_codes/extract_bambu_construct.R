library(rtracklayer)
library(dplyr)
library(argparse)

parser <- ArgumentParser()
parser$add_argument("-i","--input",help="The directory for the gtf file.")
parser$add_argument("-t","--txt",help="The input txt file with target transcripts.")
args<-parser$parse_args()
DIR<-args$input
GTF<-paste0(DIR,"/extended_annotations.gtf")
gtf<-import(GTF)
gtf<-as.data.frame(gtf)
ID<-args$txt
trans<-read.table(ID,header=T)
ncol(trans)
head(trans$transcript)
gtf_out<-gtf%>%filter(transcript_id %in% trans$transcript)
OUT<-paste0(DIR,".construct.gtf")
export(gtf_out,OUT)



