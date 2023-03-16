#!/bin/sh

datestr=`date`
TMPLOGFILE=$MYTMP/progress.prerequesites.log

rm -rf $TMPLOGFILE

setup_log () {
  datestr=`date`
  echo "[$datestr] $1" >> $TMPLOGFILE
  echo "[$datestr] $1"
}



setup_log "PreRequesites Update Startup"

sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq python-software-properties < /dev/null > /dev/null

setup_log "========== APT-GET UPDATE START ========="
sudo apt update

setup_log "========== APT-GET UPGRADE START ========="
sudo apt upgrade
sudo apt-get autoremove


setup_log "========== INITIALIZATION DONE ========="


setup_log "========== INSTALLATION STEP 1 START ========="
sudo apt-get --assume-yes install git
sudo apt-get --assume-yes install cmake
sudo apt-get --assume-yes install python3-dev
sudo apt-get --assume-yes install nano
sudo apt-get autoremove

setup_log "========== STEP 1 TERMINATED ========="


setup_log "========== INSTALLATION STEP 2 START ========="
sudo apt-get --assume-yes install libhdf5-serial-dev
sudo apt-get --assume-yes install hdf5-tools
sudo apt-get --assume-yes install libhdf5-dev
sudo apt-get --assume-yes install zlib1g-dev
sudo apt-get --assume-yes install zip
sudo apt-get --assume-yes install libjpeg8-dev
sudo apt-get autoremove


setup_log "========== STEP 2 TERMINATED ========="

setup_log "========== INSTALLATION STEP 3 START ========="
sudo apt-get --assume-yes install libjpeg-dev zlib1g-dev libpython3-dev libavcodec-dev libavformat-dev libswscale-dev
setup_log "========== STEP 3 TERMINATED ========="

sudo apt-get autoremove

setup_log "========== PYTHON 3.5 =========="
sudo apt-get --assume-yes install python3.5
setup_log "========== PYTHON 2.7 =========="
sudo apt-get --assume-yes install python2.7

if ! [ -x "$(command -v pip)" ]; then
  echo 'Error: pip is not installed.' >&2
  sudo apt-get install python-pip
else
	setup_log "pip is installed"
fi

if ! [ -x "$(command -v pip3)" ]; then
  echo 'Error: pip3 is not installed.' >&2
  sudo apt-get install python3-pip
else
	setup_log "pip3 is installed"
fi

setup_log "========== SETTING UP TOOLS ========="
setup_log "pip3 install ; pip, testresources setuptools ; "
sudo pip3 install -U pip testresources setuptools

setup_log " virtualenv virtualenvwrapper "
sudo pip install virtualenv virtualenvwrapper

setup_log " SETTING ENVIRONMENT VALUES ... "

# virtualenv and virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/local/bin/virtualenvwrapper.sh

setup_log "RELOADING PROFILE"
source ~/.bashrc


setup_log "INSTALLING zram-config"
sudo apt-get --assume-yes install zram-config




setup_log "================================================="

setup_log "========== PREREQUESITS SCRIPT COMPLETE ========="
setup_log "================================================="


