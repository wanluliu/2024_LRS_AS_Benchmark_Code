#!/usr/bin/env Rscript
library(argparse)
library(dplyr)
parser <- ArgumentParser()
parser$add_argument("-i", "--input", help = "The input csv file")
parser$add_argument("-o", "--onput", help = "The output directory")
parser$add_argument("-s", "--software", help = "The name of the software")
parser$add_argument("--type", default = "AS", help = "The type of the input data, can be ANNO or DEPTH, default is AS.")
args <- parser$parse_args()
ds <- read.csv(args$input)
head(ds)
type <- args$type
name <- args$software
out_dir <- args$output

mean_AS <- function(ds, name, type) {
    mean_s <- c()
    sd_s <- c()
    mean_p <- c()
    sd_p <- c()
    condition <- c()
    if (type == "AS") {
        condition <- c("1", "3", "5", "7", "9")
        for (n in condition) {
            Mean_s <- mean(ds[which(ds$Iso_per_gene == n), 1])
            SD_s <- sd(ds[which(ds$Iso_per_gene == n), 1]) / sqrt(5)
            mean_s <- c(mean_s, Mean_s)
            sd_s <- c(sd_s, SD_s)
            Mean_p <- mean(ds[which(ds$Iso_per_gene == n), 2])
            SD_p <- sd(ds[which(ds$Iso_per_gene == n), 2]) / sqrt(5)
            mean_p <- c(mean_p, Mean_p)
            sd_p <- c(sd_p, SD_p)
        }
        Iso_per_gene <- condition
        ds_rep <- cbind(data.frame(rep(name, 5)), data.frame(Iso_per_gene), mean_s, sd_s, mean_p, sd_p)
        colnames(ds_rep) <- c("software", "Iso_per_gene", "mean_sensitivity", "sd_sensitivity", "mean_precision", "sd_precision")
        ds_rep
    }
    else if (type == "ANNO" || type == "DEPTH") {
        condition <- c("20", "40", "60", "80", "100")
        for (n in condition) {
            Mean_s <- mean(ds[which(ds$depth == n), 1])
            SD_s <- sd(ds[which(ds$depth == n), 1]) / sqrt(5)
            mean_s <- c(mean_s, Mean_s)
            sd_s <- c(sd_s, SD_s)
            Mean_p <- mean(ds[which(ds$depth == n), 2])
            SD_p <- sd(ds[which(ds$depth == n), 2]) / sqrt(5)
            mean_p <- c(mean_p, Mean_p)
            sd_p <- c(sd_p, SD_p)
        }
        depth <- condition
        ds_rep <- cbind(data.frame(rep(name, 5)), data.frame(depth), mean_s, sd_s, mean_p, sd_p)
        if (type == "ANNO") {
            colnames(ds_rep) <- c("software", "guidance", "mean_sensitivity", "sd_sensitivity", "mean_precision", "sd_precision")
        }else {
            colnames(ds_rep) <- c("software", "depth", "mean_sensitivity", "sd_sensitivity", "mean_precision", "sd_precision")
        }
        ds_rep
    }
}

ds_rep <- mean_AS(ds, name, type)
write.csv(ds_rep, paste0(out_dir, name, "_mean_sd.csv"))



