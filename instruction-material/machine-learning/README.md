## Machine learning

### Sources

Some material in `01-ml-experimental-design.Rmd` is adapted from [Penn GCB 535](https://github.com/greenelab/GCB535).

Material in `02-ml-biological-contexts.Rmd` has been adapted from [ALSF Childhood Cancer Data Lab training materials](https://github.com/AlexsLemonade/training-modules/tree/master/machine-learning).

### Data preparation

#### BRCA

The breast cancer datasets used in `01-ml-experimental-design.Rmd` are downloaded from `greenelab/GCB535` and placed in `data/expression` and `data/metadata` via the following:

```
bash scripts/download-brca-data.sh
```

#### PBTA and PLIER

See [the setup directory for this material](../../setup/machine-learning/).

### Creating a zip file for upload

Running the following will create a ZIP file (`for_upload/mdibl-ml.zip`) to be uploaded to LabCentral:

```sh
bash scripts/package-for-labcentral-upload.sh
```

The script tests that the R Notebooks can render with the files that are copied over and then freshly copies over the R Notebooks.
This implicitly clears the chunk output, because output is stored in hidden folders ([ref](https://bookdown.org/yihui/rmarkdown/notebook.html#output-storage)) that are not copied over via this shell script.
