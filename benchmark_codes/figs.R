library(dplyr)
library(ggplot2)

depth_raw<-read.csv("gffcmp_compl_r2.csv",header=T)
depth_raw$depth<-factor(depth_raw$depth,level=c("10","25","40","55","70"))
depth_raw$Iso_per_gene<-factor(depth_raw$Iso_per_gene,level=c("1","3","5","7","9"))
depth_raw$completeness<-factor(depth_raw$completeness,level=c("0.0_0.0","0.1_0.1","0.2_0.2","0.2_0.0","0.4_0.0","0.0_0.2","0.0_0.4"))
depth_raw$annotation<-factor(depth_raw$annotation,level=c("20","40","60","80","100"))
depth_raw$accuracy<-factor(depth_raw$accuracy,level=c("0.8","0.85","0.9","0.95","1"))

pdf("compl_precision.pdf",height=6,width=7)
ggplot(depth_raw,aes(x=completeness,y=precision,group=software))+
  geom_line(aes(color=software),position=pd)+
  geom_point(aes(color=software),position=pd)+scale_y_continuous(limits = c(0,100),breaks = seq(0,100,10)) +
  theme_bw()+ theme(panel.grid = element_blank(),axis.text.x = element_text(angle=90, hjust=1, vjust=.5))+
  ggtitle("Transcript precision under different completeness")+
  ylab("Transcript level precision %")+xlab("completeness")+facet_wrap(.~data)
dev.off()

pdf("compl_sensitivity.pdf",height=6,width=7)
ggplot(depth_raw,aes(x=depth,y=sensitivity,group=software))+
  geom_line(aes(color=software),position=pd)+
  geom_point(aes(color=software),position=pd)+scale_y_continuous(limits = c(0,100),breaks = seq(0,100,10)) +
  theme_bw()+ theme(panel.grid = element_blank(),axis.text.x = element_text(angle=90, hjust=1, vjust=.5))+
  ggtitle("Transcript sensitivity under different completeness")+
  ylab("Transcript level sensitivity %")+xlab("depth")+facet_wrap(.~data)
dev.off()

## Merge the results ##
library(dplyr)
library(RColorBrewer)
#color1<-c("#A1A9D0", "#F0988C", "#CFEAF1", "#C4A5DE", "#F6CAE5", "#96CCCB",
#          "#FFBE7A","#FA7F6F","#FA7F6F","#BEB8DC","#E7DAD2","#999999")
color1<-c(brewer.pal(9,"Set1")[-6],"light grey", "#9ac9db", "#f8ac8c","#ff8884")
#color2<-c("#A1A9D0", "#F0988C", "#CFEAF1", "#C4A5DE", "#F6CAE5", "#96CCCB")
color2<-brewer.pal(7,"Set1")[-6]
depth_raw1<-read.csv("gffcmp_acc_r1.csv",header=T)
depth_raw2<-read.csv("gffcmp_acc_r2.csv",header=T)
depth_raw3<-read.csv("gffcmp_acc_r3.csv",header=T)
df<-rbind(depth_raw1,depth_raw2,depth_raw3)
df$accuracy<-factor(df$accuracy,levels = c("0.8","0.85","0.9","0.95","1"))
df_m_s<-aggregate(x=df$sensitivity,by=list(df$software,df$completeness,df$data),mean)
df_m_p<-aggregate(x=df$precision,by=list(df$software,df$completeness,df$data),mean)
df_sd_s<-aggregate(x=df$sensitivity,by=list(df$software,df$completeness,df$data),sd)
df_sd_p<-aggregate(x=df$precision,by=list(df$software,df$completeness,df$data),sd)
df_final_s<-cbind(df_m_s,data.frame(df_sd_s[,4]))
colnames(df_final_s)<-c("software","completeness","data","mean_sensitivity","sd_sensitivity")
df_final_p<-cbind(df_m_p,data.frame(df_sd_p[,4]))
colnames(df_final_p)<-c("software","completeness","data","mean_precision","sd_precision")
df_final_p<-df_final_p%>%filter(!data %in% c("SEQUEL_CCS","RSII_CCS"))
df_final_s<-df_final_s%>%filter(!data %in% c("SEQUEL_CCS","RSII_CCS"))
write.csv(df_final_p,"final/stringtie_completeness_precision.csv")
write.csv(df_final_s,"final/stringtie_completeness_sensitivity.csv")

