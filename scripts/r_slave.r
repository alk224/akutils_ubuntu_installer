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

if (is.element('openxlsx', installed.packages()[,1]) == FALSE) { 
install.packages('openxlsx') }

if (is.element('coin', installed.packages()[,1]) == FALSE) { 
install.packages('coin') }

if (is.element('doParallel', installed.packages()[,1]) == FALSE) { 
install.packages('doParallel') }

if (is.element('DT', installed.packages()[,1]) == FALSE) { 
install.packages('DT') }

if (is.element('exactRankTests', installed.packages()[,1]) == FALSE) { 
install.packages('exactRankTests') }

if (is.element('foreach', installed.packages()[,1]) == FALSE) { 
install.packages('foreach') }

if (is.element('ggplot2', installed.packages()[,1]) == FALSE) { 
install.packages('ggplot2') }

if (is.element('Rcpp', installed.packages()[,1]) == FALSE) { 
install.packages('Rcpp') }

if (is.element('shiny', installed.packages()[,1]) == FALSE) { 
install.packages('shiny') }

if (is.element('R2WinBUGS', installed.packages()[,1]) == FALSE) { 
install.packages('R2WinBUGS') }

if (is.element('rube', installed.packages()[,1]) == FALSE) { 
install.packages('akutils_ubuntu_installer/3rd_party_packages/rube_0.3-9.tar.gz') }

if (is.element('rjags', installed.packages()[,1]) == FALSE) { 
install.packages('rjags') }

if (is.element('jagsUI', installed.packages()[,1]) == FALSE) { 
install.packages('jagsUI') }

if (is.element('BEST', installed.packages()[,1]) == FALSE) { 
install.packages('BEST') }

if (is.element('qiimer', installed.packages()[,1]) == FALSE) { 
install.packages('qiimer') }

if (is.element('indicspecies', installed.packages()[,1]) == FALSE) { 
install.packages('indicspecies') }

if (is.element('testthat', installed.packages()[,1]) == FALSE) { 
install.packages('testthat') }

if (is.element('devtools', installed.packages()[,1]) == FALSE) { 
install.packages('devtools') }

if (is.element('plyr', installed.packages()[,1]) == FALSE) { 
install.packages('plyr') }

if (is.element('dplyr', installed.packages()[,1]) == FALSE) { 
install.packages('dplyr') }

if (is.element('reshape2', installed.packages()[,1]) == FALSE) { 
install.packages('reshape2') }

if (is.element('biomformat', installed.packages()[,1]) == FALSE) {
devtools::install_github("biomformat", "joey711") }

## ANCOM install
if (is.element('ancom.R', installed.packages()[,1]) == FALSE) { 
install.packages('akutils_ubuntu_installer/3rd_party_packages/ancom.R_1.1-2.tar.gz') }

## BiocLite installs
source('http://bioconductor.org/biocLite.R')
pkgs <- rownames(installed.packages())
biocLite(pkgs, type="source")
biocLite()

if (is.element('DESeq2', installed.packages()[,1]) == FALSE) { 
biocLite('DESeq2') }

if (is.element('metagenomeSeq', installed.packages()[,1]) == FALSE) { 
biocLite('metagenomeSeq') }

if (is.element('phyloseq', installed.packages()[,1]) == FALSE) { 
biocLite('phyloseq') }

if (is.element('rhdf5', installed.packages()[,1]) == FALSE) { 
biocLite('rhdf5') }
 
