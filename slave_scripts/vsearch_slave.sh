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
vsearchtest=`command -v vsearch 2>/dev/null | wc -l`
if [[ $vsearchtest == 0 ]]; then
echo "Installing vsearch.
"
echo "Installing vsearch." >> $log
cd $homedir/vsearch
./autogen.sh 1>$stdout 2>$stderr || true
./configure 1>$stdout 2>$stderr || true
make 1>$stdout 2>$stderr || true
wait
make install 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stdout >> $log
echo "***** stderr:" >> $log
cat $stderr >> $log
echo "" >> $log
cp $homedir/vsearch/bin/vsearch /usr/bin/
	else
echo "Vsearch already installed.  Skipping.
"
fi

exit 0