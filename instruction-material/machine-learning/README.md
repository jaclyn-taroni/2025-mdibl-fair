## Machine learning

Some material in `01-ml-experimental-design.Rmd` is adapted from [Penn GCB 535](https://github.com/greenelab/GCB535).
It uses the dataset from that repo in `data/expression` and `data/metadata`, which can be downloaded with:

```
scripts/download-brca-data.sh
```

Material in `02-ml-biological-contexts.Rmd` has been adapted from [ALSF CCDL training materials](https://github.com/AlexsLemonade/training-modules/tree/master/machine-learning).

We prepare the data (using `release-v19-20210423`) using the set up code [here](https://github.com/AlexsLemonade/training-modules/tree/22ff7cf8f7f931cfe031062044f0a9e09b7d2565/machine-learning/setup).

### `renv`

We use `renv` to manage R packages for this material.
We assumed that training participants will use the most recent version of R (`4.3.1` as of writing).

#### Initial set up

To set up the `renv` lockfile, we needed to install `renv`, `remotes`, and `PLIER`.
(`PLIER` could not be installed automatically via `renv::init()`.)

```r
install.packages(c("renv", "remotes"))
remotes::install_github("wgmao/PLIER@v0.1.6")
```
Then we could initialize the project with the following:

```r
renv::init()
```

`digest` also needed to be installed separately with the following:

```r
install.packages("digest", repos="http://cran.us.r-project.org")
```

#### Development with `renv`

Develop using the `machine-learning.Rproj` Rproject and restore the state of the project from the lockfile with:

```r
renv::restore() 
```

Sometimes all R packages are not captured with `renv::snapshot()` if they are not explicitly loaded in notebooks. 
To ensure a dependency is captured in the lockfile, add `library(<package>)` to `components/dependencies.R`.
