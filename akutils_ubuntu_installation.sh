#!/usr/bin/env bash
## Script to install my favorite programs in Ubuntu
## Should be run from home directory
## Author: Andrew Krohn
## Date: 2015-08-29
## License: MIT
## Version: 0.0.1
## Trap function to for exit status 1
function finish {
if [[ ! -z $log ]]; then
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
rm $stdout
rm $stderr
fi
}
trap finish EXIT
set -e

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
	bash $scriptdir/akutils_ubuntu_QIIME_test.sh
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

## Set log file
	randcode=`cat /dev/urandom |tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1` 2>/dev/null
	date0=`date +%Y%m%d_%I%M%p`
	date1=`date -R`
	logcount=`ls $scriptdir/log_akutils_ubuntu_installation* 2>/dev/null | wc -l`
	stderr=($scriptdir/$rand\_stderr)
	stdout=($scriptdir/$rand\_stdout)

	if [[ $logcount -ge 1 ]]; then
	log=`ls $scriptdir/log_akutils_ubuntu_installation* | head -1`
	echo "
********************************************************************************
Installation script restarted.
$date1

********************************************************************************
" >> $log
	fi

	if [[ $logcount -eq 0 ]]; then
	log=($scriptdir/log_akutils_ubuntu_installation_$randcode\_$date0.txt)
	touch $log
	echo "
********************************************************************************
Installation script started.
$date1

********************************************************************************
" >> $log
	fi

## Install Google Chrome
## Test for install
	chrometest=`command -v google-chrome 2>/dev/null | wc -l`
	if [[ $chrometest == 0 ]]; then

## Install if test failed
echo "Installing dependencies for Google Chrome install.
"
echo "Installing dependencies for Google Chrome install.
" >> $log
	apt-get -y install libxss1 libappindicator1 libindicator7 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
wait
echo "Downloading Google Chrome.
"
echo "Downloading Google Chrome.
" >> $log
	if [[ -f $homedir/Downloads/google-chrome*.deb ]]; then
	rm $homedir/Downloads/google-chrome*.deb 1>$stdout 2>$stderr || true
	fi
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P $homedir/Downloads/
wait
echo "Installing Google Chrome.
"
echo "Installing Google Chrome.
" >> $log
	dpkg -i $homedir/Downloads/google-chrome*.deb 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
wait

else
echo "Google Chrome is already installed.  Skipping.
"
	fi
wait

