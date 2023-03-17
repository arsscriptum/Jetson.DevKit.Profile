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
	   	mkdir $DIR
	fi
	setup_log "setting rights on $DIR"
	chmod -R 755 $DIR
}


setup_log "CUDA Toolkit 12.1 Downloads"


validate_folder ~/dev/cuda
validate_folder ~/dev/cuda/download
validate_folder ~/dev/cuda/cuda-src


wget https://developer.download.nvidia.com/compute/cuda/12.1.0/local_installers/cuda-repo-cross-sbsa-ubuntu2204-12-1-local_12.1.0-1_all.deb -O ~/dev/cuda/download/cuda-repo-cross-sbsa-ubuntu2204-12-1-local_12.1.0-1_all.deb -o $TMYMP/cudaout.log

setup_log "unpacking downloaded file ~/dev/cuda/download/cuda-repo-cross-sbsa-ubuntu2204-12-1-local_12.1.0-1_all.deb"
sudo dpkg -i ~/dev/cuda/download/cuda-repo-cross-sbsa-ubuntu2204-12-1-local_12.1.0-1_all.deb 

setup_log "copy /var/cuda-repo-cross-sbsa-ubuntu2204-12-1-local/cuda-*-keyring.gpg to /usr/share/keyrings/"
sudo cp /var/cuda-repo-cross-sbsa-ubuntu2204-12-1-local/cuda-*-keyring.gpg /usr/share/keyrings/



setup_log "apt update"

sudo apt-get update

setup_log "apt install"

sudo apt-get -y install cuda-cross-sbsa

setup_log "CUDA Toolkit 12.1 Downloads Completed!"

sudo apt-get -y install cuda-cross-sbsa