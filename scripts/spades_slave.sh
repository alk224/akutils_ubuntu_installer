#!/usr/bin/env bash
## Install spades slave script
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

## Install spades v3.6.2
	spadestest=`command -v fastq-mcf 2>/dev/null | wc -l`
	if [[ $spadestest == 0 ]]; then

echo "Installing SPAdes v3.6.2.
"
echo "Installing SPAdes v3.6.2.
" >> $log
	if [[ ! -f "$homedir/Downloads/SPAdes-3.6.2.tar.gz" ]]; then
	echo "Downloading SPAdes v3.6.2.
" >> $log
wget -O $homedir/Downloads/SPAdes-3.6.2-Linux.tar.gz http://spades.bioinf.spbau.ru/release3.6.2/SPAdes-3.6.2-Linux.tar.gz 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
wait
	fi

	echo "Installing SPAdes v3.6.2.
" >> $log
tar -xzvf $homedr/Downloads/SPAdes-3.6.2-Linux.tar.gz -C /bin/  1>$stdout 2>$stderr || true
sed -i "s/\"$/:TARGET/" /etc/environment 1>$stdout 2>$stderr || true
sed -i "s|TARGET$|/bin/SPAdes-3.6.2-Linux/bin\"|" /etc/environment 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
wait
	else
echo "SPAdes already installed.  Skipping.
"
	fi

exit 0
