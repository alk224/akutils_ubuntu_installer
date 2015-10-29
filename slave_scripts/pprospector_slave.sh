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

## Install primer prospector and replace python library
	pptest=`command -v analyze_primers.py 2>/dev/null | wc -l`
	if [[ $pptest == 0 ]]; then

echo "Installing Primer Prospector.
"
echo "Installing Primer Prospector." >> $log
tar -xzvf $scriptdir/pprospector-1.0.1.tar.gz -C /bin/ 1>$stdout 2>$stderr || true
cd /bin/pprospector-1.0.1/
python setup.py install --install-scripts=/bin/pprospector-1.0.1/bin/ 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stdout >> $log
echo "***** stderr:" >> $log
cat $stderr >> $log
echo "" >> $log
sed -i "s/\"$/:TARGET/" /etc/environment 1>$stdout 2>$stderr || true
sed -i "s|TARGET$|/bin/pprospector-1.0.1/scripts\"|" /etc/environment 1>$stdout 2>$stderr || true
source /etc/environment 1>$stdout 2>$stderr || true
cp $homedir/akutils/akutils_resources/analyze_primers.py /bin/pprospector-1.0.1/primerprospector/ 1>$stdout 2>$stderr || true
else
echo "Primer prospector already installed.  Skipping.
"
	fi

exit 0