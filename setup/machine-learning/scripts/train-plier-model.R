#!/usr/bin/env Rscript

# JN Taroni 2024
#
# Train a PLIER model on the prepared medulloblastoma data
#
# USAGE: Rscript 02-train-plier-model.R

#### Libraries and misc setup --------------------------------------------------

library(PLIER)

# Seed set up
seed <- 1234
set.seed(seed)

#### Directories and files -----------------------------------------------------

root_dir <- find_root(has_dir(".git"))
ml_data_dir <- file.path(
  root_dir,
  "setup",
  "machine-learning",
  "data"
)

# Contains expression input
expression_dir <- file.path(ml_data_dir, "expression")

# Output model directory
ml_model_dir <- file.path(
  root_dir,
  "instruction-material",
  "machine-learning",
  "results",
  "plier"
)

# Create if it doesn't exist yet
dir.create(ml_model_dir, recursive = TRUE, showWarnings = FALSE)

# VST transformed data
expression_file <- file.path(
  expression_dir,
  "pbta-vst-medulloblastoma.tsv.gz"
)

# Output
plier_model_file <- file.path(
  ml_model_dir,
  "medulloblastoma_plier_model.rds"
)

#### Expression data setup -----------------------------------------------------

# Read in transformed RNA-seq data
rnaseq_df <- read_tsv(expression_file)

# Need to separate the two gene identifiers -- PLIER uses gene symbols
symbol_rnaseq_df <- rnaseq_df |>
  tidyr::separate(gene_id, # Take the gene_id column
    # Create two new columns called ensembl_id and gene_symbol
    into = c("ensembl_id", "gene_symbol"),
    # The values for these two columns are separated by _
    sep = "_",
    # Some gene symbols themselves contain _, so when that happens
    # merge everything after the first _ into the gene_symbol
    # colum
    extra = "merge"
  ) |>
  select(-ensembl_id)

# Add the row means so we can use this information to collapse duplicate gene
# symbols -- mean transformed value across the entire cohort
symbol_rnaseq_df$mean_value <- rowMeans(symbol_rnaseq_df[, -1])

# For a given duplicated gene symbol, select the row with the highest average
# expression value.
collapsed_rnaseq_df <- symbol_rnaseq_df |>
  # For each set of rows that correspond to the same gene symbol
  group_by(gene_symbol) |>
  # Select the single row with the highest value in the mean_value column
  top_n(1, mean_value) |>
  # In the case of ties, where the mean values are the same, randomly pick one
  # row
  sample_n(1)

# Make it a matrix
medulloblastoma_rnaseq_mat <- collapsed_rnaseq_df |>
  select(-mean_value) |>
  tibble::column_to_rownames("gene_symbol") |>
  as.matrix()

# Row normalize -- z-scoring the genes
medulloblastoma_zscore <- PLIER::rowNorm(medulloblastoma_rnaseq_mat)

#### PLIER set up --------------------------------------------------------------

# Load pathways from the PLIER package
data("bloodCellMarkersIRISDMAP")
data("canonicalPathways")
data("svmMarkers")

# Combine the pathway data from PLIER
all_pathways <- PLIER::combinePaths(
  bloodCellMarkersIRISDMAP,
  canonicalPathways,
  svmMarkers
)

# Identify genes that are common to the pathway data and the zscore mat
common_genes <- PLIER::commonRows(all_pathways, medulloblastoma_zscore)

#### Run PLIER -----------------------------------------------------------------

# Run PLIER
plier_results <- PLIER::PLIER(
  data = medulloblastoma_zscore[common_genes, ],
  priorMat = all_pathways[common_genes, ],
  rseed = seed
)

# Save model
readr::write_rds(plier_results,
  plier_model_file,
  compress = "gz"
)
