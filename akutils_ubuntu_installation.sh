#!/usr/bin/env bash
## Script to install my favorite programs in Ubuntu
## Should be run from home directory
## Author: Andrew Krohn
## Date: 2015-08-29
## License: MIT
## Version: 0.0.1

## Trap function for exit status.
function finish {
if [[ ! -z $stdout ]] && [[ ! -z $stderr ]]; then
if [[ ! -z $log ]]; then
bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
rm $stdout
rm $stderr
fi
fi
}
trap finish EXIT
#set -e

userid=`echo $SUDO_USER`
homedir=(/home/$userid/)
scriptdir="$( cd "$( dirname "$0" )" && pwd )"

	if [[ "$1" != "install" ]] && [[ "$1" != "list" ]] && [[ "$1" != "test" ]]; then
echo "
ak_ubuntu_installation script (v1.0.1), 2015-10-31.  Script to facilitate
installation of my favorite useful bioinformatics packages on a bare Ubuntu
14.04 LTS install.  Tested on no other distros.

The script will initially ask for brief input.  If you make a mistake,
hit <ctrl-C> and start over.

Installation should be completely automatic and non-interactive.  If there are
any errors during install, try rebooting your system first, then rerun the
install script.  This often fixes installation errors that occur when
dependencies are indeed installed, but the system fails to recognize their
presence until the system is refreshed.

Usage:
   bash ak_ubuntu_installer/ak_ubuntu_installation.sh (this help screen)
   bash ak_ubuntu_installer/ak_ubuntu_installation.sh list (list of software)
   bash ak_ubuntu_installer/ak_ubuntu_installation.sh test (test of installed software)
   sudo bash ak_ubuntu_installer/ak_ubuntu_installation.sh install (installation)
   sudo bash ak_ubuntu_installer/ak_ubuntu_installation.sh install --force-R (run R updates only)
   sudo bash ak_ubuntu_installer/ak_ubuntu_installation.sh install --stacks (install Stacks)
"
	exit 0
	fi

## Check whether user supplied list argument.
	if [[ "$1" == "list" ]]; then
	less $scriptdir/docs/software_list
	exit 0
	fi

## Check whether user supplied test argument.
	if [[ "$1" == "test" ]]; then
	bash $scriptdir/scripts/akutils_ubuntu_QIIME_test.sh
	exit 0
	fi

## Check for sudo power
	if [[ $EUID != 0 ]]; then
	echo "This command must be executed as root (or sudo)."
	exit 0
	fi

## Set log file
	randcode=`cat /dev/urandom |tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1` 2>/dev/null
	date0=`date +%Y%m%d_%I%M%p`
	date1=`date -R`
	logcount=`ls $scriptdir/log_akutils_ubuntu_installation* 2>/dev/null | wc -l`
	stderr=($scriptdir/temp/$randcode\_stderr)
	touch $stderr
	stdout=($scriptdir/temp/$randcode\_stdout)
	touch $stdout

	if [[ $logcount -ge 1 ]]; then
	log=`ls $scriptdir/log_akutils_ubuntu_installation* | head -1`

## Set permissions of log file
	chown $userid:$userid $log
	chmod 664 $log

## Update R packages if --force-R supplied
	if [[ "$2" == "--force-R" ]]; then
	Rdate=`date +%Y,%m,%d`
	echo "--force-R supplied.

Installing/updating R packages and exiting.
This takes a while so please be patient.
	"
	echo "--force-R supplied.

Installing/updating R packages and exiting." >> $log
	date >> $log

	rtest=`command -v R 2>/dev/null | wc -l`
	if [[ $rtest == 0 ]]; then
		echo "R does not seem to be installed.
Install it manually or run the installer script without
--force-R (this will install R and run all updates).
		"
		
		exit 1
	else
	Rscript $scriptdir/scripts/r_slave.r 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
	wait
	echo $Rdate > $scriptdir/updates/R_installs_and_updates.txt

	echo "R updates completed.
	"
	echo "R updates completed.
	" >> $log
	exit 0
	fi
	fi

## Run Stacks installer if --stacks supplied
	if [[ "$2" == "--stacks" ]]; then
	stacksdate=`date +%Y,%m,%d`
	echo "--stacks supplied.

Installing/updating Stacks and exiting.  This takes a while so please
be patient.
	"
	echo "--stacks supplied.

Installing/updating Stacks and exiting." >> $log
	date >> $log

	sudo bash $scriptdir/scripts/stacks_slave.sh $stdout $stderr $log $homedir $scriptdir $userid
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
	wait
	sudo -s echo $stacksdate > $scriptdir/updates/stacks.txt

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

