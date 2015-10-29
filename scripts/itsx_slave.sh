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

## Install ITSx
	itsxtest=`command -v ITSx 2>/dev/null | wc -l`
	if [[ $itsxtest == 0 ]]; then

echo "Installing ITSx.
"
echo "Installing ITSx." >> $log
tar -xzvf $scriptdir/ITSx_1.0.11.tar.gz -C /bin/ 1>$stdout 2>$stderr || true
sed -i "s/\"$/:TARGET/" /etc/environment 1>$stdout 2>$stderr || true
sed -i "s|TARGET$|/bin/ITSx_1.0.11\"|" /etc/environment 1>$stdout 2>$stderr || true
	if [[ -f /bin/ITSx_1.0.11/ITSx_db/HMMs/N.hmm ]]; then
	echo "Fresh hmmpress of ITSx hmm files.
	"
	rm /bin/ITSx_1.0.11/ITSx_db/HMMs/N.hmm 1>$stdout 2>$stderr || true
	fi
	# Fresh hmmpress of ITSx hmm files
	for hmm in `ls /bin/ITSx_1.0.11/ITSx_db/HMMs/*.hmm`; do
		hmmpress -f $hmm 1>$stdout 2>$stderr || true
	done
wait
cd $homedir
	else
echo "ITSx already installed.  Skipping.
"
	fi

exit 0