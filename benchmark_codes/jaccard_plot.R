library(argparse)
library(corrplot)
parser <- ArgumentParser()
parser$add_argument("-i","--input",help="The input txt file")
parser$add_argument("-o","--output",help="The output file")
args<-parser$parse_args()
input<-args$input
out<-args$output
df<-read.table(input,sep="\t")
df1<-as.data.frame.matrix(xtabs(V3 ~ .,df))
diag(df1)<-1
res<-data.matrix(df1)
head(res)
pdf(out)
corrplot(res,method = "color",tl.cex=0.8,type="upper")
dev.off()
