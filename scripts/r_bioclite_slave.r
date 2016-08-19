#!/usr/bin/env Rscript

## Update R installation with necessary packages from bioclite

## Recieve input files from bash
args <- commandArgs(TRUE)
packagelist=(args[1])

## Read in package list
r_list <- readLines(packagelist)

## BiocLite installs
source('http://bioconductor.org/biocLite.R')
#pkgs <- rownames(installed.packages())
#biocLite(pkgs, type="source")
#biocLite()

## For loop to install packages from list
for (i in r_list){
if (is.element(i,installed.packages()[,1]) == FALSE) {
biocLite(i)
}}

## For loop to check success or failure and send to log
for (i in r_list){
if (is.element(i,installed.packages()[,1]) == FALSE) {
print(paste(i,"installation FAILED!!!"))
} else {
print(paste(i,"is properly installed"))
}}

## Exit
q()
