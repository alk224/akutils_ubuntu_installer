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

## Add akutils to path
akutilstest=`command -v akutils 2>/dev/null | wc -l`
	if [[ $akutilstest == 0 ]]; then
	if [[ -d ~/akutils-v1.2 ]]; then
echo "Adding akutils repository to path (~/.bashrc).
"
echo "Adding akutils repository to path (~/.bashrc).
" >> $log
cd
cd akutils-v1.2
bash install 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
	fi
	fi
cd
source ~/.bashrc

akutilstest1=`command -v akutils 2>/dev/null | wc -l`
	if [[ $akutilstest1 -ge 1 ]]; then
	echo "akutils is in your path.
	" >> $stdout
	else
	echo "Failed to add akutils to your path.
	" >> $stderr
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
	fi

exit 0
