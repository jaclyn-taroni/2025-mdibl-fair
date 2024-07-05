#!/bin/bash
# Adapted from: https://github.com/AlexsLemonade/training-modules/blob/4132971bb861d5e677e851c7c833c123b3d91673/machine-learning/setup/00-data-download.sh

set -e
set -o pipefail

# Set the working directory to the directory of this file
cd "$(dirname "${BASH_SOURCE[0]}")"

# Final release as part of OpenPBTA project
RELEASE=${OPENPBTA_RELEASE:-release-v23-20230115}

# Use the OpenPBTA bucket.
bucket_url=https://s3.amazonaws.com/d3b-openaccess-us-east-1-prd-pbta/data

# PBTA histologies
cd ../data/metadata
wget -c ${bucket_url}/${RELEASE}/pbta-histologies.tsv

# Relevant RNA-seq data
cd ../expression
wget -c ${bucket_url}/${RELEASE}/pbta-gene-counts-rsem-expected_count.stranded.rds