df_final_p<-read.csv("final/completeness_precision.csv",header=T)
df_final_p$depth<-factor(df_final_p$depth,levels = c("10","25","40","55","70"))
df_final_p$accuracy<-factor(df_final_p$accuracy,levels = c("0.8","0.85","0.9","0.95","1"))
df_final_s<-read.csv("final/completeness_sensitivity.csv",header=T)
df_final_s$depth<-factor(df_final_s$depth,levels = c("10","25","40","55","70"))
df_final_s$accuracy<-factor(df_final_s$accuracy,levels = c("0.8","0.85","0.9","0.95","1"))
df_final_s$completeness<-factor(df_final_s$completeness,levels = c("0.0_0.0","0.1_0.1","0.2_0.2","0.2_0.0","0.4_0.0","0.0_0.2","0.0_0.4"))
df_final_p$completeness<-factor(df_final_p$completeness,levels = c("0.0_0.0","0.1_0.1","0.2_0.2","0.2_0.0","0.4_0.0","0.0_0.2","0.0_0.4"))
df_final_s$type<-""
df_final_s[which(df_final_s$completeness%in%c("0.1_0.1","0.2_0.2")),]$type<-"both"
df_final_s[which(df_final_s$completeness%in%c("0.0_0.2","0.0_0.4")),]$type<-"3prime"
df_final_s[which(df_final_s$completeness%in%c("0.2_0.0","0.4_0.0")),]$type<-"5prime"
df_final_s[which(df_final_s$completeness%in%c("0.0_0.0")),]$type<-"complete"
df_final_p$type<-""
df_final_p[which(df_final_p$completeness%in%c("0.1_0.1","0.2_0.2")),]$type<-"both"
df_final_p[which(df_final_p$completeness%in%c("0.0_0.2","0.0_0.4")),]$type<-"3prime"
df_final_p[which(df_final_p$completeness%in%c("0.2_0.0","0.4_0.0")),]$type<-"5prime"
df_final_p[which(df_final_p$completeness%in%c("0.0_0.0")),]$type<-"complete"
df_final_p$type<-factor(df_final_p$type,levels = c("complete","both","5prime","3prime"))
df_final_s$type<-factor(df_final_s$type,levels = c("complete","both","5prime","3prime"))
R94_p<-df_final_p%>%filter(data %in% "R103")
R94_s<-df_final_s%>%filter(data %in% "R103")
pdf("final/R103_compl_precision.pdf",height = 3,width=9.5)
ggplot(R94_p, aes(x=completeness, y=mean_precision, group=software)) + 
  geom_errorbar(aes(ymin=mean_precision-sd_precision, ymax=mean_precision+sd_precision,color=software), width=.1, position=pd) + 
  geom_line(aes(color=software),position=pd) + scale_color_manual(values = color1)+
  geom_point(aes(color=software),position=pd)+scale_y_continuous(limits = c(0,100),breaks = seq(0,100,10)) +
  theme_bw()+ 
  theme(panel.grid = element_blank(),axis.text.x = element_text(angle=90, hjust=1, vjust=.5))+ggtitle("Mean transcript precision under different read completeness")+ylab("Mean transcript level precision %")+
  xlab("completeness")+facet_grid(.~type)
dev.off()
pdf("final/R103_compl_sensitivity.pdf",height = 3,width=9.5)
ggplot(R94_s, aes(x=completeness, y=mean_sensitivity, group=software)) + 
  geom_errorbar(aes(ymin=mean_sensitivity-sd_sensitivity, ymax=mean_sensitivity+sd_sensitivity,color=software), width=.1, position=pd) + 
  geom_line(aes(color=software),position=pd) + scale_color_manual(values = color1)+
  geom_point(aes(color=software),position=pd)+scale_y_continuous(limits = c(0,100),breaks = seq(0,100,10)) +
  theme_bw()+ 
  theme(panel.grid = element_blank(),axis.text.x = element_text(angle=90, hjust=1, vjust=.5))+ggtitle("Mean transcript sensitivity under different read completeness")+ylab("Mean transcript level sensitivity %")+
  xlab("completeness")+facet_grid(.~type)
dev.off()

