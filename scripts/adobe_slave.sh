#!/usr/bin/env bash
## Install Adobe Reader slave script
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

## Test for presence of Reader and install or skip
	adobetest=`command -v acroread 2>/dev/null | wc -l` # Need to check this command
	if [[ $adobetest == 0 ]]; then
	echo "Installing Adobe Reader 9.5.
	"
	echo "Installing Adobe Reader 9.5.
	" >> $log

	## Download Reader
	cd ~/Downloads/
	wget -c http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb &>/dev/null

	## Install Reader
	export DEBIAN_FRONTEND=noninteractive
	sudo dpkg -i --force-confold --force-confdef AdbeRdr9.5.5-1_i386linux_enu.deb 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
	cd
	fi
wait

## Run apt-get -yfm install to update unmet dependencies and finish Reader install
	adobetest=`command -v acroread 2>/dev/null | wc -l` # Need to check this command
	if [[ $adobetest == 0 ]]; then
	echo "Updating dependencies via apt-get to finish Reader install.
	"
	echo "Updating dependencies via apt-get to finish Reader install.
	" >> $log
	sudo apt-get -yfm install  1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
	fi

exit 0
