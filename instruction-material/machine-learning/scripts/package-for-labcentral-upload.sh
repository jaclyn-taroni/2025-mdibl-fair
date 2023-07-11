#!/bin/bash

set -e
set -o pipefail

# Set the working directory to the directory of this file
cd "$(dirname "${BASH_SOURCE[0]}")"

prep_dir=../for_upload
mkdir -p $prep_dir

# Copy R Markdown files
# This should clear the output automatically
cp ../*.Rmd $prep_dir

# Copy over diagrams
cp -r ../diagrams $prep_dir

## Copy over data
mkdir -p ${prep_dir}/data

# Copy over the expression data, but remove the data that's directly from
# the OpenPBTA download
cp -r ../data/expression/ $prep_dir/data
counts_file=${prep_dir}/pbta-gene-counts-rsem-expected_count.stranded.rds
if [[ -f "$counts_file" ]]; then
    rm $counts_file
fi

# Copy over the metadata, but remove the metadata that's directly from the
# OpenPBTA download
cp -r ../data/metadata/ $prep_dir/data
histologies_file=${prep_dir}/data/metadata/pbta-histologies.tsv
if [[ -f  "$histologies_file" ]]; then
  rm $histologies_file
fi

# Copy over results
cp -r ../results/ $prep_dir

# Make sure notebooks can render
cd $prep_dir
Rscript -e "rmarkdown::render('01-ml-experimental-design.Rmd', clean = TRUE)"
Rscript -e "rmarkdown::render('02-ml-biological-contexts.Rmd', clean = TRUE)"
# Clean up *.nb.html files
rm *.nb.html
# Fresh copy of notebooks
cp ../*.Rmd .

# Create zip for upload
zip -r mdibl-ml.zip . -x '**/.*' -x '**/__MACOSX'
