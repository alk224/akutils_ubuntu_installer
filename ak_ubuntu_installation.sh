#!/usr/bin/env bash
## Script to install my favorite programs in Ubuntu
## Should be run from home directory
## Author: Andrew Krohn
## Date: 2015-08-29
## License: MIT
## Version: 0.0.1
#set -e
userid=`echo $SUDO_USER`
homedir=(/home/$userid/)
scriptdir="$( cd "$( dirname "$0" )" && pwd )"

## Check whether user supplied install argument.  Otherwise display help.
	if [[ "$1" != "install" ]] && [[ "$1" != "list" ]] && [[ "$1" != "test" ]]; then
echo "
ak_ubuntu_installation script (v0.0.1), 2015-08-29.  Script to facilitate
installation of my favorite useful bioinformatics packages on a bare Ubuntu
14.04 LTS install.  Tested on no other distros.

The script will initially ask for brief input.  If you make a mistake,
hit <ctrl-C> and start over.

There are a few items in the middle of the install that also require user
input.  The installation should resume once input is provided.

Usage:
   bash ak_ubuntu_installer/ak_ubuntu_installation.sh (this help screen)
   bash ak_ubuntu_installer/ak_ubuntu_installation.sh list (list of software)
   bash ak_ubuntu_installer/ak_ubuntu_installation.sh test (test of installed software)
   sudo bash ak_ubuntu_installer/ak_ubuntu_installation.sh install (installation)
"
	exit 0
	fi

## Check whether user supplied list argument.
	if [[ "$1" == "list" ]]; then
	less $scriptdir/software_list
	exit 0
	fi

## Check whether user supplied test argument.
	if [[ "$1" == "test" ]]; then
	bash $scriptdir/ak_ubuntu_QIIME_test.sh
	exit 0
	fi

## Check for sudo power
	if [[ $EUID != 0 ]]; then
	echo "This command must be executed as root (or sudo)."
	exit 0
	fi

## Initial dialogue
echo "
***** Starting ak_ubuntu_installer.sh *****

You can cancel during this initial dialogue with <ctrl-C>

Enter your email address (to configure task spooler):
"
read email
echo "
Enter your computers hostname if it has one.
Example: enggen.bio.nau.edu
Just hit enter if you don't have one.
"
read host
echo ""

## Install Google Chrome
## Test for install
	chrometest=`command -v google-chrome 2>/dev/null | wc -l`
	if [[ $chrometest == 0 ]]; then

## Install if test failed
echo "Installing dependencies for Google Chrome install.
"
	apt-get -y install libxss1 libappindicator1 libindicator7
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
mlicount=`ls /etc/apt/sources.list.d/indicator-multiload-stable-daily*  2>/dev/null | wc -l`
if [[ $mlicount == 0 ]]; then
apt-add-repository -y ppa:indicator-multiload/stable-daily
fi
ottocount=`ls /etc/apt/sources.list.d/otto-kesselgulasch-gimp*  2>/dev/null | wc -l`
if [[ $ottocount == 0 ]]; then
add-apt-repository -y ppa:otto-kesselgulasch/gimp
fi
rppacount=`cat /etc/apt/sources.list | grep "cran.rstudio.com"  2>/dev/null | wc -l`
if [[ $rppacount == 0 ]]; then
/bin/su -c "echo 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list"
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
fi
add-apt-repository "deb http://archive.canonical.com/ precise partner"
yppacount=`ls /etc/apt/sources.list.d/webupd8team-y-ppa-manager*  2>/dev/null | wc -l`
if [[ $yppacount == 0 ]]; then
add-apt-repository -y ppa:webupd8team/y-ppa-manager
fi
apt-get -y update
cat /etc/apt/sources.list > /etc/apt/sources.list.backup
uniq /etc/apt/sources.list.backup > /etc/apt/sources.list
apt-get -y update
wait

## Download special programs
#echo "Downloading special programs.
#"
#
#	ITSxcount=`ls $homedir/Downloads/ITSx_*.gz  2>/dev/null | wc -l`
#	if [[ $ITSxcount == 0 ]]; then
#	wget http://microbiology.se/sw/ITSx_1.0.11.tar.gz -P $homedir/Downloads/
#	fi
#
#	smaltcount=`ls $homedir/Downloads/smalt*.gz  2>/dev/null | wc -l`
#	if [[ $smaltcount == 0 ]]; then
#	wget http://sourceforge.net/projects/smalt/files/latest/download -P $homedir/Downloads/
#	mv $homedir/Downloads/download $homedir/Downloads/smalt.tar.gz
#	fi
#
#	hmmcount=`ls $homedir/Downloads/hmmer-3.1b2*.gz  2>/dev/null | wc -l`
#	if [[ $hmmcount == 0 ]]; then
#	wget http://selab.janelia.org/software/hmmer3/3.1b2/hmmer-3.1b2-linux-intel-x86_64.tar.gz -P $homedir/Downloads/
#	fi
#
#	tscount=`ls $homedir/Downloads/ts-0.7.4*.gz  2>/dev/null | wc -l`
#	if [[ $tscount == 0 ]]; then
#	wget http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.7.4.tar.gz -P $homedir/Downloads/
#	fi
#wait

