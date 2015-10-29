#!/usr/bin/env bash
## Chrome install slave script
## Author: Andrew Krohn
## Date: 2015-10-28
## License: MIT
## Version 0.0.1

## Define variables from inputs
stdout="$1"
stderr="$2"
log="$3"
homedir="$4"
scriptdir="$5"

## Install dependencies first via apt-get
echo "Installing dependencies for Google Chrome install.
"
echo "Installing dependencies for Google Chrome install.
" >> $log
	apt-get -y install libxss1 libappindicator1 libindicator7 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
wait

## Download latest stable Chrome
echo "Downloading Google Chrome.
"
echo "Downloading Google Chrome.
" >> $log
	if [[ -f $homedir/Downloads/google-chrome*.deb ]]; then
	rm $homedir/Downloads/google-chrome*.deb 1>$stdout 2>$stderr || true
	fi
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P $homedir/Downloads/ 1>$stdout 2>$stderr || true
wait

## Install Chrome with dpkg
echo "Installing Google Chrome.
"
echo "Installing Google Chrome.
" >> $log
	dpkg -i $homedir/Downloads/google-chrome*.deb 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
wait
exit 0
