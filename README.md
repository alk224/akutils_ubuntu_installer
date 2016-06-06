**2016-06-06 update**  
Stacks component now functional. This is great if you do your analysis on a cluster and need to view your database locally. See below for instructions.  

***Date: 2015-08-29  
Author: Andrew Krohn***  

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
sudo apt-get -yfm upgrade (upgrades your system to latest 14.04.x noninteractively)  
sudo apt-get install git (install git)  
git clone https://github.com/alk224/akutils_ubuntu_installer.git (clone the installer repository)  
sudo bash ~/ak_ubuntu_installer/ak_ubuntu_installation.sh install (run the installer script)  

Sometimes the installation is not completed on the first pass, so it is probably useful to reboot now, then rerun the last command a second time. The scripts are built on conditional statments so most of the steps are skipped if they were successfully completed already.  

**OTHER FUNCTIONS**  

    sudo bash ~/akutils_ubuntu_installer/akutils_ubuntu_installation.sh install --stacks (install stacks for RADseq analysis -- only after installer has been run at least once)  
    sudo bash ~/akutils_ubuntu_installer/akutils_ubuntu_installation.sh install --force-R (run all R package updates)  

    bash ~/ak_ubuntu_installer/ak_ubuntu_installation.sh (print help screen)  
    bash ~/ak_ubuntu_installer/ak_ubuntu_installation.sh list (list of software to be installed)  
    bash ~/ak_ubuntu_installer/ak_ubuntu_installation.sh test (test of installed software via QIIME)  

**QIIME INSTALLATION RESULT**  

This is from my iPlant instance:  

System information  
==================  
         Platform:	linux2  
   Python version:	2.7.6 (default, Jun 22 2015, 17:58:13)  [GCC 4.8.2]  
Python executable:	/usr/bin/python  

QIIME default reference information  
===================================  
For details on what files are used as QIIME's default references, see here:  
 https://github.com/biocore/qiime-default-reference/releases/tag/0.1.3  

Dependency versions  
===================  
                QIIME library version:	1.9.1  
                 QIIME script version:	1.9.1  
      qiime-default-reference version:	0.1.3  
                        NumPy version:	1.9.1  
                        SciPy version:	0.15.1  
                       pandas version:	0.16.2  
                   matplotlib version:	1.3.1  
                  biom-format version:	2.1.4  
                         h5py version:	2.4.0 (HDF5 version: 1.8.11)  
                         qcli version:	0.1.1  
                         pyqi version:	0.3.2  
                   scikit-bio version:	0.2.3  
                       PyNAST version:	1.2.2  
                      Emperor version:	0.9.51  
                      burrito version:	0.9.1  
             burrito-fillings version:	0.1.1  
                    sortmerna version:	SortMeRNA version 2.0, 29/11/2014  
                    sumaclust version:	SUMACLUST Version 1.0.00  
                        swarm version:	Swarm 1.2.19 [Sep  1 2015 21:06:49]  
                                gdata:	Installed.  
RDP Classifier version (if installed):	rdp_classifier-2.2.jar  
          Java version (if installed):	1.7.0_79  
  
QIIME config values  
===================  
For definitions of these settings and to learn how to configure QIIME, see here:  
 http://qiime.org/install/qiime_config.html  
 http://qiime.org/tutorials/parallel_qiime.html  
  
                     blastmat_dir:	/home/alk224/qiime_1.9.1/blast-2.2.22-release/data  
      pick_otus_reference_seqs_fp:  	/usr/local/lib/python2.7/dist-packages/qiime_default_reference/gg_13_8_otus/rep_set/97_otus.fasta  
                         sc_queue:	all.q  
      topiaryexplorer_project_dir:	None  
     pynast_template_alignment_fp:  	/usr/local/lib/python2.7/dist-packages/qiime_default_reference/gg_13_8_otus/rep_set_aligned/85_otus.pynast.fasta  
                  cluster_jobs_fp:	start_parallel_jobs.py  
pynast_template_alignment_blastdb:	None  
assign_taxonomy_reference_seqs_fp:  	/usr/local/lib/python2.7/dist-packages/qiime_default_reference/gg_13_8_otus/rep_set/97_otus.fasta  
                     torque_queue:	friendlyq  
                    jobs_to_start:	1  
                       slurm_time:	None  
            denoiser_min_per_core:	50  
assign_taxonomy_id_to_taxonomy_fp:  	/usr/local/lib/python2.7/dist-packages/qiime_default_reference/gg_13_8_otus/taxonomy/97_otu_taxonomy.txt  
                         temp_dir:	/tmp/  
                     slurm_memory:	None  
                      slurm_queue:	None  
                      blastall_fp:	/home/alk224/qiime_1.9.1/blast-2.2.22-release/bin/blastall  
                 seconds_to_sleep:	1  
  
QIIME full install test results  
===============================  
..........................F  
======================================================================  
FAIL: test_usearch_supported_version (__main__.QIIMEDependencyFull)  
usearch is in path and version is supported  
----------------------------------------------------------------------  
Traceback (most recent call last):  
  File "/usr/local/bin/print_qiime_config.py", line 650, in test_usearch_supported_version  
    "which components of QIIME you plan to use.")  
AssertionError: usearch not found. This may or may not be a problem depending on which components of QIIME you plan to use.  
  
----------------------------------------------------------------------  
Ran 27 tests in 0.197s  
  
FAILED (failures=1)  
