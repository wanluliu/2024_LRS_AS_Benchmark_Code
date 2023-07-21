# 1. Differential isoform usage
# Import the required packages
library(IsoformSwitchAnalyzeR)
library(dplyr)

##plant
sg1<-read.table("FINE2a_stringtie.txt",sep = "\t",header = T)
sg1<-sg1[,c(1,7)]
sg2<-read.table("FINE2b_stringtie.txt",sep = "\t",header = T)
sg2<-sg2[,c(1,7)]
#sg3<-read.table("na_rep3Aligned.out.sam.bam.txt",sep = "\t",header = T)
#sg3<-sg3[,c(1,7)]
w1<-read.table("TesR7A_stringtie.txt",sep = "\t",header = T)
w1<-w1[,c(1,7)]
w2<-read.table("TesR7B_stringtie.txt",sep = "\t",header = T)
w2<-w2[,c(1,7)]
#w3<-read.table("pr_rep3Aligned.out.sam.bam.txt",sep = "\t",header = T)
#w3<-w3[,c(1,7)]
merge<-dplyr::full_join(sg1,sg2,by="Geneid")
#merge<-dplyr::full_join(merge,sg3,by="Geneid")
merge<-dplyr::full_join(merge,w1,by="Geneid")
merge<-dplyr::full_join(merge,w2,by="Geneid")
#merge<-dplyr::full_join(merge,w3,by="Geneid")
colnames(merge)<-c("isoform_id","FINE2a","FINE2b","TesR7A","TesR7B")
merge <- replace(merge, is.na(merge), 0)
#write.csv(merge,"./Mix_DIU_merge.csv")
sampleID<-c("FINE2a","FINE2b","TesR7A","TesR7B")
condition<-c("FINE","FINE","TesR","TesR")
designMatrix<-cbind(data.frame(sampleID),data.frame(condition))

### Create switchAnalyzeRlist
aSwitchList <- importRdata(
          isoformNtFasta = "stringtie_guide.fa",
          showProgress=FALSE,
          isoformCountMatrix=merge,
          designMatrix=designMatrix,
          isoformExonAnnoation="merge_stringtie_guide.gtf",
          ignoreAfterPeriod=FALSE #if using the reference gtf, then this should set TRUE.
      )        
       


#SwitchListFiltered <- preFilter(
 # switchAnalyzeRlist = aSwitchList,
  #geneExpressionCutoff = 5,
  #isoformExpressionCutoff = 5,
  #removeSingleIsoformGenes = TRUE)

SwitchListAnalyzed <- isoformSwitchTestDEXSeq(
  switchAnalyzeRlist = aSwitchList,
  reduceToSwitchingGenes=TRUE,
  reduceFurtherToGenesWithConsequencePotential = FALSE,
  alpha = 0.05,
  dIFcutoff = 0.1,
  onlySigIsoforms = FALSE
)
#switchListD<-isoformSwitchTestDEXSeq(switchAnalyzeRlist=SwitchListFiltered,alpha=0.05,dIFcutoff = 0.1)
switchListO <- analyzeORF(SwitchListAnalyzed,
                          showProgress = FALSE)
switchListS<-extractSequence(switchListO,
                             )
switchListsR<-analyzeAlternativeSplicing(switchListS,quiet = TRUE,onlySwitchingGenes=FALSE)
consequencesOfInterest <- c('intron_retention','NMD_status','ORF_seq_similarity')

exampleSwitchListAnalyzed <- analyzeSwitchConsequences(
  switchListsR,
  consequencesToAnalyze = consequencesOfInterest, 
  dIFcutoff = 0.1,
  alpha=0.05,
  showProgress=FALSE
)

