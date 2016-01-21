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
email="$6"
date0=`date`

## Upgrading pip
pipver=`python -c "import pip; print pip.__version__" 2>/dev/null`
if [[ $pipver != 7.1.2 ]]; then
echo "Installing pip v7.1.2.
"
echo "Installing pip v7.1.2." >> $log
pip install pip==7.1.2 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
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
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
wait
else
echo "Numpy already correct version (1.9.1).
"
fi

## Install cutadapt
	cutadapttest=`command -v cutadapt 2>/dev/null | wc -l`
	if [[ $cutadapttest == 0 ]]; then
echo "Installing Cutadapt.
"
echo "Installing Cutadapt." >> $log
pip install cutadapt 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
wait
else
echo "Cutadapt already installed.
"
fi

## Install scipy
scipyver=`python -c "import scipy; print scipy.version.version" 2>/dev/null`
if [[ $scipyver != 0.15.1 ]]; then
echo "Installing Scipy v0.15.1.
"
echo "Installing Scipy v0.15.1." >> $log
pip install scipy==0.15.1 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
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
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
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
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
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
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
wait
else
echo "h5py already correct version (2.4.0).
"
fi

## Install QIIME base
qiimever=`python -c "import qiime; print qiime.__version__" 2>/dev/null`
if [[ $qiimever != 1.9.1 ]]; then
echo "Installing QIIME base v1.9.1.
"
echo "Installing QIIME base v1.9.1." >> $log
pip install qiime==1.9.1 1>$stdout 2>$stderr || true
	bash $scriptdir/scripts/log_slave.sh $stdout $stderr $log
wait
else
echo "QIIME base install already correct version (1.9.1).
"
fi

exit 0
