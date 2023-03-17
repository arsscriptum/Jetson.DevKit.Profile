#!/bin/sh

datestr=`date`
TMPLOGFILE=$MYTMP/progress_cuda_native.log

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

validate_folder ~/dev/cuda
validate_folder ~/dev/cuda/download
validate_folder ~/dev/cuda/cuda-src


setup_log "CUDA Toolkit 12.1 Setup started on $datestr"

setup_log "Download cuda-ubuntu2004.pin"


cd /home/gp/dev/cuda/cuda

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/arm64/cuda-ubuntu2004.pin -O ~/dev/cuda/download/cuda-ubuntu2004.pin -o $MYTMP/out.log
sudo cp ~/dev/cuda/download/cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 --force

setup_log "Download cuda-tegra-repo-ubuntu2004-12-1-local_12.1.0-1_arm64.deb"
wget https://developer.download.nvidia.com/compute/cuda/12.1.0/local_installers/cuda-tegra-repo-ubuntu2004-12-1-local_12.1.0-1_arm64.deb  -O ~/dev/cuda/download/cuda-tegra-repo-ubuntu2004-12-1-local_12.1.0-1_arm64.deb -o $MYTMP/out.log

setup_log "UNPACKING"
sudo dpkg -i ~/dev/cuda/download/cuda-tegra-repo-ubuntu2004-12-1-local_12.1.0-1_arm64.deb
sudo cp /var/cuda-tegra-repo-ubuntu2004-12-1-local/cuda-*-keyring.gpg /usr/share/keyrings/

datestr=`date`

setup_log "APT UPDATE on $datestr"
sudo apt-get update

datestr=`date`
setup_log "CUDA INSTALL on $datestr"
sudo apt-get -y install cuda

setup_log "Done!"