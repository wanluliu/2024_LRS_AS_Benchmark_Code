library("tidyverse")

df <- readr::read_tsv("ensembl_mt/FINE2a.mm.bam.depth", col_names = c("CHR", "POS", "DEPTH"))
g <- ggplot(df) +
    geom_line(aes(x=POS, y=DEPTH)) +
    facet_wrap(.~CHR, scales="free") +
    theme_bw()
ggsave("test.png", g)

