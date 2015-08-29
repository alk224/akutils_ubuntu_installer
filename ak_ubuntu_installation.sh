#!/usr/bin/env bash
## Script to install my favorite programs in Ubuntu
## Should be run from home directory
## Author: Andrew Krohn
## Date: 2015-08-29
## License: MIT
## Version: 0.0.1
set -e
homedir=`pwd`
scriptdir="$( cd "$( dirname "$0" )" && pwd )"

## Check whether user supplied install argument.  Otherwise display help.
	if [[ "$1" != "install" ]] && [[ "$1" != "list" ]]; then
echo "
ak_ubuntu_installation script (v0.0.1), 2015-08-29.  Script to facilitate
installation of my favorite useful bioinformatics packages on a bare Ubuntu
14.04 LTS install.  Tested on no other distros.

The script will initially ask for brief input.  If you make a mistake,
hit <ctrl-C> and start over.

There are a few items in the middle of the install that also require user
input.  The installation should resume once input is provided.

Usage:
   ./ak_ubuntu_installer/ak_ubuntu_installation.sh (this help screen)
   ./ak_ubuntu_installer/ak_ubuntu_installation.sh list (list of software)
   sudo ./ak_ubuntu_installer/ak_ubuntu_installation.sh install (installation)
"
	exit 0
	fi

## Check whether user supplied list argument.
	if [[ "$1" == "list" ]]; then
	less $scriptdir/software_list
	exit 0
	fi

## Initial dialogue
echo "
Starting ak_ubuntu_installer.sh

You can cancel during this initial dialogue with <ctrl-C>
"
sleep 1
echo "Enter your email address (to configure task spooler):
"
read email
echo "Enter your computers hostname if it has one.
Example: enggen.bio.nau.edu
Just hit enter if you don't have one.
"
read host

## Install Google Chrome
## Test for install
	chrometest=`command -v google-chrome 2>/dev/null | wc -l`
	if [[ $chrometest == 0 ]]; then

## Install if test failed
echo "Installing dependencies for Google Chrome install.
"
	apt-get install libxss1 libappindicator1 libindicator7
wait
echo "Downloading Google Chrome.
"
	if [[ -f $homedir/Downloads/google-chrome*.deb ]]; then
	rm $homedir/Downloads/google-chrome*.deb
	fi
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P $homedir/Downloads/
wait
echo "Installing Google Chrome.
"
	dpkg -i $homedir/Downloads/google-chrome*.deb
wait

else
echo "Google Chrome is already installed.  Skipping.
"
	fi
wait

## Add additional ppas
echo "Adding extra ppas.
"
apt-add-repository -y ppa:indicator-multiload/stable-daily
add-apt-repository -y ppa:otto-kesselgulasch/gimp
add-apt-repository "deb http://archive.canonical.com/ precise partner"
add-apt-repository -y ppa:webupd8team/y-ppa-manager
apt-get -y update
cat /etc/apt/sources.list > /etc/apt/sources.list.backup
uniq /etc/apt/sources.list.backup > /etc/apt/sources.list
apt-get -y update
wait

## Download special programs
#echo "Downloading special programs.
#"
#
#	ITSxcount=`ls $homedir/Downloads/ITSx_*.gz | wc -l`
#	if [[ $ITSxcount == 0 ]]; then
#	wget http://microbiology.se/sw/ITSx_1.0.11.tar.gz -P $homedir/Downloads/
#	fi
#
#	smaltcount=`ls $homedir/Downloads/smalt*.gz | wc -l`
#	if [[ $smaltcount == 0 ]]; then
#	wget http://sourceforge.net/projects/smalt/files/latest/download -P $homedir/Downloads/
#	mv $homedir/Downloads/download $homedir/Downloads/smalt.tar.gz
#	fi
#
#	hmmcount=`ls $homedir/Downloads/hmmer-3.1b2*.gz | wc -l`
#	if [[ $hmmcount == 0 ]]; then
#	wget http://selab.janelia.org/software/hmmer3/3.1b2/hmmer-3.1b2-linux-intel-x86_64.tar.gz -P $homedir/Downloads/
#	fi
#
#	tscount=`ls $homedir/Downloads/ts-0.7.4*.gz | wc -l`
#	if [[ $tscount == 0 ]]; then
#	wget http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.7.4.tar.gz -P $homedir/Downloads/
#	fi
#wait

