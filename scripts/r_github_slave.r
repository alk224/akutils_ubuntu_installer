#!/usr/bin/env Rscript

## Update R installation with necessary packages from github

## Recieve input files from bash
args <- commandArgs(TRUE)
packagelist=(args[1])

## Read in package list
r_list <- readLines(packagelist)

## For loop to install packages from list -- not flexible as written
for (i in r_list){
if (is.element(i,installed.packages()[,1]) == FALSE) {
devtools::install_github("biomformat", "joey711")
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
