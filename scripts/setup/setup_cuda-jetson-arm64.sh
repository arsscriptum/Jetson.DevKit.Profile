#!/bin/sh

datestr=`date`
TMPLOGFILE=$MYTMP/progress_cuda_jetsonarm64.log

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


setup_log "check dir ~/dev/cuda"
validate_folder ~/dev/cuda
cd ~/dev/cuda

validate_folder ~/dev/cuda/download

setup_log "start download cuda-ubuntu2204.pin to ~/dev/cuda/download/cuda-ubuntu2204.pin"
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/sbsa/cuda-ubuntu2204.pin -O ~/dev/cuda/download/cuda-ubuntu2204.pin -o $TMYMP/cudaout.log

setup_log "copy downloaded file to /etc/apt/preferences.d/cuda-repository-pin-600"
sudo cp ~/dev/cuda/download/cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600


setup_log "start download cuda-repo-ubuntu2204-12-1-local_12.1.0-530.30.02-1_arm64.deb to ~/dev/cuda/download/cuda-repo-ubuntu2204-12-1-local_12.1.0-530.30.02-1_arm64.deb"
wget https://developer.download.nvidia.com/compute/cuda/12.1.0/local_installers/cuda-repo-ubuntu2204-12-1-local_12.1.0-530.30.02-1_arm64.deb -O ~/dev/cuda/download/cuda-repo-ubuntu2204-12-1-local_12.1.0-530.30.02-1_arm64.deb -o $TMYMP/cudaout.log

setup_log "unpacking downloaded file ~/dev/cuda/download/cuda-repo-ubuntu2204-12-1-local_12.1.0-530.30.02-1_arm64.deb"
sudo dpkg -i ~/dev/cuda/download/cuda-repo-ubuntu2204-12-1-local_12.1.0-530.30.02-1_arm64.deb

setup_log "copy /var/cuda-repo-ubuntu2204-12-1-local/cuda-*-keyring.gpg to /usr/share/keyrings/"
sudo cp /var/cuda-repo-ubuntu2204-12-1-local/cuda-*-keyring.gpg /usr/share/keyrings/


setup_log "apt update"

sudo apt-get update

setup_log "apt install"

sudo apt-get -y install cuda

setup_log "CUDA Toolkit 12.1 Downloads Completed!"