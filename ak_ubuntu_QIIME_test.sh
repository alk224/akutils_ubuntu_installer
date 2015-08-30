#!/usr/bin/env bash

## workflow of tests to examine system installation completeness
set -e
homedir=`echo $HOME`
scriptdir="$( cd "$( dirname "$0" )" && pwd )"

## Echo test start
echo "
Beginning tests of QIIME installation.
"

## Check for test data
testtest=`ls $homedir/QIIME_test_data_16S 2>/dev/null | wc -l`
	if [[ $testtest == 0 ]]; then
	cd $homedir
	git clone https://github.com/alk224/QIIME_test_data_16S.git
	else
	echo "Test data in place.
	"
	fi
testdir=($homedir/QIIME_test_data_16S)
cd $testdir

## Set log file
logcount=`ls $testdir/log_workflow_testing* 2>/dev/null | wc -l`	
if [[ $logcount > 0 ]]; then
	log=`ls $testdir/log_workflow_testing*.txt | head -1`
	echo "Workflow tests restarting."
	date1=`date "+%a %b %d %I:%M %p %Z %Y"`
	echo "$date1"
	res1=$(date +%s.%N)
	echo "
Workflow tests restarting." >> $log
	date "+%a %b %d %I:%M %p %Z %Y" >> $log
	else
	echo "Workflow tests beginning."
	date1=`date "+%a %b %d %I:%M %p %Z %Y"`
	echo "$date1"
	date0=`date +%Y%m%d_%I%M%p`
	log=($testdir/log_workflow_testing_$date0.txt)
	echo "
Workflow tests beginning." > $log
	date "+%a %b %d %I:%M %p %Z %Y" >> $log
	res1=$(date +%s.%N)
	echo "
---
		" >> $log
	fi

## Unpack data if necessary
	for gzfile in `ls raw_data/*.gz 2>/dev/null`; do
	gunzip $gzfile
	done
	for gzfile in `ls gg_database/*.gz 2>/dev/null`; do
	gunzip $gzfile
	done

## Setup akutils global config file
if [[ -f $testdir/resources/akutils.global.config.master ]]; then
rm $testdir/resources/akutils.global.config.master
fi
cp $testdir/resources/config.template $testdir/resources/akutils.global.config.master
masterconfig=($testdir/resources/akutils.global.config.master)
cpus=`grep -c ^processor /proc/cpuinfo`

for field in `grep -v "#" $masterconfig | cut -f 1`; do
	if [[ $field == "Reference" ]]; then
	setting=`grep $field $masterconfig | grep -v "#" | cut -f 2`
	newsetting=($testdir/gg_database/97_rep_set_1000.fasta)
	sed -i -e "s@^$field\t$setting@$field\t$newsetting@" $masterconfig
	fi
	if [[ $field == "Taxonomy" ]]; then
	setting=`grep $field $masterconfig | grep -v "#" | cut -f 2`
	newsetting=($testdir/gg_database/97_taxonomy_1000.fasta)
	sed -i -e "s@^$field\t$setting@$field\t$newsetting@" $masterconfig
	fi
	if [[ $field == "Chimeras" ]]; then
	setting=`grep $field $masterconfig | grep -v "#" | cut -f 2`
	newsetting=($testdir/gg_database/gold.fa)
	sed -i -e "s@^$field\t$setting@$field\t$newsetting@" $masterconfig
	fi
	if [[ $field == "OTU_picker" ]]; then
	setting=`grep $field $masterconfig | grep -v "#" | cut -f 2`
	newsetting="ALL"
	sed -i -e "s@^$field\t$setting@$field\t$newsetting@" $masterconfig
	fi
	if [[ $field == "Tax_assigner" ]]; then
	setting=`grep $field $masterconfig | grep -v "#" | cut -f 2`
	newsetting="ALL"
	sed -i -e "s@^$field\t$setting@$field\t$newsetting@" $masterconfig
	fi
	if [[ $field == "Alignment_template" ]]; then
	setting=`grep $field $masterconfig | grep -v "#" | cut -f 2`
	newsetting=($testdir/gg_database/core_set_aligned.fasta.imputed)
	sed -i -e "s@^$field\t$setting@$field\t$newsetting@" $masterconfig
	fi
	if [[ $field == "Alignment_lanemask" ]]; then
	setting=`grep $field $masterconfig | grep -v "#" | cut -f 2`
	newsetting=($testdir/gg_database/lanemask_in_1s_and_0s)
	sed -i -e "s@^$field\t$setting@$field\t$newsetting@" $masterconfig
	fi
	if [[ $field == "CPU_cores" ]]; then
	setting=`grep $field $masterconfig | grep -v "#" | cut -f 2`
	newsetting=($cpus)
	sed -i -e "s@^$field\t$setting@$field\t$newsetting@" $masterconfig
	fi
done


## If no global akutils config file, set global config
configtest=`ls $homedir/akutils/akutils_resources/akutils.global.config 2>/dev/null | wc -l`
	if [[ $configtest == 0 ]]; then
	cp $masterconfig $homedir/akutils/akutils_resources/akutils.global.config
	echo "Set akutils global config file.
	"
	echo "
Set akutils global config file." >> $log
	fi

## If global config exists, backup and temporarily replace
	if [[ $configtest == 1 ]]; then
	DATE=`date +%Y%m%d-%I%M%p`
	backfile=($homedir/akutils/akutils_resources/akutils.global.config.backup.$DATE)
	cp $homedir/akutils/akutils_resources/akutils.global.config $backfile
	cp $masterconfig $homedir/akutils/akutils_resources/akutils.global.config
	echo "Set temporary akutils global config file.
	"
	echo "
Set temporary akutils global config file." >> $log
	fi

## Test of db_format.sh command
	echo "Test of db_format.sh command.
	"
	echo "
Test of db_format.sh command." >> $log
db_format $testdir/gg_database/97_rep_set_1000.fasta $testdir/gg_database/97_taxonomy_1000.txt


## Replace config file for test if previous global config exists
	if [[ $configtest == 1 ]]; then
	mv $backfile $homedir/akutils/akutils_resources/akutils.global.config 2>/dev/null
	fi

exit 0