## Set R_updates and ppa_log files to be ignored during future git pulls
cd $homedir/akutils_ubuntu_installer/
git update-index --assume-unchanged updates/ppa_log.txt 1>$stdout 2>$stderr || true
git update-index --assume-unchanged updates/R_installs_and_updates.txt 1>$stdout 2>$stderr || true
git update-index --assume-unchanged updates/stacks.txt 1>$stdout 2>$stderr || true
cd

## Source existing files
sudo -s source $homedir/.bashrc
sudo -s source /etc/environment
source $homedir/.bashrc
source /etc/environment

## Install Google Chrome if not already present
	chrometest=`command -v google-chrome 2>/dev/null | wc -l`
	if [[ $chrometest == 0 ]]; then
		sudo bash $scriptdir/scripts/chrome_slave.sh $stdout $stderr $log $homedir $scriptdir
	else
	echo "Google Chrome is already installed.  Skipping.
	"
	echo "Google Chrome is already installed.  Skipping.
	" >> $log
	fi
wait

## Add additional ppas if not present (relies partially on local log file in repository directory)
## Test for ppa log
	mlicount=`grep "indicator-multiload" $scriptdir/updates/ppa_log.txt  2>/dev/null | wc -l`
	ottocount=`grep "otto-kesselgulasch-gimp" $scriptdir/updates/ppa_log.txt 2>/dev/null | wc -l`
	rppacount=`grep "cran.rstudio.com" $scriptdir/updates/ppa_log.txt 2>/dev/null | wc -l`
	if [[ $mlicount == 0 ]] && [[ $ottocount == 0 ]] && [[ $rppacount == 0 ]]; then

## Add ppas if failed or skip if already present
		sudo bash $scriptdir/scripts/ppa_slave.sh $stdout $stderr $log $homedir $scriptdir
	else
	echo "All ppas are already present.  Skipping.
	"
	echo "All ppas are already present.  Skipping.
	" >> $log

	fi
wait

## Install programs from Ubuntu repositories
		sudo bash $scriptdir/scripts/ubuntu_slave.sh $stdout $stderr $log $homedir $scriptdir

## Install Adobe Reader 9 if not already present
	adobetest=`command -v acroread 2>/dev/null | wc -l`
	if [[ $adobetest == 0 ]]; then
		sudo bash $scriptdir/scripts/adobe_slave.sh $stdout $stderr $log $homedir $scriptdir
	else
	echo "Adobe Reader already installed.  Skipping.
	"
	echo "Adobe Reader already installed.  Skipping.
	" >> $log
	fi

## Install Microsoft core fonts
		sudo bash $scriptdir/scripts/ttf_slave.sh $stdout $stderr $log $homedir $scriptdir
wait

## Clean up Ubuntu packages
		sudo bash $scriptdir/scripts/ubuntu_cleanup_slave.sh $stdout $stderr $log $homedir $scriptdir
wait

## Clone github repositories or do fresh git pulls if already present
		sudo bash $scriptdir/scripts/github_clone_slave.sh $stdout $stderr $log $homedir $scriptdir $userid	
wait

## Add akutils to path if not already present
akutilstest=`command -v akutils_config_utility.sh 2>/dev/null | wc -l`
	if [[ $akutilstest == 0 ]]; then
		sudo bash $scriptdir/scripts/akutils_slave.sh $stdout $stderr $log $homedir $scriptdir
	else
	echo "akutils already in your path.
	"
	fi

## Install vsearch if not already present
	vsearchtest=`command -v vsearch 2>/dev/null | wc -l`
	if [[ $vsearchtest == 0 ]]; then
		sudo bash $scriptdir/scripts/vsearch_slave.sh $stdout $stderr $log $homedir $scriptdir
	else
	echo "Vsearch already installed.
	"
	fi

## Install bamtools if not already present
	bamtoolstest=`command -v bamtools 2>/dev/null | wc -l`
	if [[ $bamtoolstest == 0 ]]; then
		sudo bash $scriptdir/scripts/bamtools_slave.sh $stdout $stderr $log $homedir $scriptdir
	else
	echo "Bamtools already installed.
	"
	fi

## Install HMMER if not already present
	hmmertest=`command -v hmmsearch 2>/dev/null | wc -l`
	if [[ $hmmertest == 0 ]]; then
		sudo bash $scriptdir/scripts/hmmer_slave.sh $stdout $stderr $log $homedir $scriptdir
	else
	echo "Hmmer already installed.
	"
	fi

## Install ITSx if not already present
	itsxtest=`command -v ITSx 2>/dev/null | wc -l`
	if [[ $itsxtest == 0 ]]; then
		sudo bash $scriptdir/scripts/itsx_slave.sh $stdout $stderr $log $homedir $scriptdir
	else
	echo "ITSx already installed.
	"
	fi

## Install smalt if not already present
	smalttest=`command -v smalt 2>/dev/null | wc -l`
	if [[ $smalttest == 0 ]]; then
		sudo bash $scriptdir/scripts/smalt_slave.sh $stdout $stderr $log $homedir $scriptdir
	else
	echo "Smalt already installed.
	"
	fi

