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

validate_folder ~/dev

cd ~/dev

setup_log "cloning opencv"
git clone --recurse-submodules https://github.com/opencv/opencv.git

setup_log "cloning opencv-python"
git clone --recurse-submodules https://github.com/opencv/opencv-python.git
