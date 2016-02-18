#!/usr/bin/env bash
## datamash slave script
## Author: Andrew Krohn
## Date: 2016-02-18
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
repodir=$(dirname $scriptdir)

## Install bamtools
datamashtest=`command -v datamash 2>/dev/null | wc -l`
	if [[ $datamashtest == 0 ]]; then
echo "Installing datamash.
"
echo "Installing datamash." >> $log
dpkg -i $repodir/3rd_party_packages/datamash_1.0.6-1_amd64.deb 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
wait
	else
echo "datamash already installed.  Skipping.
"
fi
exit 0
