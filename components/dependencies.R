# To make sure packages are captured with renv
library("PLIER")
library("BiocManager")
library("BiocVersion")
library("kernlab")
library("markdown")
library("vembedr")
library("callr") # required by reprex
library("clipr") # required by readr, reprex
library("commonmark") # required by markdown
library("ellipsis") # required by recipes
library("prettyunits") # required by progress
library("ragg") # required by tidyverse
library("rematch2") # required by googlesheets4
library("rstudioapi") # required by reprex, tidyverse
library("xml2")
library("ensembldb") # required for AnnotationHub steps
library("precommit") # required for precommit hooks to work as intended
