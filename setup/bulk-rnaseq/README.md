## Set up for bulk RNA-seq instruction materials

### Development on Apple Silicon

`conda` must be installed ([instructions](https://docs.conda.io/projects/continuumio-conda/en/latest/user-guide/install/macos.html)), and the following channels added:

```
conda config --add channels bioconda
conda config --add channels conda-forge
```

We need to use Rosetta2 to install the command line tools, so we set up the environment with the following:

```
CONDA_SUBDIR=osx-64 conda create -n 2023_mdibl_fair
conda activate 2023_mdibl_fair
conda env config vars set CONDA_SUBDIR=osx-64
# Reactivate to make changes take effect
conda activate 2023_mdibl_fair
```

We can install specific packages using the `environment.yml` file with the following command:

```
conda env update --file environment.yml --prune
```

And then reactivate the environment for development:

```
conda activate 2023_mdibl_fair  
```

### Download transcriptome index from [refgenie](http://refgenie.databio.org/en/latest/)

Specifically, we'll download this [Salmon hg38 cDNA index from refgenie](http://refgenomes.databio.org/v3/assets/splash/9a02d64909100f146272f8e16563178e9e93c218b1126ff9/salmon_index?tag=default).

_There were issues getting refgenie installed on the workshop server, so we use `wget` instead of `refgenie pull` in this shell script._

```
bash scripts/obtain-transcriptome.sh
```

### Prepare tx2gene TSV

`tximport` requires a data frame that contains ENST to ENSG identifiers.
We use AnnotationHub to do get the required TSV, assuming that the most recent Ensembl release (release 103) was used when the refgenie index was built (2021 April), by running the following:

```
Rscript scripts/prepare-tx2gene.R
```

### QC, preprocessing, and quantification

We run FastQC, fastp, Salmon, and MultiQC via Snakemake:

```
snakemake --cores 4
```

If cloned from an earlier year's repository, you likely want to include the `--forceall` flag.

### tximport

The final processing step is `tximport`, which can be run with the following:

```
Rscript scripts/run-tximport.R
```
