#!/usr/bin/env bash
## Add extra ppas slave script
## Author: Andrew Krohn
## Date: 2015-10-28
## License: MIT
## Version 0.0.1
#set -e

## Define variables from inputs
stdout="$1"
stderr="$2"
log="$3"
homedir="$4"
scriptdir="$5"
userid="$6"
host="$7"
domain="$8"
date0=`date`

## Test for dependencies (use apache2)
	apachetest=`command -v apache2 2>/dev/null | wc -l`
	if [[ "$apachetest" -eq "0" ]]; then
echo "Dependencies are unmet. Correct this by running the installer once without
passing --stacks. Exiting.
	"
echo "Dependencies unmet.  Exiting.
	" >> $log
	exit 1
	else

## Install Stacks
	stackstest=`command -v cstacks 2>/dev/null | wc -l`
	if [[ -z "$stackstest" ]]; then
#	if [[ "$stackstest" -ge "1" ]]; then
## If this conditional is removed, upgrades will be possible, though it will always take longer
echo "Stacks already seems to be installed.
Exiting.
"
echo "Stacks already installed.  Exiting.
" >> $log
	exit 1
	else
echo "Installing Stacks for RADseq applications (bam-enabled).
"
echo "Installing Stacks for RADseq applications (bam-enabled).
" >> $log
tar -xzvf $scriptdir/3rd_party_packages/stacks-1.39.tar.gz  -C /bin/ 1>$stdout 2>$stderr || true
wait
cd /bin/stacks-1.39/
./configure --enable-bam --with-bam-include-path=/usr/include/samtools --with-bam-lib-path=/usr/lib 1>$stdout 2>$stderr || true
make  1>$stdout 2>$stderr || true
wait
sudo make install 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
	wait

## Edit MySQL config file
echo "Configuring mysql and apache webserver.
"
echo "Configuring mysql and apache webserver.
" >> $log
echo "---Copy mysql.cnf file." >> $log
sudo cp /usr/local/share/stacks/sql/mysql.cnf.dist /usr/local/share/stacks/sql/mysql.cnf 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
echo "---Change mysql permissions." >> $log
sed -i "s/user=\w\+/user=${userid}/" /usr/local/share/stacks/sql/mysql.cnf
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
sed -i "s/password=\w\+/password=\"\"/" /usr/local/share/stacks/sql/mysql.cnf
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log

	mysql -u root -e "FLUSH PRIVILEGES";
	mysql -u root -e "SET PASSWORD FOR root@localhost=''";
	mysql -u root -e "SET PASSWORD FOR $userid@localhost=''";
	mysql -u root -e "GRANT ALL ON *.* TO $userid@localhost";
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log

## Enable Stacks web interface in Apache webserver
echo "---Build stacks.conf file for Apache webserver.
"
echo "---Build stacks.conf file for Apache webserver." >> $log
sudo echo '<Directory "/usr/local/share/stacks/php">
        Order deny,allow
        Deny from all
        Allow from all
	Require all granted
</Directory>

Alias /stacks "/usr/local/share/stacks/php"
' > /etc/apache2/conf-available/stacks.conf 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
echo "---Symlink to Apache2 stacks.conf file." >> $log
ln -s /etc/apache2/conf-available/stacks.conf /etc/apache2/conf-enabled/stacks.conf 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
echo "---Restart Apache webserver" >> $log
sudo apachectl restart 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
wait

## Provide access to MySQL database from web interface
echo "---Copy php constants file and change permissions.
"
echo "---Copy php constants file and change permissions." >> $log
cp /usr/local/share/stacks/php/constants.php.dist /usr/local/share/stacks/php/constants.php 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
sudo sed -i "s/dbuser/$userid/" /usr/local/share/stacks/php/constants.php 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
sudo sed -i "s/dbpass/\"\"/" /usr/local/share/stacks/php/constants.php 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log

## Enable web-based exporting from MySQL database
echo "---Enable web-based exporting from MySQL database.
"
echo "---Enable web-based exporting from MySQL database." >> $log
chown $userid /usr/local/share/stacks/php/export 1>$stdout 2>$stderr || true
chmod 775 /usr/local/share/stacks/php/export 1>$stdout 2>$stderr || true
cd

## Update stacks_export_notify.pl
echo "---Update stacks_export_notify.pl script for exporting.
"
echo "---Update stacks_export_notify.pl script for exporting." >> $log
sudo sed -i "s|url           = \"http://stackshost.edu|url           = \"http://$domain|" /usr/local/bin/stacks_export_notify.pl
sudo sed -i "s|local_host    = \"localhost|local_host    = \"$domain|" /usr/local/bin/stacks_export_notify.pl
sudo sed -i "s|from          = \"stacks\@stackshost.edu|from          = \"$userid@$domain|" /usr/local/bin/stacks_export_notify.pl

## Clone and install akutils_RADseq_utility if necessary
cd
	# Fresh git pull if repo already exists
	if [[ -d ~/akutils_RADseq_utility ]]; then
	echo "akutils_RADseq_utility repository already present. Performing fresh git pull.
	"
	echo "akutils_RADseq_utility repository already present. Performing fresh git pull." >> $log
	cd ~/akutils_RADseq_utility
	git pull
	wait
	bash install
	else
	echo "akutils_RADseq_utility not present. Cloning repository from github.
	"
	echo "akutils_RADseq_utility not present. Cloning repository from github." >> $log
	git clone https://github.com/alk224/akutils_RADseq_utility.git
	wait
	chown -R $userid:$userid ~/akutils_RADseq_utility
	cd
	bash ~/akutils_RADseq_utility/install
	fi

## Report completion
echo "Stacks installation complete.
"
echo "Stacks installation complete.
" >> $log
	fi
	fi

exit 0
