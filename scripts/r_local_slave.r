#!/usr/bin/env Rscript

## Update R installation with necessary packages from local

## Recieve input files from bash
args <- commandArgs(TRUE)
packagelist=(args[1])
packageloc=(args[2])

## Read in package list
r_list <- readLines(packagelist)

## For loop to install packages from list
for (i in r_list){
if (is.element(i,installed.packages()[,1]) == FALSE) {
j <- paste0(packageloc,i)
install.packages(j)
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
