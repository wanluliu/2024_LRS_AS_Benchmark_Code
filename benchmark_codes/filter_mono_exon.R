library(dplyr)
library(rtracklayer)
library(argparse)
parser <- ArgumentParser()
parser$add_argument("-i","--input",help="The input GTF file")
parser$add_argument("-o","--out",help="The output prefix")
args<-parser$parse_args()
GTF<-args$input
OUT<-args$out
gtf<-import(GTF)
gtf<-as.data.frame(gtf)
gtf_df<-gtf%>%count(gene_id,transcript_id,type, name="Exon_count") %>% filter(type=='exon' & Exon_count >1) %>% select(-type)
gtf_noSingle<-gtf%>%filter(transcript_id %in% gtf_df$transcript_id)
gtf_Single<-gtf%>%filter(!transcript_id %in% gtf_df$transcript_id)
out_nS<-paste0(OUT,"_noSingle.gtf")
out_S<-paste0(OUT,"_Single.gtf")
export(gtf_noSingle,out_nS)
export(gtf_Single,out_S)