## Add additional ppas
echo "Adding extra ppas.
"
echo "Adding extra ppas.
" >> $log
mlicount=`ls /etc/apt/sources.list.d/indicator-multiload-stable-daily*  2>/dev/null | wc -l`
if [[ $mlicount == 0 ]]; then
apt-add-repository -y ppa:indicator-multiload/stable-daily 1>$stdout 2>$stderr || true
echo "Indicator mutliload ppa:" >> $log
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
fi
ottocount=`ls /etc/apt/sources.list.d/otto-kesselgulasch-gimp*  2>/dev/null | wc -l`
if [[ $ottocount == 0 ]]; then
add-apt-repository -y ppa:otto-kesselgulasch/gimp 1>$stdout 2>$stderr || true
echo "Gimp ppa:" >> $log
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
fi
rppacount=`cat /etc/apt/sources.list | grep "cran.rstudio.com"  2>/dev/null | wc -l`
if [[ $rppacount == 0 ]]; then
/bin/su -c "echo 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list"
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 1>$stdout 2>$stderr || true
echo "R (cran) ppa:" >> $log
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
fi
yppacount=`ls /etc/apt/sources.list.d/webupd8team-y-ppa-manager*  2>/dev/null | wc -l`
if [[ $yppacount == 0 ]]; then
add-apt-repository -y ppa:webupd8team/y-ppa-manager 1>$stdout 2>$stderr || true
echo "Y ppa manager ppa:" >> $log
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
fi
apt-get -y update 1>$stdout 2>$stderr || true
cat /etc/apt/sources.list > /etc/apt/sources.list.backup
uniq /etc/apt/sources.list.backup > /etc/apt/sources.list
apt-get -y update 1>$stdout 2>$stderr || true
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
echo "Installing programs from repositories.
" >> $log
export DEBIAN_FRONTEND=noninteractive
echo "Installing multiload indicator.
" >> $log
apt-get -yfm install htop indicator-multiload 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
wait
echo "Installing all other programs via apt-get.
" >> $log
apt-get -yfm install fail2ban openssh-server gimp gimp-data gimp-plugin-registry gimp-data-extras gimp-help-en veusz clementine build-essential python-dev python-pip perl zip unzip synaptic y-ppa-manager git gpart gparted libfreetype6-dev ghc gcc g++ h5utils hdf5-tools r-base r-base-core r-base-dev r-cran-xml samtools mafft fastx-toolkit bedtools bowtie2 tophat cufflinks picard-tools abyss arb fastqc velvet staden-io-lib-utils ugene ugene-data seaview treeview treeviewx subversion zlib1g-dev libgsl0-dev cmake libncurses5-dev libssl-dev libzmq-dev libxml2 libxslt1.1 libxslt1-dev ant zlib1g-dev libpng12-dev mpich2 libreadline-dev gfortran libmysqlclient18 libmysqlclient-dev sqlite3 libsqlite3-dev libc6-i386 libbz2-dev tcl-dev tk-dev libatlas-dev libatlas-base-dev liblapack-dev swig libhdf5-serial-dev filezilla libcurl4-openssl-dev libxml2-dev openjdk-7-jdk sendmail mysql-server php5 apache2 php-mdb2 php-mdb2-driver-mysql libdbd-mysql-perl libbam-dev nfs-common nfs-kernel-server mdadm screen --quiet --force-yes 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
wait
#apt-get -yfm install libgtk2.0-0:i386 libnss3-1d:i386 libnspr4-0d:i386 lib32nss-mdns libxml2:i386 libxslt1.1:i386 libstdc++6:i386
#wait

## Install Adobe Reader 9
echo "Installing Adobe Reader 9.5.
"
echo "Installing Adobe Reader 9.5.
" >> $log
cd ~/Downloads/
wget -c http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb &>/dev/null
export DEBIAN_FRONTEND=noninteractive
sudo dpkg -i --force-confold --force-confdef AdbeRdr9.5.5-1_i386linux_enu.deb 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
wait
cd

## Install Microsoft core fonts
echo "Installing Microsoft Core Fonts.
"
echo "Installing Microsoft Core Fonts.
" >> $log
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
apt-get -yfm install ttf-mscorefonts-installer 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
wait

echo "Cleaning up ubuntu packages.
"
echo "Cleaning up ubuntu packages.
" >> $log
sudo apt-get -f install 1>$stdout 2>$stderr || true
sudo apt-get -y autoremove 1>$stdout 2>$stderr || true
sudo apt-get -y autoclean 1>$stdout 2>$stderr || true
sudo apt-get -y clean 1>$stdout 2>$stderr || true
wait

## Clone github repositories
echo "Cloning github repositories.
"
echo "Cloning github repositories.
" >> $log
if [[ ! -d $homedir/akutils ]]; then
echo "Cloning akutils github repository."
echo "Cloning akutils github repository." >> $log
sudo -u $userid git clone https://github.com/alk224/akutils.git 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
fi
if [[ ! -d $homedir/vsearch ]]; then
echo "Cloning vsearch github repository."
echo "Cloning vsearch github repository." >> $log
sudo -u $userid git clone https://github.com/torognes/vsearch.git 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
fi
if [[ ! -d $homedir/bamtools ]]; then
echo "Cloning bamtools github repository."
echo "Cloning bamtools github repository." >> $log
sudo -u $userid git clone git://github.com/pezmaster31/bamtools.git 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
fi
wait
if [[ ! -d $homedir/QIIME_test_data_16S ]]; then
echo "Cloning QIIME test data github repository."
echo "Cloning QIIME test data github repository." >> $log
sudo -u $userid git clone https://github.com/alk224/QIIME_test_data_16S.git 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
fi
wait
if [[ ! -d $homedir/QIIME_databases ]]; then
echo "Cloning QIIME databases github repository."
echo "Cloning QIIME databases github repository." >> $log
sudo -u $userid git clone https://github.com/alk224/QIIME_databases.git 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
fi
if [[ ! -d $homedir/QIIME_databases/gg_otus-13_8-release ]]; then
echo "Unpacking Greengenes database."
echo "Unpacking Greengenes database." >> $log
cd $homedir/QIIME_databases
tar -xzvf gg_otus-13_8-release.tar.gz 1>$stdout 2>$stderr || true
cd $homedir
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
fi
if [[ ! -d $homedir/QIIME_databases ]]; then
echo "Unpacking UNITE database."
echo "Unpacking UNITE database." >> $log
cd $homedir/QIIME_databases
tar -xzvf UNITE_2015-03-02.tar.gz 1>$stdout 2>$stderr || true
cd $homedir
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
fi
wait

