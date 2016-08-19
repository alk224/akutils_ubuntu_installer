#!/usr/bin/env Rscript

## Update R installation with necessary packages from CRAN

## Recieve input files from bash
args <- commandArgs(TRUE)
packagelist=(args[1])

## Set mirror
chooseCRANmirror(graphics=FALSE, ind=85)

## Update any "old" packages
#update.packages(ask = FALSE, dependencies = c('Suggests'))

## Read in package list
r_list <- readLines(packagelist)

## For loop to install packages from list
for (i in r_list){
if (is.element(i,installed.packages()[,1]) == FALSE) {
install.packages(i)
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
