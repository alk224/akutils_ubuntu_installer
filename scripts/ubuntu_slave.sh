#!/usr/bin/env bash
## Install from Ubuntu repositories slave script
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

echo "Installing programs from repositories.
"
echo "Installing programs from repositories.
" >> $log
	apt-get clean &>/dev/null
	apt-get update &>/dev/null

## Set installation to noninteractive
	export DEBIAN_FRONTEND=noninteractive

## Install system load indicator if not present
	mlindictest=`command -v indicator-multiload 2>/dev/null | wc -l`
	if [[ $mlindictest == 0 ]]; then
	echo "Installing multiload indicator.
	" >> $log
	apt-get -yfm install indicator-multiload 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
	else
	echo "Multiload indicator already installed.  Skipping.
	" >> $log
	fi
wait

## Remove R if version is not 3.2.3
	rtest=$(command -v R 2>/dev/null | wc -l)
	if [[ "$rtest" -ge "1" ]]; then
	rversion=$(R --version 2>/dev/null | head -1 | cut -d" " -f3)
	if [[ "$rversion" != "3.2.3" ]]; then
	echo "R is incorrect version ($rversion), should be 3.2.3.
Uninstalling existing R packages.
	"
	echo "R is incorrect version ($rversion), should be 3.2.3.
Uninstalling existing R packages.
	" >> $log
	sudo rm -r /usr/lib/R/site-library/ 2>/dev/null
	dpkg -l | awk '$2 ~ /^r-/ { print $2 }' | xargs sudo dpkg --remove 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
		echo "2013,12,31" > $scriptdir/updates/R_installs_and_updates.txt
	fi
	fi

## Install R, enforcing v3.2.3
	rtest=$(command -v R 2>/dev/null | wc -l)
	if [[ "$rtest" -ge "0" ]]; then
	echo "Installing R v3.2.3 via apt-get.
	"
	echo "Installing R v3.2.3 via apt-get.
	" >> $log
	apt-get -y --force-yes install r-base-core=3.2.3-1trusty0 r-base-dev=3.2.3-1trusty0 1>$stdout 2>$stderr || true 
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
	sudo apt-mark hold r-base-core r-base-dev >> $log
		echo "2013,12,31" > $scriptdir/updates/R_installs_and_updates.txt
	fi

## Install other programs via apt-get
	echo "Installing all other programs via apt-get.
	" >> $log
	apt-get update &>/dev/null
	apt-get -yfm --force-yes install htop fail2ban gawk openssh-server gimp gimp-data gimp-plugin-registry gimp-data-extras gimp-help-en veusz clementine build-essential python-dev python-pip perl zip unzip synaptic git gpart gparted libfreetype6-dev ghc gcc g++ h5utils hdf5-tools r-cran-xml samtools mafft fastx-toolkit bedtools bowtie2 tophat cufflinks picard-tools abyss arb fastqc velvet staden-io-lib-utils ugene ugene-data seaview treeview treeviewx subversion zlib1g-dev libgsl0-dev libgtk2.0-0:i386 libnss3-1d:i386 libnspr4-0d:i386 lib32nss-mdns libxml2:i386 libxslt1.1:i386 libstdc++6:i386 cmake libncurses5-dev libssl-dev libzmq-dev libxml2 libxslt1.1 libxslt1-dev ant zlib1g-dev libpng12-dev mpich2 libreadline-dev gfortran libmysqlclient18 libmysqlclient-dev sqlite3 libsqlite3-dev libc6-i386 libbz2-dev tcl-dev tk-dev libatlas-dev libatlas-base-dev liblapack-dev swig libhdf5-serial-dev filezilla libcurl4-openssl-dev libxml2-dev openjdk-7-jdk sendmail mysql-server php5 apache2 php-mdb2 php-mdb2-driver-mysql libdbd-mysql-perl libbam-dev nfs-common nfs-kernel-server mdadm screen autoconf autogen intltool libjpeg62 preload dstat jags curl libreoffice xclip fasttree libtre-dev libtre5 plink rdesktop php5-mysqlnd mysql-client libspreadsheet-writeexcel-perl --quiet 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
wait

## Remove anything unneeded
sudo apt-get -y autoremove
#echo "
#stdout"
#cat $stdout
#echo "
#stderr"
#cat $stderr
exit 0