pd <- position_dodge(0.1) # move them .05 to the left and right
pdf("final/accuracy_precision.pdf",height=6,width=7.5)
ggplot(df_final_p, aes(x=accuracy, y=mean_precision, group=software)) + 
  geom_errorbar(aes(ymin=mean_precision-sd_precision, ymax=mean_precision+sd_precision,color=software), width=.1, position=pd) + 
  geom_line(aes(color=software),position=pd) + scale_color_manual(values = color1)+
  geom_point(aes(color=software),position=pd)+scale_y_continuous(limits = c(0,100),breaks = seq(0,100,10)) +
  theme_bw()+ 
  theme(panel.grid = element_blank())+ggtitle("Mean transcript precision under different read accuracy")+ylab("Mean transcript level precision %")+
  xlab("accuracy")+facet_wrap(.~data)
dev.off()
pdf("final/accuracy_sensitivity.pdf",height=6,width=7.5)
ggplot(df_final_s, aes(x=accuracy, y=mean_sensitivity, group=software)) + 
  geom_errorbar(aes(ymin=mean_sensitivity-sd_sensitivity, ymax=mean_sensitivity+sd_sensitivity,color=software), width=.1, position=pd) + 
  geom_line(aes(color=software),position=pd) + scale_color_manual(values = color1)+
  geom_point(aes(color=software),position=pd)+scale_y_continuous(limits = c(0,100),breaks = seq(0,100,10)) +
  theme_bw()+ 
  theme(panel.grid = element_blank())+ggtitle("Mean transcript sensitivity under different read accuracy")+ylab("Mean transcript level sensitivity %")+
  xlab("accuracy")+facet_wrap(.~data)
dev.off()



###Simulated data QC###
library(dplyr)
library(arrow)
library(ggplot2)
color_AS<-c("#D271AC", "#FA7C9B", "#FF9285", "#FFB070", "#FFD466")
color_dep<-c("#71D288", "#009C93", "#0077B4", "#236375", "#2F4858")
color_compl<-c("#FBF8CC", "#FDE4CF", "#F1C0E8", "#CFBAF0", "#FFCFD2", "#A3C4F3", "#90DBF4")
color_acc<-c("#67B8DF", "#7A8BCB", "#8B71B3", "#985693", "#9B3B6B")
#1. Read length
df<-read_parquet("all_fastq_data_rlen.parquet",as_data_frame = T)
df<-data.frame(df[which(df$LEN<=5000),])
df$type<-""
df[which(df$Condition %in% c("as_2_isoform_depth_10_pbsim2_R103","as_2_isoform_depth_10_pbsim2_R94","as_2_isoform_depth_10_pbsim3_RSII_CLR",
                             "as_2_isoform_depth_10_pbsim3_RSII_CCS","as_2_isoform_depth_10_pbsim3_SEQUEL_CLR","as_2_isoform_depth_10_pbsim3_SEQUEL_CCS")),]$type<-"10"
df[which(df$Condition %in% c("as_2_isoform_depth_25_pbsim2_R103","as_2_isoform_depth_25_pbsim2_R94","as_2_isoform_depth_25_pbsim3_RSII_CLR",
                             "as_2_isoform_depth_25_pbsim3_RSII_CCS","as_2_isoform_depth_25_pbsim3_SEQUEL_CLR","as_2_isoform_depth_25_pbsim3_SEQUEL_CCS")),]$type<-"25"
df[which(df$Condition %in% c("as_2_isoform_depth_40_pbsim2_R103","as_2_isoform_depth_40_pbsim2_R94","as_2_isoform_depth_40_pbsim3_RSII_CLR",
                             "as_2_isoform_depth_40_pbsim3_RSII_CCS","as_2_isoform_depth_40_pbsim3_SEQUEL_CLR","as_2_isoform_depth_40_pbsim3_SEQUEL_CCS")),]$type<-"40"
df[which(df$Condition %in% c("as_2_isoform_depth_55_pbsim2_R103","as_2_isoform_depth_55_pbsim2_R94","as_2_isoform_depth_55_pbsim3_RSII_CLR",
                             "as_2_isoform_depth_55_pbsim3_RSII_CCS","as_2_isoform_depth_55_pbsim3_SEQUEL_CLR","as_2_isoform_depth_55_pbsim3_SEQUEL_CCS")),]$type<-"55"