## Install programs from Ubuntu repositories
echo "Installing programs from repositories.
"
apt-get -y install fail2ban openssh-server gimp gimp-data gimp-plugin-registry gimp-data-extras gimp-help-en veusz clementine build-essential python-dev python-pip perl zip unzip synaptic y-ppa-manager git gpart gparted indicator-multiload libfreetype6-dev ttf-mscorefonts-installer ghc gcc g++ htop acroread h5utils hdf5-tools r-base r-base-core r-base-dev r-bioc-biocinstaller samtools mafft fastx-toolkit bedtools bowtie2 tophat bwa cufflinks picard-tools abyss arb fastqc velvet staden-io-lib-utils ugene ugene-data seaview treeview treeviewx subversion zlib1g-dev libgsl0-dev cmake libncurses5-dev libssl-dev libzmq-dev libxml2 libxslt1.1 libxslt1-dev ant zlib1g-dev libpng12-dev mpich2 libreadline-dev gfortran libmysqlclient18 libmysqlclient-dev sqlite3 libsqlite3-dev libc6-i386 libbz2-dev tcl-dev tk-dev libatlas-dev libatlas-base-dev liblapack-dev swig libhdf5-serial-dev
wait

echo "Cleaning up ubuntu packages.
"
sudo apt-get -f install
sudo apt-get -y autoremove
sudo apt-get -y autoclean
sudo apt-get -y clean
wait

## Remove precise repository
add-apt-repository -r "deb http://archive.canonical.com/ precise partner"
apt-get -y update

## Clone github repositories
echo "Cloning github repositories.
"
if [[ ! -d $homedir/akutils ]]; then
git clone https://github.com/alk224/akutils.git
fi
if [[ ! -d $homedir/vsearch ]]; then
git clone https://github.com/torognes/vsearch.git
fi
if [[ ! -d $homedir/bamtools ]]; then
git clone git://github.com/pezmaster31/bamtools.git
fi
wait

## Add akutils to path
echo "Adding akutils repository to path (/etc/environment).
"
sed -i "s/\"$/:TARGET/" /etc/environment
sed -i "s|TARGET$|$homedir/akutils\"|" /etc/environment
source /etc/environment

## Install vsearch
	vsearchtest=`command -v vsearch 2>/dev/null | wc -l`
	if [[ $vsearchtest == 0]]; then
echo "Installing vsearch.
"
cd $homedir/vsearch/src
make -f Makefile
wait
cd $homedir
cp $homedir/vsearch/src/vsearch /bin/
	else
echo "Vsearch already installed.  Skipping.
"
	fi

## Install bamtools
	bamtoolstest=`command -v vsearch 2>/dev/null | wc -l`
	if [[ $bamtoolstest == 0]]; then
echo "Installing Bamtools.
"
cd $homedir/bamtools/
mkdir build
cd build
cmake ..
make
wait
cd $homedir
sed -i "s/\"$/:TARGET/" /etc/environment
sed -i "s|TARGET$|$homedir/bamtools/bin\"|" /etc/environment
source /etc/environment
	else
echo "Bamtools already installed.  Skipping.
"
	fi

## Install HMMER
	hmmertest=`command -v hmmsearch 2>/dev/null | wc -l`
	if [[ $hmmertest == 0]]; then
echo "Installing HMMer
"
tar -xzvf $scriptdir/hmmer-3.1b2-linux-intel-x86_64.tar.gz -C /bin/
cd /bin/hmmer-3.1b2-linux-intel-x86_64/
./configure
make
wait
cd $homedir
	else
echo "HMMer already installed.  Skipping.
"
	fi

## Install ITSx
	itsxtest=`command -v ITSx 2>/dev/null | wc -l`
	if [[ $itsxtest == 0]]; then
echo "Installing ITSx.
"
tar -xzvf $scriptdir/ITSx_1.0.11.tar.gz -C /bin/ 2>/dev/null
sed -i "s/\"$/:TARGET/" /etc/environment
sed -i "s|TARGET$|/bin/ITSx_1.0.11\"|" /etc/environment
source /etc/environment
	# Fresh hmmpress of ITSx hmm files
	for hmm in `ls /bin/ITSx_1.0.11/ITSx_db/HMMs/*.hmm`; do
		hmmpress -f $hmm
	done
wait
cd $homedir
	else
echo "ITSx already installed.  Skipping.
"
	fi

## Install smalt
	smalttest=`command -v smalt 2>/dev/null | wc -l`
	if [[ $smalttest == 0]]; then
echo "Installing Smalt.
"
tar -xzvf $scriptdir/smalt.tar.gz -C /bin/
smaltdir=`ls /bin/ | grep "smalt"`
cd /bin/$smaltdir/
./configure
make install
wait
cd $homedir
	else
echo "Smalt already installed.  Skipping.
"
	fi

