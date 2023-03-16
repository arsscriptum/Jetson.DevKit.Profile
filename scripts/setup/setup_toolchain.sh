#!/bin/sh

datestr=`date`
TMPLOGFILE=$MYTMP/progress_toolchainsetup.log

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
	    sudo mkdir $DIR
	fi
	setup_log "setting rights on $DIR"
	sudo chmod -R u=rwx,go=rx $DIR
}


setup_log "SETTING UP TOOLCHAIN"


validate_folder ~/dev/toolchain-setup
validate_folder ~/l4t-gcc

cd $HOME/l4t-gcc

echo "DOWNLOADING TOOLCHAIN"
wget https://developer.nvidia.com/embedded/jetson-linux/bootlin-toolchain-gcc-93 -O ~/dev/toolchain-setup/toolchain-gcc.tar.gz

echo "EXTRACTING TOOLCHAIN TO $HOME/l4t-gcc"
tar -xf ~/dev/toolchain-setup/toolchain-gcc.tar.gz --directory $HOME/l4t-gcc

export CROSS_COMPILE=$HOME/l4t-gcc/bin/aarch64-buildroot-linux-gnu-

