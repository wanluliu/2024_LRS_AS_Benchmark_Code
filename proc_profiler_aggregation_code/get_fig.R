library(tidyverse)
library(parallel)
library(patchwork)

setwd("/home/yuzj/Desktop/profiler3/")

cl <- parallel::makeForkCluster()

get_supplementary_plot <- function(dirname) {
    MAX_X_LABS <- 60
    message(sprintf("Plotting %s...", dirname))

    d <- readr::read_csv(
        sprintf("%s/final.csv", dirname),
        show_col_types = FALSE
    ) %>%
        dplyr::mutate(
            TIME = as.POSIXct(TIME, origin = "1970-01-01")
        )
    wide_d <- d %>%
        tidyr::gather(key = "MEM_TYPE", value = "V", -TIME)

    d_plot <- wide_d %>%
        ggplot() +
        geom_line(aes(x = TIME, y = V, color = MEM_TYPE)) +
        facet_grid(MEM_TYPE ~ ., scales = "free_y") +
        theme_bw() +
        scale_x_datetime(
            "Time",
            breaks = scales::breaks_pretty(n = MAX_X_LABS),
            labels = scales::label_date(format = "%Y-%m-%d %H:%M:%S")
        ) +
        theme(axis.text.x = element_text(angle = 90)) +
        scale_y_continuous(
            "Metrics Value",
            breaks = scales::breaks_extended(n = 5),
            labels = scales::label_number(),
            limits = c(0, NA)
        ) +
        scale_color_discrete(name = "Metrics Type") +
        labs(title = "Metrics Values")

    ggsave(
        sprintf("%s/final.png", dirname),
        d_plot,
        width = 10,
        height = 8
    )
    return(d_plot)
}

# get_plot("flair_20")


flist <- Sys.glob("*_*_new")

parSapply(cl = cl, X = flist, FUN = get_supplementary_plot)

get_required_data <- function(dirname) {
    # CPU time
    # Peak virt data
    message(sprintf("Getting required %s...", dirname))

    d <- readr::read_csv(
        sprintf("%s/final.csv", dirname),
        show_col_types = FALSE
    )

    peak_virt <- max(d$VIRT)
    peak_data <- max(d$RESIDENT)
    mean_virt <- mean(d$VIRT)
    mean_data <- mean(d$RESIDENT)
    clock_time <- max(d$TIME) - mean(d$TIME)
    cpu_time <- 0.0
    for (cpu_time_filename in  Sys.glob(sprintf("%s/*.cputime", dirname))) {
        con <- file(cpu_time_filename, "r")
        cpu_time <- cpu_time + as.numeric(readLines(con, n = 1))
        close(con)
    }
    return(c(clock_time, cpu_time, peak_data, peak_virt, mean_data, mean_virt))
}


plot_table <- tibble::tibble(
    SOFT = c(),
    DATA_SIZE = c(),
    CPU_TIME = c(),
    PEAK_RESIDENT = c(),
    PEAK_VIRT = c()
)
flist <- c()
# for (software in c("FLAMES", "flair", "stringtie")) {
for (software in c("bambu_unguide", "bambu_guide")) {
    for (depth in seq(20, 100, 20)) {
        dirname <- paste(software, depth ,sep = "_")
        flist <- c(flist, dirname)

        this_required_data <- get_required_data(dirname)
        plot_table <- dplyr::bind_rows(
            plot_table,
            tibble::tibble(
                SOFT = software,
                DATA_SIZE = depth,
                CLOCK_TIME = c(this_required_data[1]),
                CPU_TIME = c(this_required_data[2]),
                PEAK_RESIDENT = c(this_required_data[3]),
                PEAK_VIRT = c(this_required_data[4]),
                MEAN_RESIDENT = c(this_required_data[5]),
                MEAN_VIRT = c(this_required_data[6])
            )
        )
    }
}

plot_table_wide <- plot_table %>%
    dplyr::select(!(CPU_TIME)) %>%
    dplyr::select(!(CLOCK_TIME)) %>%
    tidyr::gather(key = "MEM_TYPE", value = "V", -SOFT, -DATA_SIZE)

readr::write_csv(plot_table, "plot_table.csv")

mplot <- ggplot(plot_table_wide, aes(x = DATA_SIZE, y = V)) +
    geom_line(
        aes(color = SOFT),
        stat = "identity"
    ) +
    theme_bw() +
    scale_y_continuous(
        "Memory Consumption",
        breaks = scales::breaks_extended(n = 10),
        labels = scales::label_bytes(accuracy = 0.1),
        trans="log1p"
    ) +
    scale_fill_discrete(name = "Software Name") +
    facet_wrap(. ~ MEM_TYPE, scales = "free_y")
ggsave(
    "memory_l1p.png",
    mplot,
    width = 10,
    height = 8
)


ltplot <- ggplot(plot_table, aes(x = DATA_SIZE, y = CLOCK_TIME)) +
    geom_line(aes(color = SOFT)) +
    theme_bw() +
    scale_y_continuous(
        "CLOCK Time",
        breaks = scales::breaks_extended(n = 10),
        labels = scales::label_number(),
        trans="log1p"
    ) +
    scale_color_discrete(name = "Software Name")
ggsave(
    "wall_clock_l1p.png",
    ltplot,
    width = 10,
    height = 8
)
#
# ctplot <- ggplot(plot_table, aes(x = DATA_SIZE, y = CPU_TIME)) +
#     geom_line(aes(color = SOFT)) +
#     theme_bw() +
#     scale_y_continuous(
#         "CPU Time",
#         breaks = scales::breaks_extended(n = 10),
#         labels = scales::label_number(),
#         trans="log1p"
#     ) +
#     scale_color_discrete(name = "Software Name")
# ggsave(
#     "cpu_time.png",
#     ctplot,
#     width = 10,
#     height = 8
# )
# ggplot(plot_table, aes(x = CPU_TIME, y = MEAN_VIRT)) +
#     geom_point(aes(color = SOFT)) +
#     theme_bw() +
#     scale_x_continuous(
#         "CPU Time",
#         breaks = scales::breaks_extended(n = 10),
#         labels = scales::label_number(),
#         trans="log"
#     ) +
#     scale_y_continuous(
#         "Mean Virtual Memory Consumption",
#         breaks = scales::breaks_extended(n = 10),
#         labels = scales::label_bytes(accuracy = 0.1),
#         trans="log"
#     ) +
#     scale_color_discrete(name = "Software Name")

# ggplot(plot_table, aes(x = CPU_TIME, y = PEAK_VIRT)) +
#     geom_point(aes(color = SOFT)) +
#     theme_bw() +
#     scale_x_continuous(
#         "CPU Time",
#         breaks = scales::breaks_extended(n = 10),
#         labels = scales::label_number(),
#         trans="log"
#     ) +
#     scale_y_continuous(
#         "Peak Virtual Memory Consumption",
#         breaks = scales::breaks_extended(n = 10),
#         labels = scales::label_bytes(accuracy = 0.1),
#         trans="log"
#     ) +
#     scale_color_discrete(name = "Software Name")
