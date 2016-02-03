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
fqgrep=`command -v akutils_config_utility.sh 2>/dev/null | wc -l`
	if [[ $fqgreptest == 0 ]]; then
	if [[ -d ~/fqgrep ]]; then
echo "Installing fqgrep.
"
echo "Installing fqgrep.
" >> $log
cd 
cd fqgrep
make
cd
cp fqgrep/fqgrep /usr/local/bin/
	fi
	fi
source ~/.bashrc

fqgreptest1=`command -v akutils_config_utility.sh 2>/dev/null | wc -l`
	if [[ $fqgreptest1 -ge 1 ]]; then
	echo "fqgrep is in your path.
	" >> $stdout
	else
	echo "Failed to add fqgrep to your path.
	" >> $stderr
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
	fi

exit 0
