# Setup for machine learning material

To save time during the PLIER instruction material, we prepare the PLIER model ahead of time.

All setup steps can be run with the following, assuming you are in the current directory:

```sh
bash run-all.sh
```

Which does the following:

1. Downloads PBTA data
2. Subsets the PBTA data to the medulloblastoma data and performs transformation
3. Runs PLIER

The model that is output is available in the following location:

```
instruction-materials/machine-learning/results/plier/medulloblastoma_plier_model.rds
```

The model is ignored by Git, but this location allows us to package it up for upload to the course website.
