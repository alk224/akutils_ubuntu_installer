**2016-06-06 update**  
Stacks component now functional. This is great if you do your analysis on a cluster and need to view your database locally. See below for instructions.  

***Date: 2015-08-29  
Author: Lela Andrews***  

These scripts are meant to ease rebuilding of my bioinformatics computer when (not if) the system drive fails.  It also facilitates establishing a new cloud instance (say on EC2 or iPLANT) or if you wish to set up a VM in some other environment.  

**REQUIREMENTS FOR THIS TO WORK**

1) Functioning Ubuntu install (tested only on 14.04 LTS)  
2) All updates in place  

Probably best for a fresh install.  If you have some other verison of python or other dependencies already in place, this might not work very well, or it could work fine and wreck something else dear to you instead.  If your system has an Nvidia graphics card, make sure to enable the proprietary drivers before you start the installer.  

**PRE-INSTALLATION INSTRUCTIONS (Virtualbox)**  

1) Download and install [Oracle VirtualBox](https://www.virtualbox.org/)  
2) Download [Ubuntu 14.04.1 iso](http://old-releases.ubuntu.com/releases/14.04.0/ubuntu-14.04.1-desktop-amd64.iso) (some problems with .2 and .3 versions)  
3) Start virtualbox, and install the .iso file (find instructions elsewhere)  
4) Run the following command upon initial reboot to gain full-screen functionality  

    sudo apt-get install virtualbox-guest-x11  

5) Reboot your vm instance  
6) Make any system customizations now, then proceed with installation instructions below  

**INSTALLATION INSTRUCTIONS**  

Open a terminal (ctrl-alt-T) and issue the following commands:  

    cd  
    sudo apt-get update  
    sudo apt-get -yfm upgrade  
    sudo apt-get install git  
    git clone https://github.com/alk224/akutils_ubuntu_installer.git  
    sudo bash ~/akutils_ubuntu_installer/akutils_ubuntu_installation.sh install  

**END INSTALLATION INSTRUCTIONS**  

Explanation of above commands:  

    cd (takes you to your home directory)  
    sudo apt-get update (updates your software cache to prepare to upgrade the system)  
    sudo apt-get -yfm upgrade (noninteractively upgrades your system to latest 14.04.x)  
    sudo apt-get install git (install git)  
    git clone https://github.com/alk224/akutils_ubuntu_installer.git (clone the installer repository)  
    sudo bash ~/ak_ubuntu_installer/ak_ubuntu_installation.sh install (run the installer script)  

Sometimes the installation is not completed on the first pass, so it is probably useful to reboot now, then rerun the last command a second time. The scripts are built on conditional statments so most of the steps are skipped if they were successfully completed already.  

**OTHER FUNCTIONS**  

    sudo bash ~/akutils_ubuntu_installer/akutils_ubuntu_installation.sh install --stacks (install Stacks for RADseq analysis -- only after installer has been run at least once)  
    sudo bash ~/akutils_ubuntu_installer/akutils_ubuntu_installation.sh install --force-R (run all R package updates)  

    bash ~/ak_ubuntu_installer/ak_ubuntu_installation.sh (print help screen)  
    bash ~/ak_ubuntu_installer/ak_ubuntu_installation.sh list (list of software to be installed)  
    bash ~/ak_ubuntu_installer/ak_ubuntu_installation.sh test (test of installed software via QIIME)  

**Important notes**  

You can expect the QIIME test at the end of the installer to fail the Usearch and INFERNAL tests. If you want Usearch, you must install it yourself and this failure will go away. The binaries must be properly named for QIIME to address it (see the [QIIME installation page](http://qiime.org/install/install.html) for more details).  

If installing as a guest within a virtual environment (VirtualBox, for instance), make sure your hostname is entered as "localhost" and your domain is specific to your network (nau.edu for me). However, there is a good chance these settings won't matter for you anyway. Hostname and domain are important when you need your system to email you results, such as from a Stacks web interface, or to receive emails from the Task Spooler utility as jobs complete or fail. This works well on stand-alone systems with a static IP address and from cloud accounts on iPlant and EC2. You may need to run the sendmail config program once (choose defaults) to get everything work properly.  

**Citing this repository**  

Lela Andrews. (2016). akutils_ubuntu_installer v1.1.0: Simple bioinformatic software installer. Zenodo. 10.5281/zenodo.56762  

[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.56762.svg)](http://dx.doi.org/10.5281/zenodo.56762)  

