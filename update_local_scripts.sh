#!/bin/sh

datestr=`date`
TMPLOGFILE=$MYTMP/progress_cuda_cross-sbsa.log

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


setup_log "CUDA SOURCE DOWNLOAD"

validate_folder ~/dev/cuda
validate_folder ~/dev/cuda/downlo