df[which(df$Condition %in% c("as_2_isoform_depth_70_pbsim2_R103","as_2_isoform_depth_70_pbsim2_R94","as_2_isoform_depth_70_pbsim3_RSII_CLR",
                             "as_2_isoform_depth_70_pbsim3_RSII_CCS","as_2_isoform_depth_70_pbsim3_SEQUEL_CLR","as_2_isoform_depth_70_pbsim3_SEQUEL_CCS")),]$type<-"70"
df$type<-factor(df$type,levels=c("10","25","40","55","70"))

df[which(df$Condition %in% c("as_2_rcompl_0.0_0.2_pbsim2_R103","as_2_rcompl_0.0_0.2_pbsim2_R94","as_2_rcompl_0.0_0.2_pbsim3_RSII_CLR",
                             "as_2_rcompl_0.0_0.2_pbsim3_RSII_CCS","as_2_rcompl_0.0_0.2_pbsim3_SEQUEL_CLR","as_2_rcompl_0.0_0.2_pbsim3_SEQUEL_CCS")),]$type<-"20% cut from 3' side"
df[which(df$Condition %in% c("as_2_rcompl_0.0_0.4_pbsim2_R103","as_2_rcompl_0.0_0.4_pbsim2_R94","as_2_rcompl_0.0_0.4_pbsim3_RSII_CLR",
                             "as_2_rcompl_0.0_0.4_pbsim3_RSII_CCS","as_2_rcompl_0.0_0.4_pbsim3_SEQUEL_CLR","as_2_rcompl_0.0_0.4_pbsim3_SEQUEL_CCS")),]$type<-"40% cut from 3' side"
df[which(df$Condition %in% c("as_2_rcompl_0.0_0.0_pbsim2_R103","as_2_rcompl_0.0_0.0_pbsim2_R94","as_2_rcompl_0.0_0.0_pbsim3_RSII_CLR",
                             "as_2_rcompl_0.0_0.0_pbsim3_RSII_CCS","as_2_rcompl_0.0_0.0_pbsim3_SEQUEL_CLR","as_2_rcompl_0.0_0.0_pbsim3_SEQUEL_CCS")),]$type<-"100% complete"
df[which(df$Condition %in% c("as_2_rcompl_0.1_0.1_pbsim2_R103","as_2_rcompl_0.1_0.1_pbsim2_R94","as_2_rcompl_0.1_0.1_pbsim3_RSII_CLR",
                             "as_2_rcompl_0.1_0.1_pbsim3_RSII_CCS","as_2_rcompl_0.1_0.1_pbsim3_SEQUEL_CLR","as_2_rcompl_0.1_0.1_pbsim3_SEQUEL_CCS")),]$type<-"10% cut from both sides"
df[which(df$Condition %in% c("as_2_rcompl_0.2_0.2_pbsim2_R103","as_2_rcompl_0.2_0.2_pbsim2_R94","as_2_rcompl_0.2_0.2_pbsim3_RSII_CLR",
                             "as_2_rcompl_0.2_0.2_pbsim3_RSII_CCS","as_2_rcompl_0.2_0.2_pbsim3_SEQUEL_CLR","as_2_rcompl_0.2_0.2_pbsim3_SEQUEL_CCS")),]$type<-"20% cut from both sides"
df[which(df$Condition %in% c("as_2_rcompl_0.2_0.0_pbsim2_R103","as_2_rcompl_0.2_0.0_pbsim2_R94","as_2_rcompl_0.2_0.0_pbsim3_RSII_CLR",
                             "as_2_rcompl_0.2_0.0_pbsim3_RSII_CCS","as_2_rcompl_0.2_0.0_pbsim3_SEQUEL_CLR","as_2_rcompl_0.2_0.0_pbsim3_SEQUEL_CCS")),]$type<-"20% cut from 5' side"
df[which(df$Condition %in% c("as_2_rcompl_0.4_0.0_pbsim2_R103","as_2_rcompl_0.4_0.0_pbsim2_R94","as_2_rcompl_0.4_0.0_pbsim3_RSII_CLR",
                             "as_2_rcompl_0.4_0.0_pbsim3_RSII_CCS","as_2_rcompl_0.4_0.0_pbsim3_SEQUEL_CLR","as_2_rcompl_0.4_0.0_pbsim3_SEQUEL_CCS")),]$type<-"40% cut from 5' side"
df$type<-factor(df$type,levels=c("100% complete","20% cut from 3' side","20% cut from 5' side","10% cut from both sides","40% cut from 3' side","40% cut from 5' side","20% cut from both sides"))

