read_file_merge <- function(s) {
    data <- read.csv(paste0(s, "_mean_sd.csv"), header = T)
    data <- data[, -1]
    data
}

#Isoform per gene
setwd("D:/LabW/benchmark_results/raw_AS_size/transcript/transcript_no_ccs")
flair_rep <- read_file_merge("flair")
stringtie_rep <- read_file_merge("stringtie")
FLAMES_rep <- read_file_merge("FLAMES")
talon_rep <- read_file_merge("talon")
tama_rep <- read_file_merge("tama")
unagi_rep <- read_file_merge("unagi")
freddie_rep <- read_file_merge("freddie")
stringtie_unguide_rep <- read_file_merge("stringtie_unguide")
flair_unguide_rep <- read_file_merge("flair_unguide")
merge_depth <- rbind(stringtie_rep, flair_rep, FLAMES_rep, talon_rep, tama_rep, stringtie_unguide_rep, flair_unguide_rep, freddie_rep, unagi_rep)
merge_depth$Iso_per_gene <- factor(merge_depth$Iso_per_gene, levels = c("1", "3", "5", "7", "9"))
for (i in c("talon", "stringtie", "flair", "FLAMES")) {
    merge_depth[which(merge_depth$software == i), 7] <- "guided"
}
for (i in c("stringtie_unguide", "flair_unguide", "freddie", "tama", "unagi")) {
    merge_depth[which(merge_depth$software == i), 7] <- "unguided"
}
colnames(merge_depth)[7] <- "type"
write.csv(merge_depth, "./merged_AS.csv")
##make sensitivity & precison plotss
pd <- position_dodge(0.1) # move them .05 to the left and right
ggplot(merge_depth, aes(x = Iso_per_gene, y = mean_precision, group = software)) +
    geom_errorbar(aes(ymin = mean_precision - sd_precision, ymax = mean_precision + sd_precision, color = software), width = .1, position = pd) +
    geom_line(aes(color = software), position = pd) +
    geom_point(aes(color = software), position = pd) +
    scale_color_brewer(palette = "RdBu") +
    scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 10)) +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    ggtitle("Mean transcript precision under different AS sizes") +
    ylab("Mean transcript level precision %") +
    xlab("Isoform per gene") +
    facet_grid(. ~ type)
ggplot(merge_depth, aes(x = Iso_per_gene, y = mean_sensitivity, group = software)) +
    geom_errorbar(aes(ymin = mean_sensitivity - sd_sensitivity, ymax = mean_sensitivity + sd_sensitivity, color = software), width = .1, position = pd) +
    geom_line(aes(color = software), position = pd) +
    geom_point(aes(color = software), position = pd) +
    scale_color_brewer(palette = "RdBu") +
    scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 10)) +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    ggtitle("Mean transcript sensitivity under different AS sizes") +
    ylab("Mean transcript level sensitivity %") +
    xlab("Isoform per gene") +
    facet_grid(. ~ type)

# Depth
setwd("D:/LabW/benchmark_results/raw_depth/transcript/transcript_no_ccs")
flair_rep <- read_file_merge("flair")
stringtie_rep <- read_file_merge("stringtie")
FLAMES_rep <- read_file_merge("FLAMES")
talon_rep <- read_file_merge("talon")
tama_rep <- read_file_merge("tama")
unagi_rep <- read_file_merge("unagi")
freddie_rep <- read_file_merge("freddie")
stringtie_unguide_rep <- read_file_merge("stringtie_unguide")
flair_unguide_rep <- read_file_merge("flair_unguide")
merge_depth <- rbind(stringtie_rep, flair_rep, FLAMES_rep, talon_rep, tama_rep, stringtie_unguide_rep, flair_unguide_rep, freddie_rep, unagi_rep)
merge_depth$depth <- factor(merge_depth$depth, levels = c("20", "40", "60", "80", "100"))
for (i in c("talon", "stringtie", "flair", "FLAMES")) {
    merge_depth[which(merge_depth$software == i), 7] <- "guided"
}
for (i in c("stringtie_unguide", "flair_unguide", "freddie", "tama", "unagi")) {
    merge_depth[which(merge_depth$software == i), 7] <- "unguided"
}
colnames(merge_depth)[7] <- "type"
write.csv(merge_depth, "./merged_depth.csv")
##make sensitivity & precison plotss
pd <- position_dodge(0.1) # move them .05 to the left and right
ggplot(merge_depth, aes(x = depth, y = mean_precision, group = software)) +
    geom_errorbar(aes(ymin = mean_precision - sd_precision, ymax = mean_precision + sd_precision, color = software), width = .1, position = pd) +
    geom_line(aes(color = software), position = pd) +
    geom_point(aes(color = software), position = pd) +
    scale_color_brewer(palette = "RdBu") +
    scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 10)) +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    ggtitle("Mean transcript precision under different read depths") +
    ylab("Mean transcript level precision %") +
    xlab("Read depths") +
    facet_grid(. ~ type)
