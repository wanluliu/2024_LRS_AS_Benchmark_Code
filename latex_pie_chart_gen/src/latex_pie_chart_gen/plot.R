library(argparser)

p <- argparser::arg_parser("")
p <- argparser::add_argument(p, "--src_data_csv_file_path", "")
p <- argparser::add_argument(p, "--dst_fig_dir_path", "")
argv <- argparser::parse_args(p)

library(tidyverse)
library(ggpubr)
library(parallel)
cl <- parallel::makeCluster(spec = 8)

dir.create(argv$dst_fig_dir_path, showWarnings = FALSE, recursive = TRUE)

data <- readr::read_csv(
    argv$src_data_csv_file_path,
    col_types = c(
        Software = col_character(),
        Dataset = col_character(),
        .default = col_double()
    )
)

data <- data %>%
    dplyr::mutate(
        fig_filename = file.path(
            argv$dst_fig_dir_path,
            sprintf("%s-%s.pdf", Software, Dataset)
        )
    )

data_long <- data %>%
    tidyr::gather(
        key = "type",
        value = "count",
        -Software,
        -Dataset,
        -fig_filename
    )

color_limits <- c("FSM", "ISM", "NIC", "NNC", "Intergenic", "Antisense")
color_values <-c("#B2182B", "#F4A582", "#9E9AC8", "#92C5DE", "#2166AC", "#0a1f35")

clusterExport(cl, varlist = ls(), envir = environment())
parLapply(cl, unique(data_long$fig_filename), function(fn) {
    g <- ggpubr::ggpie(
        dplyr::filter(
            data_long,
            fig_filename == fn
        ),
        "count",
        label = "type",
        fill = "type",
        color = "white",
    ) +
        ggplot2::theme_void() +
        ggplot2::theme(legend.position = "none") +
        ggplot2::scale_fill_manual(
            values = color_values,
            limits = color_limits
        )
    ggplot2::ggsave(fn, g, width = 5, height = 5)
})

stopCluster(cl)

g <- ggpubr::ggpie(
        data.frame(count=1, type="NULL"),
        "count",
        label = "type",
        fill = "type",
        color = "black",
    ) +
        ggplot2::theme_void() +
        ggplot2::theme(legend.position = "none") +
        ggplot2::scale_fill_manual(
            values = c("white"),
            limits = c("NULL")
        )
ggplot2::ggsave(file.path(argv$dst_fig_dir_path, "full.pdf"), g, width = 5, height = 5)

g <- ggpubr::ggpie(
        data.frame(count = replicate(length(color_limits), 1), type = color_limits),
        "count",
        label = "type",
        fill = "type",
        color = "black",
    ) +
        ggplot2::theme_void() +
        ggplot2::scale_fill_manual(
            values = color_values,
            limits = color_limits
        )
ggplot2::ggsave(file.path(argv$dst_fig_dir_path, "legend.pdf"), g, width = 7, height = 5)
