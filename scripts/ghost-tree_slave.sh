#!/usr/bin/env bash
## Install ghost-tree slave script
## Author: Andrew Krohn
## Date: 2016-02-01
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

## Install ghost-tree
ghosttreetest=`command -v ghost-tree 2>/dev/null | wc -l`
	if [[ $ghosttreetest == 0 ]]; then
echo "Installing ghost-tree.
"
echo "Installing ghost-tree." >> $log
cd $homedir/ghost-tree
pip install -e ./  1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
wait
cd
	else
echo "ghost-tree already installed.  Skipping.
"
fi

exit 0