df[which(df$Condition %in% c("as_2_accu_0.80_pbsim2_R103","as_2_accu_0.80_pbsim2_R94","as_2_accu_0.80_pbsim3_RSII_CLR",
                             "as_2_accu_0.80_pbsim3_RSII_CCS","as_2_accu_0.80_pbsim3_SEQUEL_CLR","as_2_accu_0.80_pbsim3_SEQUEL_CCS")),]$type<-"0.80"
df[which(df$Condition %in% c("as_2_accu_0.85_pbsim2_R103","as_2_accu_0.85_pbsim2_R94","as_2_accu_0.85_pbsim3_RSII_CLR",
                             "as_2_accu_0.85_pbsim3_RSII_CCS","as_2_accu_0.85_pbsim3_SEQUEL_CLR","as_2_accu_0.85_pbsim3_SEQUEL_CCS")),]$type<-"0.85"
df[which(df$Condition %in% c("as_2_accu_0.90_pbsim2_R103","as_2_accu_0.90_pbsim2_R94","as_2_accu_0.90_pbsim3_RSII_CLR",
                             "as_2_accu_0.90_pbsim3_RSII_CCS","as_2_accu_0.90_pbsim3_SEQUEL_CLR","as_2_accu_0.90_pbsim3_SEQUEL_CCS")),]$type<-"0.90"
df[which(df$Condition %in% c("as_2_accu_0.95_pbsim2_R103","as_2_accu_0.95_pbsim2_R94","as_2_accu_0.95_pbsim3_RSII_CLR",
                             "as_2_accu_0.95_pbsim3_RSII_CCS","as_2_accu_0.95_pbsim3_SEQUEL_CLR","as_2_accu_0.95_pbsim3_SEQUEL_CCS")),]$type<-"0.95"
df[which(df$Condition %in% c("as_2_accu_1.00_pbsim2_R103","as_2_accu_1.00_pbsim2_R94","as_2_accu_1.00_pbsim3_RSII_CLR",
                             "as_2_accu_1.00_pbsim3_RSII_CCS","as_2_accu_1.00_pbsim3_SEQUEL_CLR","as_2_accu_1.00_pbsim3_SEQUEL_CCS")),]$type<-"1.00"
df$type<-factor(df$type,levels=c("0.80","0.85","0.90","0.95","1.00"))

df[which(df$Condition %in% c("as_1_pbsim2_R103","as_1_pbsim2_R94","as_1_pbsim3_RSII_CLR",
                             "as_1_pbsim3_RSII_CCS","as_1_pbsim3_SEQUEL_CLR","as_1_pbsim3_SEQUEL_CCS")),]$type<-"1"
df[which(df$Condition %in% c("as_3_pbsim2_R103","as_3_pbsim2_R94","as_3_pbsim3_RSII_CLR",
                             "as_3_pbsim3_RSII_CCS","as_3_pbsim3_SEQUEL_CLR","as_3_pbsim3_SEQUEL_CCS")),]$type<-"3"
df[which(df$Condition %in% c("as_5_pbsim2_R103","as_5_pbsim2_R94","as_5_pbsim3_RSII_CLR",
                             "as_5_pbsim3_RSII_CCS","as_5_pbsim3_SEQUEL_CLR","as_5_pbsim3_SEQUEL_CCS")),]$type<-"5"
df[which(df$Condition %in% c("as_7_pbsim2_R103","as_7_pbsim2_R94","as_7_pbsim3_RSII_CLR",
                             "as_7_pbsim3_RSII_CCS","as_7_pbsim3_SEQUEL_CLR","as_7_pbsim3_SEQUEL_CCS")),]$type<-"7"
df[which(df$Condition %in% c("as_9_pbsim2_R103","as_9_pbsim2_R94","as_9_pbsim3_RSII_CLR",
                             "as_9_pbsim3_RSII_CCS","as_9_pbsim3_SEQUEL_CLR","as_9_pbsim3_SEQUEL_CCS")),]$type<-"9"
df$type<-factor(df$type,levels=c("1","3","5","7","9"))

pdf("diff_compl_lengthQC.pdf",height=4.5,width = 11)
ggplot(df)+geom_violin(aes(x=Condition,y=LEN,fill=type))+scale_fill_manual(values = color_compl)+
  scale_y_continuous(breaks = c(0,1000,2000,3000,4000,5000))+
  theme_bw()+theme(panel.grid = element_blank(),axis.text.x = element_text(angle=90, hjust=1, vjust=.5))
