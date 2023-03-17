#!/bin/sh

datestr=`date`
TMPLOGFILE=$MYTMP/progress.prerequesites.log

rm -rf $TMPLOGFILE

setup_log () {
  datestr=`date`
  echo "[$datestr] $1" >> $TMPLOGFILE
  echo "[$datestr] $1"
}

validate_folder () {
	DIR="$1"

	setup_log "validate_folder $DIR"

	if [ ! -d "$DIR" ]; then
		setup_log "creating $DIR"
	   	mkdir $DIR
	fi
	setup_log "setting rights on $DIR"
	chmod -R 755 $DIR
}

invoke_install () {
	APP="$1"

	setup_log "installing $APP"

	sudo apt-get -y install $APP >> $TMPLOGFILE
}


sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq python-software-properties < /dev/null > /dev/null

setup_log "full update"
sudo apt update >> $TMPLOGFILE

setup_log "full upgrade"
sudo apt upgrade >> $TMPLOGFILE

sudo apt-get autoremove >> $TMPLOGFILE

invoke_install git
invoke_install cmake
invoke_install python3-dev
invoke_install nano

invoke_install libhdf5-serial-dev
invoke_install hdf5-tools
invoke_install libhdf5-dev
invoke_install zlib1g-dev
invoke_install zip
invoke_install libjpeg8-dev

invoke_install libjpeg-dev 
invoke_install zlib1g-dev
invoke_install libpython3-dev
invoke_install libavcodec-dev
invoke_install libavformat-dev
invoke_install libswscale-dev

invoke_install python3.5
invoke_install python2.7

invoke_install python-pip
invoke_install python-pip3

invoke_install zram-config

sudo apt-get autoremove >> $TMPLOGFILE

if ! [ -x "$(command -v pip)" ]; then
  echo 'Error: pip is not installed.' >&2
  exit 1;
else
	setup_log "pip is installed"
fi

if ! [ -x "$(command -v pip3)" ]; then
  echo 'Error: pip3 is not installed.' >&2
  exit 1;
else
	setup_log "pip3 is installed"
fi

setup_log "virtual env ... pip stuff"

sudo pip3 install -U pip testresources setuptools
sudo pip install virtualenv virtualenvwrapper

setup_log "setting environment values."

# virtualenv and virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/local/bin/virtualenvwrapper.sh

setup_log "reloading profile"
source ~/.bashrc

