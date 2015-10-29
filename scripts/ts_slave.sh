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

## Install task spooler
	tstest=`command -v ts 2>/dev/null | wc -l`
	if [[ $tstest == 0 ]]; then

echo "Installing Task spooler.
"
echo "Installing Task spooler.
" >> $log
tar -xzvf $scriptdir/3rd_party_packages/ts-0.7.4.tar.gz -C /bin/
cd /bin/ts-0.7.4/
make 1>$stdout 2>$stderr || true
make install 1>$stdout 2>$stderr || true
cd $homedir
echo "***** stdout:" >> $log
cat $stdout >> $log
echo "***** stderr:" >> $log
cat $stderr >> $log
echo "" >> $log
wait
	else
echo "Task spooler already installed.  Skipping.
"
	fi

## Configure task spooler
		emailtest=`grep "TS_MAILTO" /etc/environment  2>/dev/null | wc -l`
		if [[ $emailtest -ge 1 ]]; then
		sed -i '/TS_MAILTO/d' /etc/environment  1>$stdout 2>$stderr || true
		fi
		/bin/su -c "echo 'TS_MAILTO="$email"' >> /etc/environment" 1>$stdout 2>$stderr || true
		/bin/su -c "echo '$host' > /etc/hostname" 1>$stdout 2>$stderr || true

		lighttest=`grep "tslight" $homedir/.bashrc  2>/dev/null | wc -l`
		if [[ $lighttest -ge 1 ]]; then
		sed -i '/tslight/d' $homedir/.bashrc 1>$stdout 2>$stderr || true
		#sed -i '/tslight/d' /etc/environment 2>/dev/null
		fi
		echo 'alias tslight="TS_SOCKET=/tmp/socket.ts.light ts"' >> $homedir/.bashrc 1>$stdout 2>$stderr || true
		#/bin/su -c "echo 'tslight -S 3' >> /etc/environment"

		heavytest=`grep "tsheavy" $homedir/.bashrc  2>/dev/null | wc -l`
		if [[ $heavytest -ge 1 ]]; then
		sed -i '/tsheavy/d' $homedir/.bashrc 1>$stdout 2>$stderr || true
		#sed -i '/tsheavy/d' /etc/environment 2>/dev/null
		fi
		echo 'alias tsheavy="TS_SOCKET=/tmp/socket.ts.heavy ts"' >> $homedir/.bashrc 1>$stdout 2>$stderr || true

exit 0
