# Setting up a bulk RNA-seq conda environment

We can use conda to install the command line tools and R packages needed for the bulk RNA-seq material on the server.

### Step 1: Initialize conda

First, we need to initialize conda.

```sh
conda init
```

### Step 2: Log out and log back in

Log out of the server, and then log back in.

Once you log back in, your prompt should now look something like:

> ```
> (base) [ws00@ip ~]$
> ```

This shows that the base conda environment is active.

### Step 3: Create a new `rnaseq` environment

3. We want to create and activate a new conda environment called `rnaseq` which we can do with the following:

```sh
conda create -n rnaseq
conda activate rnaseq
```

Now, your prompt should look something like:

> ```sh
> (rnaseq) [ws00@ip ~]$
> ```

### Step 4: Set up conda channels

We need to tell conda where it should install packages from ("channels"), which we can do by running the following:

```sh
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict
```

### Step 5: Install the command line tools and R packages

Now we're ready to Install packages we need to run preprocessing, quantification, and summarization to the gene-level which we can do with the following command:

```
conda install salmon=1.10.3 fastp=0.26.0 r-base r-optparse r-biocmanager r-jsonlite
```

When prompted to proceed with `Proceed ([y]/n)?`, enter `y` to continue with installation.

Then we need to install the R package `tximport` with Bioconductor, which we can do with the following:

```
Rscript -e "BiocManager::install('tximport')"
```

### Step 6: Follow along with the bulk RNA-seq material

Now you have all the tools you need to follow along with the bulk RNA-seq material: 

- [01-fastp-salmon](01-fastp-salmon.md)
- [02-tximport](02-tximport.md)
