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
userid="$6"
date0=`date`

echo "Cloning github repositories.
"
echo "Cloning github repositories.
" >> $log

## akutils
if [[ ! -d $homedir/akutils-v1.2 ]]; then
echo "Cloning akutils-v1.2 github repository.
"
echo "Cloning akutils-v1.2 github repository." >> $log
sudo -u $userid git clone https://github.com/alk224/akutils-v1.2.git 1>$stdout 2>$stderr || true
chown -R $userid:$userid $homedir/akutils-v1.2/
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
else
echo "Doing fresh git pull of akutils-v1.2.
"
echo "Doing fresh git pull of akutils-v1.2." >> $log
cd $homedir/akutils-v1.2
sudo -u $userid git pull 1>$stdout 2>$stderr || true
cd
chown -R $userid:$userid $homedir/akutils-v1.2/
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
fi

## vsearch
if [[ ! -d $homedir/vsearch ]]; then
echo "Cloning vsearch github repository.
"
echo "Cloning vsearch github repository." >> $log
sudo -u $userid git clone https://github.com/torognes/vsearch.git 1>$stdout 2>$stderr || true
chown -R $userid:$userid $homedir/vsearch/
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
else
echo "Vsearch repo present.  Not pulling from github.
"
echo "Vsearch repo present.  Not pulling from github.
" >> $log
#echo "Doing fresh git pull of vsearch.
#"
#echo "Doing fresh git pull of vsearch." >> $log
#cd $homedir/vsearch
#sudo -u $userid git pull 1>$stdout 2>$stderr || true
#cd
#chown -R $userid:$userid $homedir/vsearch/
#	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
fi

## bamtools
if [[ ! -d $homedir/bamtools ]]; then
echo "Cloning bamtools github repository.
"
echo "Cloning bamtools github repository." >> $log
sudo -u $userid git clone git://github.com/pezmaster31/bamtools.git 1>$stdout 2>$stderr || true
chown -R $userid:$userid $homedir/bamtools/
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
else
echo "Bamtools repo present.  Not pulling from github.
"
echo "Bamtools repo present.  Not pulling from github.
" >> $log
#echo "Doing fresh git pull of bamtools.
#"
#echo "Doing fresh git pull of bamtools." >> $log
#cd $homedir/bamtools
#sudo -u $userid git pull 1>$stdout 2>$stderr || true
#cd
#chown -R $userid:$userid $homedir/bamtools/
#	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
fi

## QIIME_test_data_16S
if [[ ! -d $homedir/QIIME_test_data_16S ]]; then
echo "Cloning QIIME test data github repository.
"
echo "Cloning QIIME test data github repository." >> $log
sudo -u $userid git clone https://github.com/alk224/QIIME_test_data_16S.git 1>$stdout 2>$stderr || true
chown -R $userid:$userid $homedir/QIIME_test_data_16S/
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
else
echo "Doing fresh git pull of QIIME_test_data_16S.
"
echo "Doing fresh git pull of QIIME_test_data_16S." >> $log
cd $homedir/QIIME_test_data_16S
sudo -u $userid git pull 1>$stdout 2>$stderr || true
cd
chown -R $userid:$userid $homedir/QIIME_test_data_16S/
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
fi

## QIIME_databases
if [[ ! -d $homedir/QIIME_databases ]]; then
echo "Cloning_QIIME databases github repository.
"
echo "Cloning_QIIME databases github repository." >> $log
sudo -u $userid git clone https://github.com/alk224/QIIME_databases.git 1>$stdout 2>$stderr || true
chown -R $userid:$userid $homedir/QIIME_databases
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
else
echo "Doing fresh git pull of QIIME_databases.
"
echo "Doing fresh git pull of QIIME_databases." >> $log
cd $homedir/QIIME_databases
sudo -u $userid git pull 1>$stdout 2>$stderr || true
cd
chown -R $userid:$userid $homedir/QIIME_databases
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
fi

## fqgrep
if [[ ! -d $homedir/fqgrep ]]; then
echo "Cloning fqgrep github repository.
"
echo "Cloning fqgrep github repository." >> $log
sudo -u $userid git clone git://github.com/indraniel/fqgrep.git;
 1>$stdout 2>$stderr || true
chown -R $userid:$userid $homedir/fqgrep
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
else
echo "Doing fresh git pull of fqgrep.
"
echo "Doing fresh git pull of fqgrep." >> $log
cd $homedir/fqgrep
sudo -u $userid git pull 1>$stdout 2>$stderr || true
cd
chown -R $userid:$userid $homedir/fqgrep
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
fi

## ghost-tree
if [[ ! -d $homedir/ghost-tree ]]; then
echo "Cloning ghost-tree github repository.
"
echo "Cloning ghost-tree github repository." >> $log
sudo -u $userid git clone https://github.com/JTFouquier/ghost-tree.git 1>$stdout 2>$stderr || true
chown -R $userid:$userid $homedir/ghost-tree
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
else
echo "Doing fresh git pull of ghost-tree.
"
echo "Doing fresh git pull of ghost-tree." >> $log
cd $homedir/ghost-tree
sudo -u $userid git pull 1>$stdout 2>$stderr || true
cd
chown -R $userid:$userid $homedir/ghost-tree
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
fi

## QIIME deploy
if [[ ! -d $homedir/qiime-deploy ]]; then
echo "Cloning QIIME deploy github repository.
"
echo "Cloning QIIME deploy github repository." >> $log
sudo -u $userid git clone https://github.com/qiime/qiime-deploy.git 1>$stdout 2>$stderr || true
chown -R $userid:$userid $homedir/qiime-deploy/
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
else
echo "Doing fresh git pull of QIIME deploy
"
echo "Doing fresh git pull of QIIME deploy." >> $log
cd $homedir/qiime-deploy
sudo -u $userid git pull 1>$stdout 2>$stderr || true
cd
chown -R $userid:$userid $homedir/qiime-deploy/
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
fi

## QIIME deploy-conf
if [[ ! -d $homedir/qiime-deploy-conf ]]; then
echo "Cloning QIIME deploy-conf github repository.
"
echo "Cloning QIIME deploy-conf github repository." >> $log
sudo -u $userid git clone https://github.com/qiime/qiime-deploy-conf.git 1>$stdout 2>$stderr || true
chown -R $userid:$userid $homedir/qiime-deploy-conf/
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
else
echo "Doing fresh git pull of QIIME deploy-conf
"
echo "Doing fresh git pull of QIIME deploy-conf." >> $log
cd $homedir/qiime-deploy-conf
sudo -u $userid git pull 1>$stdout 2>$stderr || true
cd
chown -R $userid:$userid $homedir/qiime-deploy-conf/
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
fi

## Unpack compressed database files
if [[ ! -d $homedir/QIIME_databases/gg_otus-13_8-release ]]; then
echo "Unpacking Greengenes database.
"
echo "Unpacking Greengenes database." >> $log
cd $homedir/QIIME_databases
tar -xzvf gg_otus-13_8-release.tar.gz 1>$stdout 2>$stderr || true
cd $homedir
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
fi
if [[ ! -d $homedir/QIIME_databases ]]; then
echo "Unpacking UNITE database.
"
echo "Unpacking UNITE database." >> $log
cd $homedir/QIIME_databases
tar -xzvf UNITE_2015-03-02.tar.gz 1>$stdout 2>$stderr || true
cd $homedir
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
fi

exit 0
