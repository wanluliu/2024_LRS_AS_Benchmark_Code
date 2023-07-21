library(bambu)
library(argparse)
parser <- ArgumentParser()
parser$add_argument("-b","--bam",help="The BAM file")
#parser$add_argument("-g","--gtf",help="The input GTF file")
parser$add_argument("-f","--fasta",help="The input FASTA file")
parser$add_argument("-o","--output",help="The output path of NDR=1")
args<-parser$parse_args()
#GTF<-args$gtf
#ANNO<-prepareAnnotations(GTF)
FA<-args$fasta
BAM<-args$bam
OUT<-args$output
se<-bambu(reads=BAM,annotation = NULL,genome=FA,NDR=1,opt.discovery = list(min.txScore.singleExon = 0))
writeBambuOutput(se,path=OUT)
