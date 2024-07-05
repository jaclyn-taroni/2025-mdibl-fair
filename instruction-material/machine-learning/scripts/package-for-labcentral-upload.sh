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

# Copy over the expression data
cp -r ../data/expression/ $prep_dir/data

# Copy over the metadata
cp -r ../data/metadata/ $prep_dir/data

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