dev.off()

#2. read completeness
library(ggridges)
df<-read_parquet("all_fastq_data_sampled.parquet",as_data_frame=T)
df$type<-""
df[which(df$Condition %in% c("as_2_rcompl_0.0_0.2_pbsim2_R103","as_2_rcompl_0.0_0.2_pbsim2_R94","as_2_rcompl_0.0_0.2_pbsim3_RSII_CLR",
                             "as_2_rcompl_0.0_0.2_pbsim3_RSII_CCS","as_2_rcompl_0.0_0.2_pbsim3_SEQUEL_CLR","as_2_rcompl_0.0_0.2_pbsim3_SEQUEL_CCS")),]$type<-"20% cut from 3' side"
df[which(df$Condition %in% c("as_2_rcompl_0.0_0.4_pbsim2_R103","as_2_rcompl_0.0_0.4_pbsim2_R94","as_2_rcompl_0.0_0.4_pbsim3_RSII_CLR",
                             "as_2_rcompl_0.0_0.4_pbsim3_RSII_CCS","as_2_rcompl_0.0_0.4_pbsim3_SEQUEL_CLR","as_2_rcompl_0.0_0.4_pbsim3_SEQUEL_CCS")),]$type<-"40% cut from 3' side"
df[which(df$Condition %in% c("as_2_rcompl_0.0_0.0_pbsim2_R103","as_2_rcompl_0.0_0.0_pbsim2_R94","as_2_rcompl_0.0_0.0_pbsim3_RSII_CLR",
                             "as_2_rcompl_0.0_0.0_pbsim3_RSII_CCS","as_2_rcompl_0.0_0.0_pbsim3_SEQUEL_CLR","as_2_rcompl_0.0_0.0_pbsim3_SEQUEL_CCS")),]$type<-"100% complete"
df[which(df$Condition %in% c("as_2_rcompl_0.1_0.1_pbsim2_R103","as_2_rcompl_0.1_0.1_pbsim2_R94","as_2_rcompl_0.1_0.1_pbsim3_RSII_CLR",
                             "as_2_rcompl_0.1_0.1_pbsim3_RSII_CCS","as_2_rcompl_0.1_0.1_pbsim3_SEQUEL_CLR","as_2_rcompl_0.1_0.1_pbsim3_SEQUEL_CCS")),]$type<-"10% cut from both sides"
df[which(df$Condition %in% c("as_2_rcompl_0.2_0.2_pbsim2_R103","as_2_rcompl_0.2_0.2_pbsim2_R94","as_2_rcompl_0.2_0.2_pbsim3_RSII_CLR",
                             "as_2_rcompl_0.2_0.2_pbsim3_RSII_CCS","as_2_rcompl_0.2_0.2_pbsim3_SEQUEL_CLR","as_2_rcompl_0.2_0.2_pbsim3_SEQUEL_CCS")),]$type<-"20% cut from both sides"
df[which(df$Condition %in% c("as_2_rcompl_0.2_0.0_pbsim2_R103","as_2_rcompl_0.2_0.0_pbsim2_R94","as_2_rcompl_0.2_0.0_pbsim3_RSII_CLR",
                             "as_2_rcompl_0.2_0.0_pbsim3_RSII_CCS","as_2_rcompl_0.2_0.0_pbsim3_SEQUEL_CLR","as_2_rcompl_0.2_0.0_pbsim3_SEQUEL_CCS")),]$type<-"20% cut from 5' side"
df[which(df$Condition %in% c("as_2_rcompl_0.4_0.0_pbsim2_R103","as_2_rcompl_0.4_0.0_pbsim2_R94","as_2_rcompl_0.4_0.0_pbsim3_RSII_CLR",
                             "as_2_rcompl_0.4_0.0_pbsim3_RSII_CCS","as_2_rcompl_0.4_0.0_pbsim3_SEQUEL_CLR","as_2_rcompl_0.4_0.0_pbsim3_SEQUEL_CCS")),]$type<-"40% cut from 5' side"
df$type<-factor(df$type,levels=c("100% complete","20% cut from 3' side","20% cut from 5' side","10% cut from both sides","40% cut from 3' side","40% cut from 5' side","20% cut from both sides"))

