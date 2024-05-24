#!/bin/bash

set -e
set -o pipefail

# Set the working directory to the directory of this file
cd "$(dirname "${BASH_SOURCE[0]}")"

# Get the transcriptome and tx2gene
bash scripts/obtain-transcriptome.sh
Rscript scripts/prepare-tx2gene.R

# fastp, Salmon, fastqc, multiqc
snakemake --cores 4 \
    --forceall \
    --rerun-incomplete

# Run tximport
Rscript scripts/run-tximport.R