## Install programs from Ubuntu repositories
echo "Installing programs from repositories.
"
export DEBIAN_FRONTEND=noninteractive
apt-get -y install fail2ban openssh-server gimp gimp-data gimp-plugin-registry gimp-data-extras gimp-help-en veusz clementine build-essential python-dev python-pip perl zip unzip synaptic y-ppa-manager git gpart gparted indicator-multiload libfreetype6-dev ghc gcc g++ htop acroread h5utils hdf5-tools r-base r-base-core r-base-dev r-cran-xml samtools mafft fastx-toolkit bedtools bowtie2 tophat cufflinks picard-tools abyss arb fastqc velvet staden-io-lib-utils ugene ugene-data seaview treeview treeviewx subversion zlib1g-dev libgsl0-dev cmake libncurses5-dev libssl-dev libzmq-dev libxml2 libxslt1.1 libxslt1-dev ant zlib1g-dev libpng12-dev mpich2 libreadline-dev gfortran libmysqlclient18 libmysqlclient-dev sqlite3 libsqlite3-dev libc6-i386 libbz2-dev tcl-dev tk-dev libatlas-dev libatlas-base-dev liblapack-dev swig libhdf5-serial-dev filezilla libcurl4-openssl-dev libxml2-dev openjdk-7-jdk --quiet
wait

## Install microsoft core fonts
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
apt-get -y install ttf-mscorefonts-installer
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
sudo -u $userid git clone https://github.com/alk224/akutils.git #2>/dev/null
#chown -R $userid:$userid $homedir/akutils
fi
if [[ ! -d $homedir/vsearch ]]; then
sudo -u $userid git clone https://github.com/torognes/vsearch.git #2>/dev/null
#chown -R $userid:$userid $homedir/vsearch
fi
if [[ ! -d $homedir/bamtools ]]; then
sudo -u $userid git clone git://github.com/pezmaster31/bamtools.git #2>/dev/null
#chown -R $userid:$userid $homedir/bamtools
fi
wait
if [[ ! -d $homedir/QIIME_test_data_16S ]]; then
sudo -u $userid git clone https://github.com/alk224/QIIME_test_data_16S.git #2>/dev/null
#chown -R $userid:$userid $homedir/QIIME_test_data_16S
fi

## Add akutils to path
akutilstest=`grep "$homedir/akutils" /etc/environment 2>/dev/null | wc -l`
	if [[ $akutilstest == 0 ]]; then
echo "Adding akutils repository to path (/etc/environment).
"
sed -i "s/\"$/:TARGET/" /etc/environment
sed -i "s|TARGET$|$homedir/akutils\"|" /etc/environment
	fi
source /etc/environment

## Install vsearch
	vsearchtest=`command -v vsearch 2>/dev/null | wc -l`
	if [[ $vsearchtest == 0 ]]; then
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
	bamtoolstest=`command -v bamtools 2>/dev/null | wc -l`
	if [[ $bamtoolstest == 0 ]]; then
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
	if [[ $hmmertest == 0 ]]; then
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
	if [[ $itsxtest == 0 ]]; then
echo "Installing ITSx.
"
tar -xzvf $scriptdir/ITSx_1.0.11.tar.gz -C /bin/ 2>/dev/null
sed -i "s/\"$/:TARGET/" /etc/environment
sed -i "s|TARGET$|/bin/ITSx_1.0.11\"|" /etc/environment
source /etc/environment
	if [[ -f /bin/ITSx_1.0.11/ITSx_db/HMMs/N.hmm ]]; then
	rm /bin/ITSx_1.0.11/ITSx_db/HMMs/N.hmm
	fi
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
	if [[ $smalttest == 0 ]]; then
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
	if [[ $eautilstest == 0 ]]; then
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
	if [[ $tstest == 0 ]]; then
echo "Installing Task spooler.
"
tar -xzvf $scriptdir/ts-0.7.4.tar.gz -C /bin/
cd /bin/ts-0.7.4/
make
make install
cd $homedir
wait
	else
echo "Task spooler already installed.  Skipping.
"
	fi