## Source environment file
source $homedir/.bashrc 1>$stdout 2>$stderr || true
source /etc/environment 1>$stdout 2>$stderr || true

## Add akutils to path
akutilstest=`grep "$homedir/akutils" /etc/environment 2>/dev/null | wc -l`
	if [[ $akutilstest == 0 ]]; then
echo "Adding akutils repository to path (/etc/environment).
"
echo "Adding akutils repository to path (/etc/environment).
" >> $log
sed -i "s/\"$/:TARGET/" /etc/environment 1>$stdout 2>$stderr || true
sed -i "s|TARGET$|$homedir/akutils\"|" /etc/environment  1>$stdout 2>$stderr || true
	fi

## Install vsearch
	vsearchtest=`command -v vsearch 2>/dev/null | wc -l`
	if [[ $vsearchtest == 0 ]]; then
echo "Installing vsearch.
"
echo "Installing vsearch." >> $log
cd $homedir/vsearch
./autogen.sh 1>$stdout 2>$stderr || true
./configure 1>$stdout 2>$stderr || true
make 1>$stdout 2>$stderr || true
wait
make install 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
cp $homedir/vsearch/bin/vsearch /usr/bin/
	else
echo "Vsearch already installed.  Skipping.
"
	fi

## Install bamtools
	bamtoolstest=`command -v bamtools 2>/dev/null | wc -l`
	if [[ $bamtoolstest == 0 ]]; then
echo "Installing Bamtools.
"
echo "Installing Bamtools.
" >> $log
cd $homedir/bamtools/
mkdir build  1>$stdout 2>$stderr || true
cd build
cmake .. 1>$stdout 2>$stderr || true
make 1>$stdout 2>$stderr || true
wait
cd $homedir
sed -i "s/\"$/:TARGET/" /etc/environment
sed -i "s|TARGET$|$homedir/bamtools/bin\"|" /etc/environment
	else
echo "Bamtools already installed.  Skipping.
"
	fi

## Install HMMER
	hmmertest=`command -v hmmsearch 2>/dev/null | wc -l`
	if [[ $hmmertest == 0 ]]; then
echo "Installing HMMer
"
echo "Installing HMMer" >> $log
tar -xzvf $scriptdir/hmmer-3.1b2-linux-intel-x86_64.tar.gz -C /bin/  1>$stdout 2>$stderr || true
cd /bin/hmmer-3.1b2-linux-intel-x86_64/
./configure 1>$stdout 2>$stderr || true
make 1>$stdout 2>$stderr || true
wait
cd $homedir
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
	else
echo "HMMer already installed.  Skipping.
"
	fi

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

## Install smalt
	smalttest=`command -v smalt 2>/dev/null | wc -l`
	if [[ $smalttest == 0 ]]; then