#Consequence enrichment analysis (No use yet)
extractConsequenceEnrichment(
  exampleSwitchListAnalyzed,
  consequencesToAnalyze='all',
  analysisOppositeConsequence = TRUE,
  returnResult = FALSE # if TRUE returns a data.frame with the summary statistics
)
#Splicing Enrichment Analysis
extractSplicingEnrichment(
  exampleSwitchListAnalyzed,
  returnResult = FALSE # if TRUE returns a data.frame with the summary statistics
)
#Switch vs Gene changes (Not use yet)
ggplot(data=exampleSwitchListAnalyzed$isoformFeatures, aes(x=gene_log2_fold_change, y=dIF)) +
  geom_point(
    aes( color=abs(dIF) > 0.1 & isoform_switch_q_value < 0.05 ), # default cutoff
    size=1
  ) + geom_hline(yintercept = 0, linetype='dashed') +
  geom_vline(xintercept = 0, linetype='dashed') +
  scale_color_manual('Signficant\nIsoform Switch', values = c('black','red')) +
  labs(x='Gene log2 fold change', y='dIF') +
  theme_bw()
#Volcano plot (Not use yet)
ggplot(data=exampleSwitchListAnalyzed$isoformFeatures, aes(x=dIF, y=-log10(isoform_switch_q_value))) +
  geom_point(
    aes( color=abs(dIF) > 0.1 & isoform_switch_q_value < 0.05 ), # default cutoff
    size=1
  ) +
  geom_hline(yintercept = -log10(0.05), linetype='dashed') + # default cutoff
  geom_vline(xintercept = c(-0.1, 0.1), linetype='dashed') + # default cutoff+
  scale_color_manual('Signficant\nIsoform Switch', values = c('black','red')) +
  labs(x='dIF', y='-Log10 ( Isoform Switch Q Value )') +
  theme_bw()

#Isoform switch consequences
cons<-extractConsequenceSummary(
  exampleSwitchListAnalyzed,
  consequencesToAnalyze='all',
  plotGenes = FALSE,           # enables analysis of genes (instead of isoforms)
  asFractionTotal = FALSE, # enables analysis of fraction of significant features
  returnResult=TRUE
)
write.csv(cons,"stringtie_guide_hESC_switchCons.csv")
#SPlicing summary
splice_summary<-extractSplicingSummary(
  switchListsR,
  asFractionTotal = FALSE,
  plotGenes=FALSE,
  returnResult=TRUE
)
write.csv(splice_summary,"stringtie_guide_spliceSummary.csv")

##Obtain all switching genes
All_significant_DIU<-extractTopSwitches(
  exampleSwitchListAnalyzed, 
  filterForConsequences = TRUE, 
  n = NA, 
  extractGenes = FALSE,
  sortByQvals = TRUE
)
# Separate to up & down DIUs
primed_up<-All_significant_DIU[which(All_significant_DIU$dIF>0),]
primed_dw<-All_significant_DIU[which(All_significant_DIU$dIF<0),]
write.csv(primed_up,"stringtie_guide_PrimedUpDIUs.csv")

## Save the Rdata
save.image(file="stringtie_guide_DIU.RData")

### Plot DIU result ###
read_spliceSum<-function(s){
  name<-paste0(s,"_hESC_spliceSummary.csv")
  df<-read.csv(name,header=T)
  df$software<-s
  for (i in 1:nrow(df)){
    df$splicingResult<-as.character(df$splicingResult)
    as<-as.character(df$AStype[i])
    less<-paste0(as," in isoform used less")
    more<-paste0(as," in isoform used more")
    df[which(df$splicingResult==less),4]<-"less"
    df[which(df$splicingResult==more),4]<-"more"
  }
  df<-df[,-c(1,2,5)]
  df
}
fr<-read_spliceSum("freddie")
fu<-read_spliceSum("flair_unguide")
fg<-read_spliceSum("flair_guide")
su<-read_spliceSum("stringtie_unguide")
sg<-read_spliceSum("stringtie_guide")
bu<-read_spliceSum("bambu_unguide")
bg<-read_spliceSum("bambu_guide")
fl<-read_spliceSum("FLAMES")
ng<-read_spliceSum("NGS")
ta<-read_spliceSum("talon")
AS<-rbind(fr,fu,fg,su,sg,bu,fl,ta,bg,ng)
AS$software<-factor(AS$software,levels = c("NGS","talon","stringtie_unguide","stringtie_guide","freddie","FLAMES","flair_unguide","flair_guide","bambu_unguide","bambu_guide"))
write.csv(AS,"./spliceSummary.csv")
pdf("splicingSummary.pdf",height=6,width=10)
ggplot(AS,aes(x=software,y=ifelse(splicingResult=="more",nrIsoWithConsequences,-nrIsoWithConsequences),fill=AStype))+
  scale_fill_brewer(palette = "RdBu")+
  geom_bar(stat="identity",position="stack")+coord_flip()+scale_y_continuous(labels=abs)+theme_bw()+
  theme(panel.grid = element_blank())+ylab("Number of isoforms")