## Configure task spooler
		emailtest=`grep "TS_MAILTO" /etc/environment  2>/dev/null | wc -l`
		if [[ $emailtest == 1 ]]; then
		sed -i '/TS_MAILTO/d' /etc/environment
		/bin/su -c "echo 'TS_MAILTO="$email"' >> /etc/environment"
		/bin/su -c "echo '$host' > /etc/hostname"
		fi
		lighttest=`grep "tslight" $homedir/.bashrc  2>/dev/null | wc -l`
		if [[ $lighttest == 1 ]]; then
		sed -i '/tslight/d' $homedir/.bashrc
		/bin/su -c "echo 'alias tslight="TS_SOCKET=/tmp/socket.ts.light ts"' >> $homedir/.bashrc"
		/bin/su -c "echo 'tslight -S 3' >> /etc/environment"
		fi
		heavytest=`grep "tsheavy" $homedir/.bashrc  2>/dev/null | wc -l`
		if [[ $heavytest == 1 ]]; then
		sed -i '/tsheavy/d' $homedir/.bashrc
		/bin/su -c "echo 'alias tsheavy="TS_SOCKET=/tmp/socket.ts.heavy ts"' >> $homedir/.bashrc"
		/bin/su -c "echo 'tsheavy -S 1' >> /etc/environment"
		fi
source ~/.bashrc
source /etc/environment

## Upgrading pip
pipver=`python -c "import pip; print pip.__version__" 2>/dev/null`
if [[ $pipver != 7.1.2 ]]; then
echo "Installing pip v7.1.2."
pip install pip==7.1.2
wait
else
echo "Pip already correct version (7.1.2).
"
fi

## Install numpy
numpyver=`python -c "import numpy; print numpy.version.version" 2>/dev/null`
if [[ $numpyver != 1.9.1 ]]; then
echo "Installing Numpy v1.9.1.
"
pip install numpy==1.9.1
wait
else
echo "Numpy already correct version (1.9.1).
"
fi

## Install scipy
scipyver=`python -c "import scipy; print scipy.version.version" 2>/dev/null`
if [[ $scipyver != 0.15.1 ]]; then
echo "Installing Scipy v0.15.1.
"
pip install scipy==0.15.1
wait
else
echo "Scipy already correct version (0.15.1).
"
fi

## Install matplotlib
mplver=`python -c "import matplotlib; print matplotlib.__version__" 2>/dev/null`
if [[ $mplver != 1.3.1 ]]; then
echo "Installing Matplotlib v1.3.1.
"
pip install matplotlib==1.3.1
wait
else
echo "Matplotlib already correct version (1.3.1).
"
fi

## Install Cython
cythonver=`python -c "import cython; print cython.__version__" 2>/dev/null`
if [[ $cythonver != 0.23.1 ]]; then
echo "Installing Cython v0.23.1.
"
pip install Cython==0.23.1
else
echo "Cython already correct version (0.23.1).
"
fi

## Install h5py
h5pyver=`python -c "import h5py; print h5py.__version__" 2>/dev/null`
if [[ $h5pyver != 2.4.0 ]]; then
echo "Installing h5py v2.4.0.
"
pip install h5py==2.4.0
wait
else
echo "h5py already correct version (2.4.0).
"
fi

## Update R packages
Rscript $scriptdir/r_updates.r
wait

## Install QIIME base
qiimever=`python -c "import qiime; print qiime.__version__" 2>/dev/null`
if [[ $qiimever != 1.9.1 ]]; then
echo "Installing QIIME base v1.9.1.
"
pip install qiime==1.9.1
wait
else
echo "QIIME base install already correct version (1.9.1).
"
fi

## Install primer prospector and correct the analyze primers library
#	pptest=`command -v analyze_primers.py 2>/dev/null | wc -l`
#	if [[ $pptest == 0 ]]; then
#echo "Installing Primer Prospector.
#"
#tar -xzvf $scriptdir/pprospector-1.0.1.tar.gz -C /bin/
#cd /bin/pprospector-1.0.1/
#python setup.py install --install-scripts=/bin/pprospector-1.0.1/bin/
#sed -i "s/\"$/:TARGET/" /etc/environment
#sed -i "s|TARGET$|/bin/pprospector-1.0.1/bin\"|" /etc/environment
#source /etc/environment
#cp $homedir/akutils/akutils_resources/analyze_primers.py /bin/pprospector-1.0.1/primerprospector/
#else
#echo "Primer prospector already installed.  Skipping.
#"
#	fi

## Run QIIME deploy
if [[ ! -d $homedir/qiime-deploy ]]; then
git clone https://github.com/qiime/qiime-deploy.git
fi
if [[ ! -d $homedir/qiime-deploy-conf ]]; then
git clone git://github.com/qiime/qiime-deploy-conf.git
fi
wait
cd qiime-deploy/
python qiime-deploy.py $homedir/qiime_1.9.1/ -f $scriptdir/qiime.1.9.1.custom.conf --force-remove-failed-dirs
wait

## Fix broken analyze_primers.py
cp $homedir/akutils/akutils_resources/analyze_primers.py $homedir/qiime_1.9.1/pprospector-1.0.1-release/lib/python2.7/site-packages/primerprospector/analyze_primers.py

## Source files and test qiime install
source $homedir/.bashrc
source $homedir/qiime_1.9.1/activate.sh
print_qiime_config.py -tf

## Report on installations
echo "
Installations complete (hopefully).

A single failure for the QIIME tests is normal since you need to provide
your own binary for usearch (see details on qiime website).

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
