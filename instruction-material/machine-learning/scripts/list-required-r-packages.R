#!/usr/bin/env Rscript

# Create a TSV of packages used in the ML material

#### Directory and file setup --------------------------------------------------

# Identify the root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

# We want to use the RProject in the machine learning instruction material
# directory
ml_instruction_dir <- file.path(
  root_dir,
  "instruction-material",
  "machine-learning"
)

# Create folder to hold output of this script
components_dir <- file.path(
  ml_instruction_dir,
  "components"
)
dir.create(components_dir, showWarnings = FALSE, recursive = TRUE)

# Output file with the tables
packages_table_file <- file.path(
  components_dir,
  "taroni_ml_package_requirements.tsv"
)

#### Packages list -------------------------------------------------------------

# Initialize renv
renv::init(project = ml_instruction_dir)

# Grab list of packages from renv lockfile
packages_list <- jsonlite::read_json(
  file.path(
    ml_instruction_dir,
    "renv.lock"
  )
) |>
  purrr::pluck("Packages")

# Packages that are not from GitHub
packages_df <- packages_list |>
  # We'll handle GitHub separately
  purrr::discard(~ .x$Source == "GitHub") |>
  # Extract package, version, and repository into a data frame
  purrr::map_df(~ purrr::keep(.x, names(.x) %in% c(
    "Package",
    "Version",
    "Repository"
  ))) |>
  # Simplify the source repo information a bit
  dplyr::mutate(Repository = dplyr::case_when(
    stringr::str_detect(stringr::str_to_lower(Repository), "bioconductor") ~ "Bioconductor",
    Repository == "RSPM" ~ "CRAN",
    TRUE ~ Repository
  )) |>
  # Reorder the columns
  dplyr::select(Package, Repository, Version)

# Packages that are from GitHub
github_packages_df <- packages_list |>
  # Grab the GitHub packages
  purrr::keep(~ .x$Source == "GitHub") |>
  # What we need to construct the URL
  purrr::map_df(~ purrr::keep(.x, names(.x) %in% c(
    "Package",
    "Source",
    "RemoteUsername",
    "RemoteRepo",
    "RemoteRef"
  ))) |>
  # Construct URL to use as Version
  dplyr::mutate(Version = glue::glue("https://github.com/{RemoteUsername}/{RemoteRepo}/releases/tag/{RemoteRef}")) |>
  # Match columns from !GitHub packages
  dplyr::select(Package, Repository = Source, Version)

# Bind the rows together
packages_df <- dplyr::bind_rows(
  packages_df,
  github_packages_df
)

#### Files for keeping track of packages ---------------------------------------

# Copy over the renv lockfile for safe keeping
file.copy(
  file.path(ml_instruction_dir, "renv.lock"),
  file.path(components_dir, "renv.lock")
)

# Write out package table
readr::write_tsv(packages_df, file = packages_table_file)

#### renv cleanup --------------------------------------------------------------

# Remove .Rprofile
renv::deactivate(project = ml_instruction_dir)

# Delete files
file.remove(file.path(ml_instruction_dir, "renv.lock"))
unlink(file.path(ml_instruction_dir, "renv"), recursive = TRUE)
