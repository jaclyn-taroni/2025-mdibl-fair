# FAIR 2024

These materials are for instruction in MDIBL's 2024 Reproducible and FAIR Bioinformatics Analysis of Omics Data course.

They are adapted from [Alex's Lemonade Stand Foundation](https://www.alexslemonade.org/) [Childhood Cancer Data Lab](https://www.ccdatalab.org/) [training materials](https://github.com/AlexsLemonade/training-modules), [Harvard Chan Bioinformatics Core](http://bioinformatics.sph.harvard.edu/) lessons and [Penn GCB 535 materials](https://github.com/greenelab/GCB535).
(Sources used will be indicated in individual sections of instruction material.)

## How environments are managed

### Conda "base" environment

Create an conda environment `2024-mdibl-base` using the `environment.yml` file in the root of the repository as follows:

```sh
conda env create -f environment.yml
```

To activate:

```sh
conda activate 2024-mdibl-base
```

### Instruction material

* For setting up the **bulk RNA-seq materials**, we use a conda environment that mirrors what is available on the _FAIR Bioinformatics server_ (i.e., same R version, same versions of Salmon; see [instructions](setup/bulk-rnaseq/README.md#development-on-apple-silicon)).
We assume that development is taking place on an Apple Silicon machine.
* For the **machine learning materials**, we assume that training participants will use their laptops with the most recent version of R and use [`renv`](https://rstudio.github.io/renv/articles/renv.html) to manage packages.

## Pre-commit

Once you've created and activated the `2024-mdibl-base` environment, set up `precommit` with the following command:

```sh
pre-commit install
```