colors<-c("#8ECFC9","#FFBE7A","#FA7F6F","#82B0D2","#BEB8DC","#E7DAD2","#999999")
g <- ggplot(df) +
  geom_density_ridges_gradient(
    aes(
      x = READ_COMPLETENESS,
      y = Condition,
      fill = type
    )
  ) +
  scale_fill_manual(values = colors)+
  xlim(c(0, 1.5)) +
  ylab("density") +
  theme_ridges() +
  ggtitle("Read completeness of all conditions")
ggsave("diff_compl_QC.pdf", g, width = 12, height = 10)

#3. depth
df<-read.csv("diff_depth_QC.csv",header=T)
df$type<-""
df[which(df$Condition %in% c("10_pbsim2_R103","10_pbsim2_R94","10_pbsim3_RSII_CLR",
                             "10_pbsim3_RSII_CCS","10_pbsim3_SEQUEL_CLR","10_pbsim3_SEQUEL_CCS")),]$type<-"10"
df[which(df$Condition %in% c("25_pbsim2_R103","25_pbsim2_R94","25_pbsim3_RSII_CLR",
                             "25_pbsim3_RSII_CCS","25_pbsim3_SEQUEL_CLR","25_pbsim3_SEQUEL_CCS")),]$type<-"25"
df[which(df$Condition %in% c("40_pbsim2_R103","40_pbsim2_R94","40_pbsim3_RSII_CLR",
                             "40_pbsim3_RSII_CCS","40_pbsim3_SEQUEL_CLR","40_pbsim3_SEQUEL_CCS")),]$type<-"40"
df[which(df$Condition %in% c("55_pbsim2_R103","55_pbsim2_R94","55_pbsim3_RSII_CLR",
                             "55_pbsim3_RSII_CCS","55_pbsim3_SEQUEL_CLR","55_pbsim3_SEQUEL_CCS")),]$type<-"55"
df[which(df$Condition %in% c("70_pbsim2_R103","70_pbsim2_R94","70_pbsim3_RSII_CLR",
                             "70_pbsim3_RSII_CCS","70_pbsim3_SEQUEL_CLR","70_pbsim3_SEQUEL_CCS")),]$type<-"70"
df$type<-factor(df$type,levels=c("10","25","40","55","70"))

colors<-c("#2878b5","#9ac9db","#f8ac8c","#c82423","#ff8884")
g <- ggplot(df)+
  geom_bar(
    aes(
      y = Condition,
      x = MEAN_SIMULATED_DEPTH,
      fill = type
    ),
    #position = "fill",
    stat = "identity"
  ) +
  theme_bw() +scale_fill_manual(values=colors)+
  ggtitle("Depth QC")
ggsave("diff_depth_QC.pdf", g, width = 6, height = 5.5)

#4. Error rate
library("tidyverse")
colors<-c("#8ECFC9","#FFBE7A","#FA7F6F","#82B0D2")

all_error <- readr::read_tsv(
  "all_last_mapq.tsv",
  col_types = c(
    FILENAME = col_character(),
    INSERTION = col_double(),
    DELETION = col_double(),
    MATCH = col_double(),
    SUBSTITUTION = col_double()
  )
) %>%
  dplyr::mutate(
    FILENAME = stringr::str_replace(FILENAME, "ce11_as_2_accu_", "")
  ) %>%
  dplyr::mutate(
    FILENAME = stringr::str_replace(FILENAME, ".maf.gz", "")
  ) %>%
  tidyr::gather(
    key = "EventType",
    value = "EventCount",
    -FILENAME
  ) %>%
  dplyr::mutate(
    EventType = factor(EventType, levels = c("DELETION", "INSERTION", "SUBSTITUTION", "MATCH"))
  )

g <- ggplot(all_error) +
  geom_bar(
    aes(
      y = FILENAME,
      x = EventCount,
      fill = EventType
    ),
    position = "fill",
    stat = "identity"
  ) +
  theme_bw() +scale_fill_manual(values=colors)+
  scale_x_continuous("Event Frequency") +
  scale_y_discrete("Data Spec") +
  scale_color_manual("Event Type") +
  ggtitle("Error Rate Generated by MAF from LLRGs")
ggsave("maf_error_rate.pdf", g, width = 7, height = 5)

#5. Reference annotation

