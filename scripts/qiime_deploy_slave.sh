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
email="$6"
date0=`date`

## Run QIIME deploy
echo "Executing QIIME deploy script.
"
echo "Executing QIIME deploy script." >> $log
cd
python $homedir/qiime-deploy/qiime-deploy.py $homedir/qiime_1.9.1/ -f $scriptdir/docs/qiime.1.9.1.custom.conf --force-remove-failed-dirs 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
wait

exit 0