## Install ea-utils
	eautilstest=`command -v fastq-mcf 2>/dev/null | wc -l`
	if [[ $eautilstest == 0]]; then
echo "Installing ea-utils.
"
tar -xzvf $scriptdir/ea-utils.1.1.2-806.tar.gz -C /bin/
cd /bin/ea-utils.1.1.2-806/
make install
wait
	else
echo "ea-utils already installed.  Skipping.
"
	fi

## Install task spooler
	tstest=`command -v ts 2>/dev/null | wc -l`
	if [[ $tstest == 0]]; then
echo "Installing Task spooler.
"
tar -xzvf $scriptdir/ts-0.7.4.tar.gz -C /bin/
cd /bin/ts-0.7.4/
make
make install
wait
cd $homedir
		emailtest=`grep "TS_MAILTO" /etc/environment | wc -l`
		if [[ $emailtest == 1 ]]; then
		sed -i '/TS_MAILTO/d' /etc/environment
		fi
		lighttest=`grep "tslight" $homedir/.bashrc | wc -l`
		if [[ $lighttest == 1 ]]; then
		sed -i '/tslight/d' $homedir/.bashrc
		fi
		heavytest=`grep "tsheavy" $homedir/.bashrc | wc -l`
		if [[ $heavytest == 1 ]]; then
		sed -i '/tsheavy/d' $homedir/.bashrc
		fi

/bin/su -c "echo 'TS_MAILTO="$email"' >> /etc/environment"
/bin/su -c "echo 'tsheavy -S 1' >> /etc/environment"
/bin/su -c "echo 'tslight -S 3' >> /etc/environment"
/bin/su -c "echo '$host' > /etc/hostname"
/bin/su -c "echo 'alias tsheavy="TS_SOCKET=/tmp/socket.ts.heavy ts"' >> $homedir/.bashrc"
/bin/su -c "echo 'alias tslight="TS_SOCKET=/tmp/socket.ts.light ts"' >> $homedir/.bashrc"
	else
echo "Task spooler already installed.  Skipping.
"
	fi

## Upgrading pip
echo "Upgrading pip version."
pip install pip --upgrade pip
wait

## Install numpy
echo "Installing Numpy.
"
pip install numpy==1.9.1
wait

## Install scipy
echo "Installing Scipy.
"
pip install scipy==0.15.1
wait

## Install matplotlib
echo "Installing Matplotlib.
"
pip install matplotlib==1.3.1
wait

## Install Cython
echo "Installing Cython.
"
pip install Cython

## Install h5py
echo "Installing h5py.
"
pip install h5py==2.4.0
wait

## Install QIIME base
echo "Installing QIIME.
"
pip install qiime==1.9.1
wait

## Install primer prospector and correct the analyze primers library
tar -xzvf $scriptdir/pprospector-1.0.1.tar.gz -C /bin/
cd /bin/pprospector-1.0.1/
python setup.py install --install-scripts=/bin/pprospector-1.0.1/bin/
sed -i "s/\"$/:TARGET/" /etc/environment
sed -i "s|TARGET$|/bin/pprospector-1.0.1/bin\"|" /etc/environment
source /etc/environment
cp akutils/akutils_resources/analyze_primers.py /bin/pprospector-1.0.1/primerprospector/

## Run QIIME deploy
/bin/su -c "echo 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list"
apt-get -y update
$scriptdir/r_updates.r
wait
if [[ ! -d $homedir/qiime-deploy ]]; then
rm -r $homedir/qiime-deploy
fi
if [[ ! -d $homedir/qiime-deploy-conf ]]; then
rm -r qiime-deploy-conf
fi
git clone https://github.com/qiime/qiime-deploy.git
git clone git://github.com/qiime/qiime-deploy-conf.git
wait
cd qiime-deploy/
python qiime-deploy.py $homedir/qiime_software/ -f $homedir/qiime-deploy-conf/qiime-1.9.1/qiime.conf --force-remove-failed-dirs
wait
source $homedir/.bashrc
print_qiime_config.py -tf

## Report on installations
echo "
Installations complete (hopefully).

Open the dash (super key) and search for \"System Load Monitor.\"
Start that program and you will see a small load icon appear in the
upper left screen on the status bar.  Right click and choose
\"Preferences.\"  Select all of the Monitored Resources options
and choose your favorite color scheme (I like Traditional).  I also
like to expand the monitor width to 150 pixels, but this will depend
on your available monitor space.

Check your QIIME installation with print_qiime_config.py
If there are any issues, resolve them via the QIIME forum.  You
should have all the tools you need to fix any problems that arise.

Then reboot your system.
"

exit 0
