# FAIR 2024

These materials are for instruction in MDIBL's 2024 Reproducible and FAIR Bioinformatics Analysis of Omics Data course.

They are adapted from [Alex's Lemonade Stand Foundation](https://www.alexslemonade.org/) [Childhood Cancer Data Lab](https://www.ccdatalab.org/) [training materials](https://github.com/AlexsLemonade/training-modules), [Harvard Chan Bioinformatics Core](http://bioinformatics.sph.harvard.edu/) lessons and [Penn GCB 535 materials](https://github.com/greenelab/GCB535).
(Sources used will be indicated in individual sections of instruction material.)

## How environments are managed

### Docker

To obtain the Docker image for this material, use the following command:

```sh
docker pull ghcr.io/jaclyn-taroni/2024-mdibl-fair:{platform tag}
```

Where the available platform tags are:

- `amd-64`
- `arm-64`

To distinguish between available architectures.

### Docker Build with GitHub Actions

The GitHub Actions workflow `build-all-docker.yaml` builds upon pull request whenever relevant files are modified.
When relevant files are modified and pushed to `main`, the images are built and pushed to GitHub Container Registry.

### Developing with Docker

You can access the RStudio Server instance using the following command, replacing `{PASSWORD}` – including the curly brackets – with a password of your choosing:

```sh
docker run \
  --mount type=bind,target=/home/rstudio/2024-mdibl-fair,source=$PWD \
  -e PASSWORD={PASSWORD} \
  -p 8787:8787 \
  ghcr.io/jaclyn-taroni/2024-mdibl-fair:{platform tag}
```

You can then navigate to `localhost:8787` in your browser and log in with username `rstudio` and the password you just set via `docker run`.

### Managing dependencies with`renv`

We use `renv` to manage R packages for this material.
The `renv.lock` file is used during the Docker build process.

<details>

<summary>Requirements for initial `renv` setup</summary>

#### Initial set-up

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
<!--

`digest` also needed to be installed separately with the following:

```r
install.packages("digest", repos="http://cran.us.r-project.org")
```

--->

</details>

#### Development with `renv`

Develop using the `2024-mdibl-fair.Rproj` Rproject and restore the state of the project from the lockfile with:

```r
renv::restore()
```

Sometimes all R packages are not captured with `renv::snapshot()` if they are not explicitly loaded in notebooks.
To ensure a dependency is captured in the lockfile, add `library(<package>)` to `components/dependencies.R`.

## Pre-commit

Once you've [installed pre-commit using your preferred method](https://pre-commit.com/#install), you can set it up for this repository with the following command:

```sh
pre-commit install
```
