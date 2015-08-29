#!/usr/bin/env Rscript

## Update R installation with necessary packages

install.packages(c('ape', 'biom', 'optparse', 'RColorBrewer', 'randomForest', 'vegan'))
source('http://bioconductor.org/biocLite.R')
biocLite(c('DESeq2', 'metagenomeSeq'))