echo "Installing Smalt.
"
echo "Installing Smalt.
" >> $log
tar -xzvf $scriptdir/smalt.tar.gz -C /bin/
smaltdir=`ls /bin/ | grep "smalt"`
cd /bin/$smaltdir/
./configure 1>$stdout 2>$stderr || true
make install 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
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
echo "Installing ea-utils.
" >> $log
tar -xzvf $scriptdir/ea-utils.1.1.2-806.tar.gz -C /bin/
cd /bin/ea-utils.1.1.2-806/
make install 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
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
echo "Installing Task spooler.
" >> $log
tar -xzvf $scriptdir/ts-0.7.4.tar.gz -C /bin/
cd /bin/ts-0.7.4/
make 1>$stdout 2>$stderr || true
make install 1>$stdout 2>$stderr || true
cd $homedir
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
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
		#/bin/su -c "echo 'tsheavy -S 1' >> /etc/environment"
source $homedir/.bashrc 1>$stdout 2>$stderr || true
sleep 1
source /etc/environment 1>$stdout 2>$stderr || true

## Install Stacks
echo "Installing Stacks for RADseq applications.
"
echo "Installing Stacks for RADseq applications.
" >> $log
cd $homedir/akutils_ubuntu_installer
tar -xzvf stacks-1.34.tar.gz  1>$stdout 2>$stderr || true
cd stacks-1.34/
./configure  1>$stdout 2>$stderr || true
make  1>$stdout 2>$stderr || true
wait
sudo make install 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
wait
## Edit MySQL config file
echo "Configuring mysql and apache webserver.
"
echo "Configuring mysql and apache webserver.
" >> $log
sudo cp /usr/local/share/stacks/sql/mysql.cnf.dist /usr/local/share/stacks/sql/mysql.cnf 1>$stdout 2>$stderr || true
mysql> GRANT ALL ON *.* TO 'stacks'@'localhost' IDENTIFIED BY 'stacks'; 1>$stdout 2>$stderr || true
sudo sed -i 's/password=\w\+/password=stacks/' /usr/local/share/stacks/sql/mysql.cnf 1>$stdout 2>$stderr || true
sudo sed -i 's/user=\w\+/user=stacks/' /usr/local/share/stacks/sql/mysql.cnf 1>$stdout 2>$stderr || true
## Enable Stacks web interface in Apache webserver
sudo echo '<Directory "/usr/local/share/stacks/php">
        Order deny,allow
        Deny from all
        Allow from all
	Require all granted
</Directory>

Alias /stacks "/usr/local/share/stacks/php"
' > /etc/apache2/conf-available/stacks.conf 1>$stdout 2>$stderr || true
ln -s /etc/apache2/conf-available/stacks.conf /etc/apache2/conf-enabled/stacks.conf 1>$stdout 2>$stderr || true
sudo apachectrl restart 1>$stdout 2>$stderr || true
wait
## Provide access to MySQL database from web interface
cp /usr/local/share/stacks/php/constants.php.dist /usr/local/share/stacks/php/constants.php 1>$stdout 2>$stderr || true
sudo sed -i 's/dbuser/stacks/' /usr/local/share/stacks/php/constants.php 1>$stdout 2>$stderr || true
sudo sed -i 's/dbpass/stacks/' /usr/local/share/stacks/php/constants.php 1>$stdout 2>$stderr || true
## Enable web-based exporting from MySQL database
chown stacks /usr/local/share/stacks/php/export 1>$stdout 2>$stderr || true
cd

## Upgrading pip
pipver=`python -c "import pip; print pip.__version__" 2>/dev/null`
if [[ $pipver != 7.1.2 ]]; then
echo "Installing pip v7.1.2.
"
echo "Installing pip v7.1.2." >> $log
pip install pip==7.1.2 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
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
echo "Installing Numpy v1.9.1." >> $log
pip install numpy==1.9.1 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
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
echo "Installing Scipy v0.15.1." >> $log
pip install scipy==0.15.1 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
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
echo "Installing Matplotlib v1.3.1." >> $log
pip install matplotlib==1.3.1 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
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
echo "Installing Cython v0.23.1." >> $log
pip install Cython==0.23.1 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
else
echo "Cython already correct version (0.23.1).
"
fi