ggplot(merge_depth, aes(x = depth, y = mean_sensitivity, group = software)) +
    geom_errorbar(aes(ymin = mean_sensitivity - sd_sensitivity, ymax = mean_sensitivity + sd_sensitivity, color = software), width = .1, position = pd) +
    geom_line(aes(color = software), position = pd) +
    geom_point(aes(color = software), position = pd) +
    scale_color_brewer(palette = "RdBu") +
    scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 10)) +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    ggtitle("Mean transcript sensitivity under different read depths") +
    ylab("Mean transcript level sensitivity %") +
    xlab("Read depths") +
    facet_grid(. ~ type)

#Annotation
setwd("D:/LabW/benchmark_results/raw_anno/transcript/transcript_no_ccs")
flair_rep <- read_file_merge("flair")
stringtie_rep <- read_file_merge("stringtie")
FLAMES_rep <- read_file_merge("FLAMES")
talon_rep <- read_file_merge("talon")
merge_depth <- rbind(stringtie_rep, flair_rep, FLAMES_rep, talon_rep)
merge_depth$guidance <- factor(merge_depth$guidance, levels = c("20", "40", "60", "80", "100"))
write.csv(merge_depth, "./merged_anno.csv")
##make sensitivity & precison plots
pd <- position_dodge(0.1) # move them .05 to the left and right
ggplot(merge_depth, aes(x = guidance, y = mean_precision, group = software)) +
    geom_errorbar(aes(ymin = mean_precision - sd_precision, ymax = mean_precision + sd_precision, color = software), width = .1, position = pd) +
    geom_line(aes(color = software), position = pd) +
    geom_point(aes(color = software), position = pd) +
    scale_color_brewer(palette = "Reds", direction = -1) +
    scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 10)) +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    ggtitle("Mean transcript precision under different annotation quality") +
    ylab("Mean transcript level precision %") +
    xlab("Annotation quality")
ggplot(merge_depth, aes(x = guidance, y = mean_sensitivity, group = software)) +
    geom_errorbar(aes(ymin = mean_sensitivity - sd_sensitivity, ymax = mean_sensitivity + sd_sensitivity, color = software), width = .1, position = pd) +
    geom_line(aes(color = software), position = pd) +
    geom_point(aes(color = software), position = pd) +
    scale_color_brewer(palette = "Reds", direction = -1) +
    scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 10)) +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    ggtitle("Mean transcript sensitivity under different annotation quality") +
    ylab("Mean transcript level sensitivity %") +
    xlab("Annotation quality")

##FLAMES support read = 10
setwd("D:/LabW/benchmark_results/raw_depth/transcript/transcript_no_ccs")
FLAMES_d <- read.csv("FLAMES_old_mean_sd.csv")
FLAMES_d_s <- FLAMES_d[, c(2, 3, 4, 5)]
FLAMES_d_p <- FLAMES_d[, c(2, 3, 6, 7)]
ggplot(FLAMES_d_s, aes(x = factor(depth), y = mean_sensitivity, group = software)) +
    geom_errorbar(aes(ymin = mean_sensitivity - sd_sensitivity, ymax = mean_sensitivity + sd_sensitivity), width = .1, color = "#CC3333") +
    geom_line(color = "#CC3333") +
    geom_point(color = "#CC3333") +
    scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 10)) +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    xlab("Read depth") +
    ylab("Mean transcript level sensitivity %")
ggplot(FLAMES_d_p, aes(x = factor(depth), y = mean_precision, group = software)) +
    geom_errorbar(aes(ymin = mean_precision - sd_precision, ymax = mean_precision + sd_precision), width = .1, color = "#0099FF") +
    geom_line(color = "#0099FF") +
    geom_point(color = "#0099FF") +
    scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 10)) +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    xlab("Read depth") +
    ylab("Mean transcript level precision %")