dev.off()
read_cons<-function(s){
  name<-paste0(s,"_hESC_switchCons.csv")
  df<-read.csv(name,header=T)
  df$software<-s
  df<-df[,c(4,6,7)]
  df
}
fr<-read_cons("freddie")
fu<-read_cons("flair_unguide")
fg<-read_cons("flair_guide")
su<-read_cons("stringtie_unguide")
sg<-read_cons("stringtie_guide")
bu<-read_cons("bambu_unguide")
bg<-read_cons("bambu_guide")
fl<-read_cons("FLAMES")
ng<-read_cons("NGS")
ta<-read_cons("talon")
consequence<-rbind(fr,fu,fg,su,sg,bu,fl,ng,ta,bg)
write.csv(consequence,"./consequence.csv")
consequence$software<-factor(consequence$software,levels = c("NGS","talon","stringtie_unguide","stringtie_guide","freddie","FLAMES","flair_unguide","flair_guide","bambu_unguide","bambu_guide"))
pdf("switchCons.pdf",height=6,width=8)
ggplot(consequence,aes(x=software,y=nrIsoWithConsequences,fill=switchConsequence))+scale_fill_brewer(palette = "RdBu",direction=-1)+
  geom_bar(stat="identity",position="stack")+theme_bw()+
  theme(panel.grid = element_blank())+ 
  theme(axis.text.x = element_text(angle=45, hjust=1, vjust=1))
dev.off()

### hESC DIU Upset Plot###

read_DIU<-function(s,dir){
  name<-paste0("hESC_",s,"_Primed",dir,"DIUs.csv")
  df<-read.csv(name,header = T)
  ds<-as.character(as.list(df)$gene_name)
  ds
}

#Up
sg<-read_DIU("stringtie_guide","Up")
su<-read_DIU("stringtie_unguide","Up")
fl<-read_DIU("FLAMES","Up")
ng<-read_DIU("NGS_stringtie","Up")
fg<-read_DIU("flair_guide","Up")
fu<-read_DIU("flair_unguide","Up")
bu<-read_DIU("bambu_unguide","Up")
bg<-read_DIU("bambu_guide","Up")
fr<-read_DIU("freddie","Up")
ta<-read_DIU("talon","Up")
venn_list<-list(stringtie_guided=sg,stringtie_unguided=su,FLAMES=fl,NGS=ng,talon=ta,
                flair_guided=fg,flair_unguided=fu,bambu_unguided=bu,freddie=fr,bambu_guide=bg)
library(UpSetR)
pdf("DIU_Primed_Up.pdf",height=7,width=11)
upset(fromList(venn_list),nsets = 9, nintersects = 25,order.by="freq")
dev.off()


##DIU simulation######
read_DIU_trans<-function(s,dir){
  name<-paste0(s,".noFil2_Primed",dir,"DIUs.csv")
  df<-read.csv(name,header = T)
  #ds<-as.character(as.list(df)$isoform_id)
  df
}

