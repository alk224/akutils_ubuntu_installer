#!/usr/bin/env bash
set -e

## Script to install my favorite programs in Ubuntu
## Should be run from home directory


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
	if [[ -f ~/Downloads/google-chrome*.deb ]]; then
	rm ~/Downloads/google-chrome*.deb
	fi
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P ~/Downloads/
wait
echo "Installing Google Chrome.
"
	dpkg -i ~/Downloads/google-chrome*.deb
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
apt-get update
cat /etc/apt/sources.list > /etc/apt/sources.list.backup
uniq /etc/apt/sources.list.backup > /etc/apt/sources.list
apt-get update
wait

## Download special programs
echo "Downloading special programs.
"

	ITSxcount=`ls ~/Downloads/ITSx_*.gz | wc -l`
	if [[ $ITSxcount == 0 ]]; then
	wget http://microbiology.se/sw/ITSx_1.0.11.tar.gz -P ~/Downloads/
	fi

	smaltcount=`ls ~/Downloads/smalt*.gz | wc -l`
	if [[ $smaltcount == 0 ]]; then
	wget http://sourceforge.net/projects/smalt/files/latest/download -P ~/Downloads/
	mv ~/Downloads/download ~/Downloads/smalt.tar.gz
	fi

	hmmcount=`ls ~/Downloads/hmmer-3.1b2*.gz | wc -l`
	if [[ $hmmcount == 0 ]]; then
	wget http://selab.janelia.org/software/hmmer3/3.1b2/hmmer-3.1b2-linux-intel-x86_64.tar.gz -P ~/Downloads/
	fi

	tscount=`ls ~/Downloads/ts-0.7.4*.gz | wc -l`
	if [[ $tscount == 0 ]]; then
	wget http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.7.4.tar.gz -P ~/Downloads/
	fi
wait

## Install programs from Ubuntu repositories
echo "Installing programs from repositories.
"
apt-get -y install fail2ban veusz samtools r-base r-base-core r-base-dev r-bioc-biocinstaller openssh-server build-essential python-dev python-pip mafft fastx-toolkit bowtie2 tophat abyss arb bedtools bwa cufflinks picard-tools seaview treeview treeviewx staden-io-lib-utils ugene ugene-data velvet gpart gparted htop gimp gimp-data gimp-plugin-registry gimp-data-extras indicator-multiload synaptic zip unzip clementine acroread git y-ppa-manager gimp-help-en ttf-mscorefonts-installer libfreetype6-dev hdf5-tools ghc gcc g++ fastqc h5utils
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
apt-get update

## Clone github repositories
echo "Cloning github repositories.
"
homedir=`pwd`
if [[ ! -d $homedir/akutils ]]; then
git clone https://github.com/alk224/akutils.git
fi

if [[ ! -d $homedir/vsearch ]]; then
git clone https://github.com/torognes/vsearch.git
fi
wait

## Upgrading pip
echo "Upgrading pip version."
pip install pip --upgrade pip

## Install numpy
echo "Installing Numpy.
"
pip install numpy --upgrade
wait

## Install scipy
echo "Installing Scipy.
"
pip install scipy --upgrade
wait

## Install Cython
echo "Installing Cython.
"
pip install Cython

## Install h5py
echo "Installing h5py.
"
pip install h5py

## Install QIIME
echo "Installing QIIME.
"
pip install qiime
wait

echo "
Installations complete (hopefully).

Need to add the following directory to your PATH variable:
$homedir/akutils

Need to go to the following directory and follow README instructions for installation:
$homedir/vsearch

Need to download and compile ea-utils.

Need to compile ITSx, smalt, hmmer, and task-spooler.
All are already downloaded to $homedir/Downloads/ directory

Probably should reboot computer first.
"

exit 0