#Jaccard plot
library(corrplot)
setwd("D:/LabW/benchmark_results/jaccard")
res <- read.csv("./drosophila/pacbio_testis.csv")
res <- res[, -1]
rownames(res) <- c("stringtie2", "FLAMES", "flair", "talon", "freddie", "stringtie2_unguided", "flair_unguide")
res <- data.matrix(res)
#corrplot(res,method = "color",addCoef.col = "dark grey")
corrplot(res, method = "color", addCoef.col = "dark grey", tl.cex = 0.8, type = "upper")


#SQANTI result visualization
library(reshape2)
library(ggplot2)
library(dplyr)
result <- read.csv("D:/LabW/benchmark_results/SQANTI/result.csv", header = T)

result_long <- melt(result, id.vars = c("Software", "Dataset"),
                    variable.name = "Isoform_type",
                    value.name = "Number")
color1 <- c("#B2182B", "#F4A582", "#9E9AC8", "#92C5DE", "#2166AC")
result_long_p <- as.data.frame(filter(result_long, Dataset %in% c("human_Hela")) %>%
                                   group_by(Software) %>%
                                   mutate(Percent = Number / sum(Number)))
result_long_p[, 5] <- result_long_p[, 5] * 100
bar <- ggplot() +
    geom_bar(data = result_long_p,
             aes(x = "", y = Percent, fill = Isoform_type), stat = "identity", position = "stack") +
    facet_grid(. ~ Software) +
    scale_fill_manual(values = color1) +
    theme_void()
pie <- bar + coord_polar("y", start = 0)
pie


result_long_addAll <- as.data.frame(filter(result_long, Dataset %in% c("human_ctrl", "human_control")) %>%
                                        group_by(Software) %>%
                                        mutate(All = sum(Number)))
result_long_addAll <- mutate(result_long_addAll, Percent = All / max(All))
write.csv(result_long_addAll, "C:/Users/suyaqi/Desktop/human_control_pie.csv")


# hierachical clustering
library(eclust)
result <- read.csv("C:/Users/suyaqi/Desktop/sqanti_cluster.csv", header = T)
rownames(result) <- result[, 1]
result <- result[, -1]
df <- scale(result)
hc = hclust(dist(df), "ave")
plot(hc, hang = -1)


# Computational performance
cp_result <- read.csvpd <- position_dodge(0.1) # move them .05 to the left and right
ggplot(cp_result_noTAMA, aes(x = DATA_SIZE, y = MEAN_RESIDENT, group = SOFT)) +
    #geom_errorbar(aes(ymin=mean_precision-sd_precision, ymax=mean_precision+sd_precision,color=software), width=.1, position=pd)
    geom_line(aes(color = SOFT), position = pd) +
    geom_point(aes(color = SOFT), position = pd) +
    scale_color_brewer(palette = "RdBu", direction = -1) + #scale_y_continuous(limits = c(0,100),breaks = seq(0,100,10)) +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    ylab("Mean resident memory") +
    xlab("Data size")("D:/LabW/benchmark_results/computational_peoform_table.csv", header = T)
cp_result_noTAMA <- mutate(cp_result, MEAN_RESIDENT = MEAN_RESIDENT / (1024 * 1024 * 1024)) %>% filter(MEAN_RESIDENT <= 25)
cp_result_tama <- mutate(cp_result, MEAN_RESIDENT = MEAN_RESIDENT / (1024 * 1024 * 1024)) %>% filter(MEAN_RESIDENT > 25)

##Scalability Time
cp_result_noTAMA_time <- mutate(cp_result, CLOCK_TIME = CLOCK_TIME / 3600) %>% filter(CLOCK_TIME <= 5)
cp_result_TAMA_time <- mutate(cp_result, CLOCK_TIME = CLOCK_TIME / 3600) %>% filter(CLOCK_TIME > 2)
pd <- position_dodge(0.1) # move them .05 to the left and right
ggplot(cp_result_noTAMA_time, aes(x = DATA_SIZE, y = CLOCK_TIME, group = SOFT)) +
    #geom_errorbar(aes(ymin=mean_precision-sd_precision, ymax=mean_precision+sd_precision,color=software), width=.1, position=pd)
    geom_line(aes(color = SOFT), position = pd) +
    geom_point(aes(color = SOFT), position = pd) +
    scale_color_brewer(palette = "RdBu", direction = -1) + #scale_y_continuous(limits = c(0,100),breaks = seq(0,100,10)) +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    ylab("Mean time") +
    xlab("Data size")

