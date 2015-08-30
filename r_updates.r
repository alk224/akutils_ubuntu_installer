#!/usr/bin/env Rscript

## Update R installation with necessary packages

## Set mirror
chooseCRANmirror(graphics=FALSE, ind=85)

## Update any "old" packages
update.packages(ask = FALSE, dependencies = c('Suggests'))

## CRAN installs
if (is.element('RCurl', installed.packages()[,1]) == FALSE) { 
install.packages('RCurl') }

if (is.element('XML', installed.packages()[,1]) == FALSE) { 
install.packages('XML') }

if (is.element('ape', installed.packages()[,1]) == FALSE) { 
install.packages('ape') }

if (is.element('biom', installed.packages()[,1]) == FALSE) { 
install.packages('biom') }

if (is.element('optparse', installed.packages()[,1]) == FALSE) { 
install.packages('optparse') }

if (is.element('RColorBrewer', installed.packages()[,1]) == FALSE) { 
install.packages('RColorBrewer') }

if (is.element('randomForest', installed.packages()[,1]) == FALSE) { 
install.packages('randomForest') }

if (is.element('vegan', installed.packages()[,1]) == FALSE) { 
install.packages('vegan') }

##list.of.packages <- c('ape', 'biom', 'optparse', 'RColorBrewer', 'randomForest', 'vegan')
##new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
##if(length(new.packages)) install.packages(new.packages)


## BiocLite installs
source('http://bioconductor.org/biocLite.R')
biocLite()

#if (is.element('DESeq2', installed.packages()[,1]) == FALSE) { 
biocLite('DESeq2') }

if (is.element('metagenomeSeq', installed.packages()[,1]) == FALSE) { 
biocLite('metagenomeSeq') } 
