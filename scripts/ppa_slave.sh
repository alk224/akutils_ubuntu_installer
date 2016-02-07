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
a="0"
b="0"
c="0"
d="0"
e="0"

echo "Adding extra ppas.
"
echo "Adding extra ppas.
" >> $log

## System load indicator source
mlicount1=`grep "indicator-multiload" $scriptdir/updates/ppa_log.txt  2>/dev/null | wc -l`
mlicount2=`ls /etc/apt/sources.list.d/indicator-multiload-stable-daily*  2>/dev/null | wc -l`
if [[ $mlicount1 == 0 ]]; then
if [[ $mlicount2 == 0 ]]; then
apt-add-repository -y ppa:indicator-multiload/stable-daily 1>$stdout 2>$stderr || true
echo "Indicator mutliload ppa:
Installed on $date0" >> $log
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
echo "indicator-multiload" >> $scriptdir/updates/ppa_log.txt
a="1"
else
echo "indicator-multiload" >> $scriptdir/updates/ppa_log.txt
echo "Indicator mutliload ppa:
Installed previously." >> $log
fi
fi

## Gimp Image Editor source
ottocount1=`grep "otto-kesselgulasch-gimp" $scriptdir/updates/ppa_log.txt 2>/dev/null | wc -l`
ottocount2=`ls /etc/apt/sources.list.d/otto-kesselgulasch-gimp* 2>/dev/null | wc -l`
if [[ $ottocount1 == 0 ]]; then
if [[ $ottocount2 == 0 ]]; then
add-apt-repository -y ppa:otto-kesselgulasch/gimp 1>$stdout 2>$stderr || true
echo "Gimp ppa:
Installed on $date0" >> $log
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
echo "otto-kesselgulasch-gimp" >> $scriptdir/updates/ppa_log.txt
b="1"
else
echo "otto-kesselgulasch-gimp" >> $scriptdir/updates/ppa_log.txt
echo "Gimp ppa:
Installed previously." >> $log
fi
fi

## Systemback source
sbcount1=`grep "nemh" $scriptdir/updates/ppa_log.txt 2>/dev/null | wc -l`
sbcount2=`ls /etc/apt/sources.list.d/nemh* 2>/dev/null | wc -l`
if [[ $ottocount1 == 0 ]]; then
if [[ $ottocount2 == 0 ]]; then
add-apt-repository -y ppa:nemh/systemback 1>$stdout 2>$stderr || true
echo "Systemback ppa:
Installed on $date0" >> $log
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
echo "nemh" >> $scriptdir/updates/ppa_log.txt
c="1"
else
echo "nemh" >> $scriptdir/updates/ppa_log.txt
echo "Systemback ppa:
Installed previously." >> $log
fi
fi

## Cran R source
rppacount1=`grep "cran.rstudio.com" $scriptdir/updates/ppa_log.txt 2>/dev/null | wc -l`
rppacount2=`cat /etc/apt/sources.list | grep "cran.rstudio.com" 2>/dev/null | wc -l`
if [[ $rppacount1 == 0 ]]; then
if [[ $rppacount2 == 0 ]]; then
/bin/su -c "echo 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list"
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 1>$stdout 2>$stderr || true
echo "R (cran) ppa:
Installed on $date0" >> $log
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
echo "cran.rstudio.com" >> $scriptdir/updates/ppa_log.txt
d="1"
else
echo "cran.rstudio.com" >> $scriptdir/updates/ppa_log.txt
echo "R (cran) ppa:
Installed previously." >> $log
fi
fi

## LibreOffice update to version 5
libreppacount1=`grep "libreoffice" $scriptdir/updates/ppa_log.txt 2>/dev/null | wc -l`
libreppacount2=`cat /etc/apt/sources.list | grep "libreoffice"  2>/dev/null | wc -l`
if [[ $libreppacount1 == 0 ]]; then
if [[ $libreppacount2 == 0 ]]; then
add-apt-repository -y ppa:libreoffice/ppa
echo "LibreOffice ppa:
Installed on $date0" >> $log
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
echo "libreoffice" >> $scriptdir/updates/ppa_log.txt
e="1"
else
echo "libreoffice" >> $scriptdir/updates/ppa_log.txt
echo "LibreOffice ppa:
Installed previously." >> $log
fi
fi


## Filter ppa list if any new ppas were actually installed
installcount=`echo "$a+$b+$c+$d+$e" | bc`
if [[ $installcount -ge 1 ]]; then
echo "Filtering ppa list.
"
echo "Filtering ppa list.
" >> $log
apt-get -y update 1>$stdout 2>$stderr || true
cat /etc/apt/sources.list > /etc/apt/sources.list.backup
uniq /etc/apt/sources.list.backup > /etc/apt/sources.list
apt-get -y update 1>$stdout 2>$stderr || true
fi

exit 0
