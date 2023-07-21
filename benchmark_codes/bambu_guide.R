library(bambu)
library(argparse)
parser <- ArgumentParser()
parser$add_argument("-b","--bam",help="The BAM file")
parser$add_argument("-g","--gtf",help="The input GTF file")
parser$add_argument("-f","--fasta",help="The input FASTA file")
parser$add_argument("-o","--output",help="The output path")
args<-parser$parse_args()
GTF<-args$gtf
ANNO<-prepareAnnotations(GTF)
FA<-args$fasta
BAM<-args$bam
OUT<-args$output
se<-bambu(reads=BAM,annotations=ANNO,genome=FA,opt.discovery = list(min.txScore.singleExon = 0),rcOutDir=".")
se_construct<-se[assays(se)$fullLengthCounts >0]
ID<-as.data.frame(rownames(se_construct))
colnames(ID)<-"transcript"
ID_dir<-paste0(OUT,".construct_ID.txt")
write.table(ID,ID_dir)
writeBambuOutput(se,path=OUT)
