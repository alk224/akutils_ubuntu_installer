#!/usr/bin/env Rscript

## Update R installation with necessary packages from local

## Recieve input files from bash
args <- commandArgs(TRUE)
packagelist=(args[1])
packagenames=(args[2])
packageloc=(args[3])

## Read in package list and names
r_list <- readLines(packagelist)
r_names <- readLines(packagenames)

## For loop to install packages from list
for (i in r_list){
if (is.element(i,installed.packages()[,1]) == FALSE) {
j <- paste0(packageloc,i)
install.packages(j)
}}

## For loop to check success or failure and send to log
for (i in r_names){
if (is.element(i,installed.packages()[,1]) == FALSE) {
print(paste(i,"installation FAILED!!!"))
} else {
print(paste(i,"is properly installed"))
}}

## Exit
q()