Ref<-read.csv("diff_anno_QC.CSV",header=T)
pdf("diff_anno_QC.pdf",width = 6, height = 5)
ggplot(data=Ref)+geom_bar(aes(x=Simulated_percent,y=Data,fill=factor(Target)),stat = "identity")+
  scale_fill_manual(values=colors)+xlab("Target percent")+
  ylab("Real percent")+theme_bw()
dev.off()


### Figure3 hierachical clustering ###
library(eclust)
result_raw<-read.csv("sqanti_multi.csv",header=T)
transform<-function(df,sub_data){
  df_sub<-df%>%filter(Dataset %in% sub_data)
  FSM<-paste0("FSM_",sub_data)
  ISM<-paste0("ISM_",sub_data)
  NIC<-paste0("NIC_",sub_data)
  NNC<-paste0("NNC_",sub_data)
  Intergenic<-paste0("Intergenic_",sub_data)
  df_sub<-df_sub[,-c(2)]
  colnames(df_sub)<-c("Software",FSM,ISM,NIC,NNC,Intergenic)
  df_sub
}
datalist<-as.character(unique(result_raw$Dataset))
result<-data.frame(Software=c("freddie","FLAMES","stringtie_guide","stringtie_unguide","bambu_unguide","talon","flair_guide","flair_unguide","bambu_guide"))
for(i in datalist){
  df<-transform(result_raw,i)
  result<-merge(result,df,by="Software")
}
rownames(result)<-result[,1]
result<-result[,-1]
write.csv(result,"sqanti_multi_cluster.csv")
df<-scale(result)
hc = hclust(dist(df),"ave")
plot(hc,hang = -1)



### Figure 6AB Computational performance ###
cp_result<-read.csv("computational_peoform_table.csv",header=T)
pd <- position_dodge(0.1) # move them .05 to the left and right
pdf("memory_noTAMA.pdf",height=5,width=7.2)
ggplot(cp_result_noTAMA, aes(x=DATA_SIZE, y=MEAN_RESIDENT, group=SOFT)) + 
  #geom_errorbar(aes(ymin=mean_precision-sd_precision, ymax=mean_precision+sd_precision,color=software), width=.1, position=pd) 
  geom_line(aes(color=SOFT),position=pd) +
  geom_point(aes(color=SOFT),position=pd)+scale_color_brewer(palette = "RdBu",direction=-1)+#scale_y_continuous(limits = c(0,100),breaks = seq(0,100,10)) +
  theme_bw()+ 
  theme(panel.grid = element_blank())+ylab("Mean resident memory")+
  xlab("Data size")
dev.off()
cp_result_noTAMA<-mutate(cp_result,MEAN_RESIDENT = MEAN_RESIDENT / (1024*1024*1024))%>% filter(MEAN_RESIDENT<=25)
cp_result_tama<-mutate(cp_result,MEAN_RESIDENT = MEAN_RESIDENT / (1024*1024*1024))%>% filter(MEAN_RESIDENT>25)

##Scalability Time
cp_result_noTAMA_time<-mutate(cp_result,CLOCK_TIME = CLOCK_TIME / 3600)%>% filter(CLOCK_TIME<=5)
cp_result_TAMA_time<-mutate(cp_result,CLOCK_TIME = CLOCK_TIME / 3600)%>% filter(CLOCK_TIME>5)

cp_result_noTAMA_time$SOFT<-factor(cp_result_noTAMA_time$SOFT,levels=c("bambu_guide","bambu_unguide","flair",
                                                                       "flair_unguide","FLAMES","tama","freddie","stringtie",
                                                                       "stringtie_unguide","talon","unagi"))
pd <- position_dodge(0.1) # move them .05 to the left and right
pdf("time_noTAMA.pdf",height=5,width=7.2)
ggplot(cp_result_noTAMA_time, aes(x=DATA_SIZE, y=CLOCK_TIME, group=SOFT)) + 
  #geom_errorbar(aes(ymin=mean_precision-sd_precision, ymax=mean_precision+sd_precision,color=software), width=.1, position=pd) 
  geom_line(aes(color=SOFT),position=pd) +
  geom_point(aes(color=SOFT),position=pd)+scale_color_brewer(palette = "RdBu",direction=-1)+#scale_y_continuous(limits = c(0,100),breaks = seq(0,100,10)) +
  theme_bw()+ 
  theme(panel.grid = element_blank())+ylab("Mean time")+
  xlab("Data size")
dev.off()
