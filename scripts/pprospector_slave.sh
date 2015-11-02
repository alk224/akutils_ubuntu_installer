#!/usr/bin/env bash
## Add extra ppas slave script
## Author: Andrew Krohn
## Date: 2015-10-28
## License: MIT
## Version 0.0.1
#set -e

## Define variables from inputs
stdout="$1"
stderr="$2"
log="$3"
homedir="$4"
scriptdir="$5"
email="$6"
date0=`date`

## Install primer prospector and replace python library
	pptest=`ls $homedir/qiime_1.9.1/pprospector-1.0.1-release/lib/python2.7/site-packages/primerprospector/analyze_primers.py 2>/dev/null | wc -l`
	if [[ $pptest == 1 ]]; then
## Check md5sums of existing and corrected libraries and replace if necessary
	md5existing=`md5sum $homedir/qiime_1.9.1/pprospector-1.0.1-release/lib/python2.7/site-packages/primerprospector/analyze_primers.py | cut -f1 -d" " 2>/dev/null`
	md5correct=`md5sum $homedir/akutils/akutils_resources/analyze_primers.py | cut -f1 -d" " 2>/dev/null`
	echo "Checking analyze_primers.py library file.
	"
	echo "Checking analyze_primers.py library file.
md5sum existing file: $md5existing
md5sum corrected file: $md5correct"
	if [[ "$md5existing" != "$md5correct" ]]; then
	echo "md5sums do not match.  Replacing existing file.
	"

## Replace old python library for analyze_primers.py script
	cp $homedir/akutils/akutils_resources/analyze_primers.py $homedir/qiime_1.9.1/pprospector-1.0.1-release/lib/python2.7/site-packages/primerprospector/analyze_primers.py 1>$stdout 2>$stderr

	else
	echo "md5sums match.  No changes made.
	"
	fi

	else
	echo "analyze_primers.py not where expected.  Python library not corrected.
	"
	fi

exit 0