# Quality Control
# 1. Depths
depths <- read.csv("C:/Users/suyaqi/Desktop/merged.csv", header = T)
#ggplot(data = depths)+geom_boxplot(aes(x=factor(TARGET_DEPTH),y=SIMULATED_N_OF_READS,
#                                     color=ERR_MODEL))+
#scale_y_continuous(breaks = c(0,20,40,60,80,100,120),limits = c(0,300))
get_mean <- function(depth, err) {
    df <- filter(depths, TARGET_DEPTH %in% as.numeric(depth)) %>% filter(ERR_MODEL %in% err)
    mean(df[, 3])
}

target <- c()
data <- c()
mean_depth <- c()
for (d in c(20, 40, 60, 80, 100)) {
    for (e in c("R94", "nanopore2018", "nanopore2020", "pacbio2016", "clr")) {
        m <- get_mean(d, e)
        target <- c(target, d)
        data <- c(data, e)
        mean_depth <- c(mean_depth, m)
    }
}
mean_depth <- data.frame(target, data, mean_depth)
ggplot(data = mean_depth) +
    geom_bar(aes(x = factor(target), y = mean_depth, fill = data), stat = "identity") +
    scale_fill_brewer(palette = "Blues") +
    facet_grid(. ~ data) +
    xlab("Target depth") +
    ylab("Mean real depth") +
    theme_bw() +
    theme(panel.grid = element_blank())
write.csv(mean_depth, "C:/Users/suyaqi/Desktop/merged_mean.csv")

#2. AS size
AS <- read.csv("C:/Users/suyaqi/Desktop/AS.csv", header = T)
ggplot(data = AS) +
    geom_boxplot(aes(x = factor(TARGETED_TRANSCRIPT_NUMBER), y = TRANSCRIPT_NUMBER,
                     fill = factor(TARGETED_TRANSCRIPT_NUMBER))) +
    scale_fill_brewer(palette = "Blues") +
    xlab("Target Isoform number per gene") +
    ylab("Real isoform number per gene") +
    scale_y_continuous(breaks = c(1, 5, 9, 13, 17), limits = c(0, 18)) +
    theme_bw() +
    theme(panel.grid = element_blank())

#3. Reference annotation
Ref <- read.csv("C:/Users/suyaqi/Desktop/ref.csv", header = T)
Ref <- Ref %>% mutate(Real_perc = transcript_number / max(transcript_number))
ggplot(data = Ref) +
    geom_bar(aes(x = factor(target_percent), y = Real_perc, fill = factor(target_percent)), stat = "identity") +
    scale_fill_brewer(palette = "Blues") +
    xlab("Target percent") +
    ylab("Real percent") +
    theme_bw() +
    theme(panel.grid = element_blank())

#4. Read length distribution
setwd("D:/LabW/benchmark_results/read_length_tsv")
df <- read.table("depth_100_pbsim_nanopore2018.fq.nanoplotNanoPlot-data.tsv", header = T)
#df<-data.frame(df[which(df$lengths<=20000),])
#colnames(df)[1]<-"LEN"
df$TYPE <- "nanopore2018"
df2 <- read.table("depth_100_pbsim_nanopore2020.fq.nanoplotNanoPlot-data.tsv", header = T)
#df2<-data.frame(df[which(df$lengths<=20000),])
df2$TYPE <- "nanopore2020"
#colnames(df2)[1]<-"LEN"
df3 <- read.table("depth_100_pbsim_pacbio2016.fq.nanoplotNanoPlot-data.tsv", header = T)
#df3<-data.frame(df[which(df$lengths<=20000),])
df3$TYPE <- "pacbio2016"
#colnames(df3)[1]<-"LEN"
df4 <- read.table("depth_100_R94.fq.nanoplotNanoPlot-data.tsv", header = T)
#df4<-data.frame(df[which(df$lengths<=20000),])
df4$TYPE <- "R94"
#colnames(df4)[1]<-"LEN"
df5 <- read.table("depth_100_pbsim_clr.fq.nanoplotNanoPlot-data.tsv", header = T)
#df5<-data.frame(df[which(df$lengths<=20000),])
df5$TYPE <- "clr"
#colnames(df5)[1]<-"LEN"
df_m <- rbind(df, df2, df3, df4, df5)
df_m <- data.frame(df_m[which(df_m$lengths <= 5000),])
#hist(log(as.numeric(df[,-1]),base = exp(10)),col="sky blue")
#plot(density(as.numeric(df[,-1])))
ggplot(df_m) +
    geom_violin(aes(x = TYPE, y = lengths, fill = TYPE)) +
    scale_fill_brewer(palette = "RdBu") +
    scale_y_continuous(breaks = c(0, 1000, 2000, 3000, 4000, 5000)) +
    theme_bw() +
    theme(panel.grid = element_blank())
