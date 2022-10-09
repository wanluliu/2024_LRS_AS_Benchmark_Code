# `yasim` -- Yet Another SIMulator

Read simulator for Next- and Third-Generation Sequencing with Alternative Splicing and Differently Expressed Genes.

## WARNING

This simulator is still under develop, so source code here **are for reference only**.

## Installation

Build the simulator using:

```shell
python3 setup.py sdist
pip install dist/yasim-0.2.7-hotfix1.tar.gz
```

## Using `yasim`

List all available subcommands: `yasim lscmd`

An example using hg38:

```shell
yasim generate_as_events -f hg38.fa -g hg38.gtf -o hg38_as.gtf
yasim generate_depth -g hg38_as.gtf -o hg38_depth.tsv -d 100
yasim transcribe -f hg38.fa -g hg38_as.gtf -o hg38_trans.fa
yasim pbsim2 \
    -F hg38_trans.fa.d \
    -o hg38_pbsim \
    -d hg38_depth.tsv \
    --hmm_model P4C2 \
    --exename PATH_TO_PBSIM2 \
    -j 40
```