sg<-read_DIU_trans("stringtie_guide","Up")
su<-read_DIU_trans("stringtie_unguide","Up")
fl<-read_DIU_trans("FLAMES","Up")
tl<-read_DIU_trans("talon","Up")
fg<-read_DIU_trans("flair_guide","Up")
fu<-read_DIU_trans("flair_unguide","Up")
bu<-read_DIU_trans("bambu_unguide","Up")
bg<-read_DIU_trans("bambu_guide","Up")
fr<-read_DIU_trans("freddie","Up")
ref<-read_DIU_trans("salmon_GT","Up")
#venn_list<-list(stringtie_guided=sg,stringtie_unguided=su,FLAMES=fl,talon=ta,
                #flair_guided=fg,flair_unguided=fu,bambu_unguided=bu,tama=ta,ground_truth=ref)


##Get the adjusted dataframe ##
#Direction (Up/down) | Type (TP/FP) | iso_num | Software
df<-data.frame()
fill_df<-function(q,r,dir,soft,d){
  TP<-nrow(inner_join(q,r,by="isoform_id"))
  FP<-nrow(q)-TP
  FN<-nrow(r)-TP
  tmp_TP<-data.frame(dir,"TP",TP,soft)
  tmp_FP<-data.frame(dir,"FP",FP,soft)
  tmp_FN<-data.frame(dir,"FN",FN,soft)
  colnames(tmp_TP)<-c("Direction","Type","Number","Software")
  colnames(tmp_FP)<-c("Direction","Type","Number","Software")
  colnames(tmp_FN)<-c("Direction","Type","Number","Software")
  d<-rbind(d,tmp_TP,tmp_FP,tmp_FN)
}
df<-fill_df(sg,ref,"Up","stringtie_guide",df)
df<-fill_df(su,ref,"Up","stringtie_unguide",df)
df<-fill_df(fg,ref,"Up","flair_guide",df)
df<-fill_df(fu,ref,"Up","flair_unguide",df)
df<-fill_df(tl,ref,"Up","talon",df)
df<-fill_df(fr,ref,"Up","freddie",df)
df<-fill_df(fl,ref,"Up","FLAMES",df)
df<-fill_df(bu,ref,"Up","bambu_unguide",df)
df<-fill_df(bg,ref,"Up","bambu_guide",df)
write.csv(df,"DIU_simulation_compare_long.csv")

#Long to wide ##
library(tidyr)
library(reshape2)
df_w<-spread(df,key=Type,value = Number)
df_w$Precision<-df_w$TP/(df_w$TP+df_w$FP)
df_w$Sensitivity<-df_w$TP/(df_w$TP+df_w$FN)
write.csv(df_w,"DIU_simulation_compare_noGT.csv")
df_w<-df_w[,-c(3,4,5)]
df_w_l<-melt(df_w,id.vars = c("Direction","Software"),variable.name = "Type",value.name = "Value" )
df_w_l$Software<-factor(df_w_l$Software,levels = c("stringtie_guide","bambu_guide","flair_guide","bambu_unguide","stringtie_unguide","FLAMES","flair_unguide","talon","freddie"))
## Get the final data frame and draw figure ##
pdf("DIU_simulation_noGT.pdf",width=10,height=8)
pd <- position_dodge(0.1) # move them .05 to the left and right
ggplot(df_w_l,aes(x=Software,y=ifelse(Direction=="Up",Value,-Value),fill=Type))+
  #geom_line(aes(color=Direction),position=pd)+
  geom_bar(stat="identity",position="dodge")+coord_flip()+scale_y_continuous(limits = c(-1,1),labels=abs)+
  theme_bw()+ theme(panel.grid = element_blank(),axis.text.x = element_text(angle=90, hjust=1, vjust=.5))+
  ggtitle("Accuracy")+scale_fill_manual(values=c("#82B0D2","#FFBE7A"))+
  ylab("Value")+xlab("Software")
dev.off()


