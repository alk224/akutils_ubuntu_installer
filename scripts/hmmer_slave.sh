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

## Install HMMER
	hmmertest=`command -v hmmsearch 2>/dev/null | wc -l`
	if [[ $hmmertest == 0 ]]; then

echo "Installing HMMer
"
echo "Installing HMMer" >> $log
tar -xzvf $scriptdir/3rd_party_packages/hmmer-3.1b2-linux-intel-x86_64.tar.gz -C /bin/ 1>$stdout 2>$stderr || true
cd /bin/hmmer-3.1b2-linux-intel-x86_64/
./configure 1>$stdout 2>$stderr || true
make 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
wait
cd $homedir
bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
	else
echo "HMMer already installed.  Skipping.
"
	fi

exit 0
