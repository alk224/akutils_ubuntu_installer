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

echo "Cleaning up Ubuntu packages.
"
echo "Cleaning up Ubuntu packages.
" >> $log
sudo apt-get -f install 1>$stdout 2>$stderr || true
sudo apt-get -y autoremove 1>$stdout 2>$stderr || true
sudo apt-get -y autoclean 1>$stdout 2>$stderr || true
sudo apt-get -y clean 1>$stdout 2>$stderr || true
wait

exit 0