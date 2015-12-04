#!/usr/bin/env bash
## Add extra ppas slave script
## Author: Andrew Krohn
## Date: 2015-10-28
## License: MIT
## Version 0.0.1
set -e

## Define variables from inputs
stdout="$1"
stderr="$2"
log="$3"
homedir="$4"
scriptdir="$5"
date0=`date`

## Install vsearch
rstudiotest=`command -v rstudio 2>/dev/null | wc -l`
if [[ $rstudiotest == 0 ]]; then
echo "Installing Rstudio.
"
echo "Installing Rstudio." >> $log
cd $homedir/Downloads/
wget http://download1.rstudio.org/rstudio-0.99.489-amd64.deb 1>$stdout 2>$stderr || true
wait
dpkg -i rstudio-0.99.489-amd64.deb 1>$stdout 2>$stderr || true
wait

	else
echo "Rstudio already installed.  Skipping.
"
fi

exit 0
