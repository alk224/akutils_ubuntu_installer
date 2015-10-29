#!/usr/bin/env bash
## Install Microsoft Core Fonts slave script
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

## Install Microsoft core fonts
echo "Installing Microsoft Core Fonts.
"
echo "Installing Microsoft Core Fonts.
" >> $log
export DEBIAN_FRONTEND=noninteractive
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
apt-get -yfm install ttf-mscorefonts-installer 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stdout >> $log
echo "***** stderr:" >> $log
cat $stderr >> $log
echo "" >> $log
wait

exit 0