## Install h5py
h5pyver=`python -c "import h5py; print h5py.__version__" 2>/dev/null`
if [[ $h5pyver != 2.4.0 ]]; then
echo "Installing h5py v2.4.0.
"
echo "Installing h5py v2.4.0." >> $log
pip install h5py==2.4.0 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
wait
else
echo "h5py already correct version (2.4.0).
"
fi

## Update R packages
echo "Installing/updating R packages.
"
echo "Installing/updating R packages." >> $log
Rscript $scriptdir/r_updates.r 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
wait

## Install QIIME base
qiimever=`python -c "import qiime; print qiime.__version__" 2>/dev/null`
if [[ $qiimever != 1.9.1 ]]; then
echo "Installing QIIME base v1.9.1.
"
echo "Installing QIIME base v1.9.1." >> $log
pip install qiime==1.9.1 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
wait
else
echo "QIIME base install already correct version (1.9.1).
"
fi

## Copy help files to folder on desktop
if [[ -f "$homedir/Desktop/Using\ the\ task\ spooler\ queue.html" ]]; then
rm -r $homedir/Desktop/Using\ the\ task\ spooler\ queue.html
fi
if [[ -f "$homedir/Desktop/Disk\ management\ instructions.html" ]]; then
rm -r $homedir/Desktop/Disk\ management\ instructions.html
fi
sudo -u $userid cp $homedir/akutils_ubuntu_installer/*.html $homedir/Desktop/

## Install primer prospector and correct the analyze primers library
	pptest=`command -v analyze_primers.py 2>/dev/null | wc -l`
	if [[ $pptest == 0 ]]; then
echo "Installing Primer Prospector.
"
echo "Installing Primer Prospector." >> $log
tar -xzvf $scriptdir/pprospector-1.0.1.tar.gz -C /bin/ 1>$stdout 2>$stderr || true
cd /bin/pprospector-1.0.1/
python setup.py install --install-scripts=/bin/pprospector-1.0.1/bin/ 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
sed -i "s/\"$/:TARGET/" /etc/environment 1>$stdout 2>$stderr || true
sed -i "s|TARGET$|/bin/pprospector-1.0.1/scripts\"|" /etc/environment 1>$stdout 2>$stderr || true
source /etc/environment 1>$stdout 2>$stderr || true
cp $homedir/akutils/akutils_resources/analyze_primers.py /bin/pprospector-1.0.1/primerprospector/ 1>$stdout 2>$stderr || true
else
echo "Primer prospector already installed.  Skipping.
"
	fi

## Run QIIME deploy
if [[ ! -d $homedir/qiime-deploy ]]; then
echo "Cloning QIIME deploy repository.
"
echo "Cloning QIIME deploy repository.
" >> $log
sudo -u $userid git clone https://github.com/qiime/qiime-deploy.git 1>$stdout 2>$stderr || true
fi
if [[ ! -d $homedir/qiime-deploy-conf ]]; then
echo "Cloning QIIME deploy conf repository.
"
echo "Cloning QIIME deploy conf repository.
" >> $log
sudo -u $userid git clone git://github.com/qiime/qiime-deploy-conf.git 1>$stdout 2>$stderr || true
fi
wait
echo "Executing QIIME deploy script.
"
echo "Executing QIIME deploy script." >> $log
cd qiime-deploy/
python qiime-deploy.py $homedir/qiime_1.9.1/ -f $scriptdir/qiime.1.9.1.custom.conf --force-remove-failed-dirs 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stout >> $log
echo "***** stderr:" >> $log
cat $sterr >> $log
echo "" >> $log
wait

## Fix broken analyze_primers.py
cp $homedir/akutils/akutils_resources/analyze_primers.py $homedir/qiime_1.9.1/pprospector-1.0.1-release/lib/python2.7/site-packages/primerprospector/analyze_primers.py 1>$stdout 2>$stderr || true

## Source files and test qiime install
source $homedir/qiime_1.9.1/activate.sh 1>$stdout 2>$stderr || true
source $homedir/.bashrc 1>$stdout 2>$stderr || true
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
rm $stdout
rm $stderr
exit 0
