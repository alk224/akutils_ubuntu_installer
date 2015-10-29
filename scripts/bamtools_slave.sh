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

## Install bamtools
bamtoolstest=`command -v bamtools 2>/dev/null | wc -l`
if [[ $bamtoolstest == 0 ]]; then
echo "Installing bamtools.
"
echo "Installing bamtools." >> $log
cd $homedir/bamtools
mkdir build 1>$stdout 2>$stderr || true
cd build
cmake 1>$stdout 2>$stderr || true
make 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
wait
cd
	else
echo "Bamtools already installed.  Skipping.
"
fi

exit 0
