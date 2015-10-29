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

## Install smalt
	smalttest=`command -v smalt 2>/dev/null | wc -l`
	if [[ $smalttest == 0 ]]; then

echo "Installing Smalt.
"
echo "Installing Smalt.
" >> $log
tar -xzvf $scriptdir/3rd_party_packages/smalt.tar.gz -C /bin/
smaltdir=`ls /bin/ | grep "smalt"`
cd /bin/$smaltdir/
./configure 1>$stdout 2>$stderr || true
make install 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stdout >> $log
echo "***** stderr:" >> $log
cat $stderr >> $log
echo "" >> $log
wait
cd $homedir
	else
echo "Smalt already installed.  Skipping.
"
	fi

exit 0
