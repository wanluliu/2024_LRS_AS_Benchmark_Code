# 1. Differential isoform usage
# Import the required packages
library(IsoformSwitchAnalyzeR)
library(dplyr)

##plant
sg1 <- read.table("sga.txt", sep = "\t", header = T)
sg1 <- sg1[, c(1, 7)]
sg2 <- read.table("sgb.txt", sep = "\t", header = T)
sg2 <- sg2[, c(1, 7)]
sg3 <- read.table("sgc.txt", sep = "\t", header = T)
sg3 <- sg3[, c(1, 7)]
w1 <- read.table("wa.txt", sep = "\t", header = T)
w1 <- w1[, c(1, 7)]
w2 <- read.table("wb.txt", sep = "\t", header = T)
w2 <- w2[, c(1, 7)]
w3 <- read.table("wc.txt", sep = "\t", header = T)
w3 <- w3[, c(1, 7)]
merge <- dplyr::full_join(sg1, sg2, by = "Geneid")
merge <- dplyr::full_join(merge, sg3, by = "Geneid")
merge <- dplyr::full_join(merge, w1, by = "Geneid")
merge <- dplyr::full_join(merge, w2, by = "Geneid")
merge <- dplyr::full_join(merge, w3, by = "Geneid")
colnames(merge) <- c("isoform_id", "sg1", "sg2", "sg3", "w1", "w2", "w3")
merge <- replace(merge, is.na(merge), 0)
sampleID <- c("sg1", "sg2", "sg3", "w1", "w2", "w3")
condition <- c("sg", "sg", "sg", "w", "w", "w")
designMatrix <- cbind(data.frame(sampleID), data.frame(condition))

### Create switchAnalyzeRlist
aSwitchList <- importRdata(
    isoformNtFasta = "stringtie_unguide.fa",
    showProgress = FALSE,
    isoformCountMatrix = merge,
    designMatrix = designMatrix,
    isoformExonAnnoation = "stringtie_unguide_merge.gtf",
    ignoreAfterPeriod = FALSE #if using the reference gtf, then this should set TRUE.
)

SwitchListAnalyzed <- isoformSwitchTestDEXSeq(
    switchAnalyzeRlist = aSwitchList,
    reduceToSwitchingGenes = TRUE,
    reduceFurtherToGenesWithConsequencePotential = FALSE,
    alpha = 0.05,
    dIFcutoff = 0.1,
    onlySigIsoforms = FALSE
)
switchListO <- analyzeORF(SwitchListAnalyzed,
                          showProgress = FALSE)
switchListS <- extractSequence(switchListO,
)
switchListsR <- analyzeAlternativeSplicing(switchListS, quiet = TRUE, onlySwitchingGenes = FALSE)
consequencesOfInterest <- c('intron_retention', 'NMD_status', 'ORF_seq_similarity')

exampleSwitchListAnalyzed <- analyzeSwitchConsequences(
    switchListsR,
    consequencesToAnalyze = consequencesOfInterest,
    dIFcutoff = 0.1,
    alpha = 0.05,
    showProgress = FALSE
)
#Isoform switch consequences
extractConsequenceSummary(
    exampleSwitchListAnalyzed,
    consequencesToAnalyze = 'all',
    plotGenes = FALSE,           # enables analysis of genes (instead of isoforms)
    asFractionTotal = FALSE, # enables analysis of fraction of significant features
    returnResult = TRUE
)
#SPlicing summary
extractSplicingSummary(
    switchListsR,
    asFractionTotal = FALSE,
    plotGenes = FALSE,
    returnResult = TRUE
)


### Plot DIU result ###
AS <- read.csv("DIU_splicing.csv", header = T)
ggplot(AS, aes(x = Software, y = ifelse(Isoform == "More", Number, -Number), fill = Type)) +
    scale_fill_brewer(palette = "RdBu") +
    geom_bar(stat = "identity", position = "stack") +
    coord_flip() +
    scale_y_continuous(labels = abs) +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    ylab("Number of isoforms")
consequence <- read.csv("DIU_consequence.csv", header = T)
ggplot(consequence, aes(x = Software, y = Number, fill = Consequence)) +
    scale_fill_brewer(palette = "RdBu", direction = -1) +
    geom_bar(stat = "identity", position = "stack") +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
  
  