## Install ea-utils if not already present
	eautilstest=`command -v fastq-mcf 2>/dev/null | wc -l`
	if [[ $eautilstest == 0 ]]; then
		sudo bash $scriptdir/scripts/ea-utils_slave.sh $stdout $stderr $log $homedir $scriptdir
	else
	echo "ea-utils already installed.
	"
	fi

## Install task spooler if not already present
	tstest=`command -v ts 2>/dev/null | wc -l`
	if [[ $tstest == 0 ]]; then
		sudo bash $scriptdir/scripts/ts_slave.sh $stdout $stderr $log $homedir $scriptdir $email
	else
	echo "Task spooler already installed.
	"
	fi

sudo -s source $homedir/.bashrc 1>$stdout 2>$stderr || true
sudo -s source /etc/environment 1>$stdout 2>$stderr || true
source $homedir/.bashrc 1>$stdout 2>$stderr || true
source /etc/environment 1>$stdout 2>$stderr || true

## Install Stacks if not already present
#	stackstest=`command -v cstacks 2>/dev/null | wc -l`
#	if [[ $stackstest -ge 1 ]]; then
#		sudo bash $scriptdir/scripts/stacks_slave.sh $stdout $stderr $log $homedir $scriptdir $email
#	fi

## Update R packages if not been done in over a month
	Rdate0=`head -1 $scriptdir/updates/R_installs_and_updates.txt`
	Rdate1=`date +%Y,%m,%d`
	span=`python -c "from datetime import date; print (date($Rdate1)-date($Rdate0)).days"`
	if [[ $span -ge 31 ]]; then
	echo "Installing/updating R packages.
	"
	echo "Installing/updating R packages." >> $log
	Rscript $scriptdir/scripts/r_slave.r 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
	wait
	echo $Rdate1 > $scriptdir/updates/R_installs_and_updates.txt
	else
	echo "R installs/updates have been run within the past month.  Skipping.
	"
	echo "R installs/updates have been run within the past month.  Skipping.
	" >> $log
	fi

## Install Rstudio if not already present
	rstudiotest=`command -v rstudio 2>/dev/null | wc -l`
	if [[ $rstudiotest == 0 ]]; then
		sudo bash $scriptdir/scripts/rstudio_slave.sh $stdout $stderr $log $homedir $scriptdir
	else
	echo "Rstudio already installed.
	"
	fi

## Pip installs
		sudo bash $scriptdir/scripts/pip_slave.sh $stdout $stderr $log $homedir $scriptdir $email

## Install primer prospector and correct the analyze primers library if not already present
#	pptest=`command -v analyze_primers.py 2>/dev/null | wc -l`
#	if [[ $pptest == 0 ]]; then
#		sudo bash $scriptdir/scripts/pprospector_slave.sh $stdout $stderr $log $homedir $scriptdir $email
#	else
#	echo "Primer prospector already installed.
#	"
#	fi

## Update sources
sudo -s source $homedir/.bashrc
sudo -s source /etc/environment
source $homedir/.bashrc
source /etc/environment

## Run QIIME deploy
		sudo bash $scriptdir/scripts/qiime_deploy_slave.sh $stdout $stderr $log $homedir $scriptdir $userid
wait

## Update analyze_primers.py python library if necessary
	pptest=`ls $homedir/qiime_1.9.1/pprospector-1.0.1-release/lib/python2.7/site-packages/primerprospector/analyze_primers.py 2>/dev/null | wc -l`
	if [[ $pptest == 1 ]]; then
		echo "Checking analyze_primers.py library file.
		"
		sudo bash $scriptdir/scripts/pprospector_slave.sh $stdout $stderr $log $homedir $scriptdir $email 1>$stdout 2>$stderr || true
		bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
	else
	echo "analyze_primers.py not where expected.  Python library not corrected.
	"
	fi

## Source files and test qiime install
sudo -s source $homedir/.bashrc
sudo -s source /etc/environment
sudo -s source $homedir/qiime_1.9.1/activate.sh
source $homedir/.bashrc
source /etc/environment
source $homedir/qiime_1.9.1/activate.sh
print_qiime_config.py -tf

## Copy help files to folder on desktop
if [[ -f "$homedir/Desktop/Using\ the\ task\ spooler\ queue.html" ]]; then
rm -r $homedir/Desktop/Using\ the\ task\ spooler\ queue.html
fi
if [[ -f "$homedir/Desktop/Disk\ management\ instructions.html" ]]; then
rm -r $homedir/Desktop/RAID\ disk\ management\ instructions.html
fi
sudo -u $userid cp $homedir/akutils_ubuntu_installer/docs/*.html $homedir/Desktop/

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
