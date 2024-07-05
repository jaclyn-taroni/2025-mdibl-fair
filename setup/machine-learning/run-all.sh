#!/bin/bash

set -e
set -o pipefail

# Set the working directory to the directory of this file
cd "$(dirname "${BASH_SOURCE[0]}")"

# Download data
bash scripts/00-download-pbta-data.sh

# Process the PBTA data
# Rscript --vanilla scripts/01-process-pbta-data.R

# Run PLIER
Rscript --vanilla scripts/02-train-plier-model.R
