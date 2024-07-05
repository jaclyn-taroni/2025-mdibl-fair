#!/usr/bin/env Rscript

# Adapted from: https://github.com/AlexsLemonade/training-modules/blob/4132971bb861d5e677e851c7c833c123b3d91673/machine-learning/setup/01-transform-rnaseq.Rmd

#### Libraries -----------------------------------------------------------------

library(DESeq2)
library(rprojroot)

#### Directories and files -----------------------------------------------------

# Directories
root_dir <- find_root(has_dir(".git"))
ml_data_dir <- file.path(
  root_dir,
  "setup",
  "machine-learning",
  "data"
)
metadata_dir <- file.path(ml_data_dir, "metadata")
expression_dir <- file.path(ml_data_dir, "expression")

# Input files
histologies_file <- file.path(metadata_dir, "pbta-histologies.tsv")
stranded_counts_file <- file.path(
  expression_dir,
  "pbta-gene-counts-rsem-expected_count.stranded.rds"
)

# Output directories and files

# Output metadata directory and file
output_metadata_dir <- file.path(
  root_dir,
  "instruction-material",
  "machine-learning",
  "data",
  "metadata"
)
filtered_histologies_file <- file.path(
  output_metadata_dir,
  "pbta-histologies-medulloblastoma-rnaseq.tsv"
)
medulloblastoma_output_file <- file.path(
  expression_dir,
  "pbta-vst-medulloblastoma.tsv.gz"
)

#### Read in data --------------------------------------------------------------

histologies_df <- readr::read_tsv(histologies_file,
  guess_max = 10000
) |>
  # We'll only be looking at the stranded RNA-seq dataset, so filter out
  # all other samples (e.g., WGS)
  dplyr::filter(
    experimental_strategy == "RNA-Seq",
    RNA_library == "stranded"
  ) |>
  # Remove columns that are all NA (typically pertain only to the DNA data)
  purrr::discard(~ all(is.na(.))) |>
  dplyr::filter(short_histology == "Medulloblastoma") |>
  dplyr::select(
    Kids_First_Biospecimen_ID,
    short_histology,
    molecular_subtype
  )

# Grab medulloblastoma sample identifiers
medulloblastoma_bsids <- histologies_df |>
  dplyr::pull(Kids_First_Biospecimen_ID)

# Write cleaned metadata file to the output dir
readr::write_tsv(histologies_df, filtered_histologies_file)

# Technically a data.frame, not a matrix
stranded_count_mat <- readr::read_rds(stranded_counts_file)

#### Process data --------------------------------------------------------------

# Reorder the stranded counts matrix such that it is in the same order as the
# histologies data frame
stranded_count_mat <- stranded_count_mat |>
  # We want to retain the Ensembl gene identifiers as the first column
  dplyr::select(gene_id, histologies_df$Kids_First_Biospecimen_ID) |>
  # Make the gene identifier column the rownames and make this into a matrix
  tibble::column_to_rownames("gene_id") |>
  as.matrix()

# This is the output of RSEM - some values will not be integers, rounding this
# makes it such that these values are integers
stranded_count_mat <- round(stranded_count_mat)

# Error if samples are not in the same order
if (!identical(colnames(stranded_count_mat), histologies_df$Kids_First_Biospecimen_ID)) {
  stop("Samples are not in the same order")
}

## Variance stabilizing transformation
# We'll set this to be blind to the experimental design
ddset <- DESeqDataSetFromMatrix(
  countData = stranded_count_mat,
  colData = histologies_df,
  design = ~1
)

# Remove genes with low total counts
genes_to_keep <- rowSums(counts(ddset)) >= 10
ddset <- ddset[genes_to_keep, ]

# Transformation itself
vst_data <- vst(ddset, blind = TRUE)

# Now create a data frame where the gene identifiers are in the first column
# And only retain the medulloblastoma samples
vst_df <- data.frame(assay(vst_data)) |>
  tibble::rownames_to_column("gene_id") |>
  dplyr::select("gene_id", dplyr::all_of(medulloblastoma_bsids))

# Write to TSV!
readr::write_tsv(vst_df, file = medulloblastoma_output_file)
