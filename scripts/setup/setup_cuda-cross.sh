#!/bin/sh

datestr=`date`
TMPLOGFILE=$MYTMP/progress_cuda-cross.log

rm -rf $TMPLOGFILE

setup_log () {
  datestr=`date`
  echo "[$datestr] $1" >> $TMPLOGFILE
  echo "[$datestr] $1"
}


setup_log "CUDA Toolkit 12.1 CROSS setup started on $datestr"

setup_log "Download cuda-ubuntu2004.pin"

mkdir /home/gp/dev/cuda/cuda
cd /home/gp/dev/cuda/cuda

setup_log "Download cuda-repo-cross-aarch64-ubuntu2004-12-1-local_12.1.0-1_all.deb"
wget https://developer.download.nvidia.com/compute/cuda/12.1.0/local_installers/cuda-repo-cross-aarch64-ubuntu2004-12-1-local_12.1.0-1_all.deb  -O /home/gp/dev/cuda/cuda/cuda-repo-cross-aarch64-ubuntu2004-12-1-local_12.1.0-1_all.deb -o $MYTMP/out.log

setup_log "Validating checksums..."

wget https://developer.download.nvidia.com/compute/cuda/12.1.0/docs/sidebar/md5sum.txt -O $MYTMP/cuda-sums.txt -o $MYTMP/out.log
grep "cuda-repo-cross-aarch64-ubuntu2004-12-1-local_12.1.0-1_all.deb" $MYTMP/cuda-sums.txt > $MYTMP/cuda-validation.txt
md5sum /home/gp/dev/cuda/cuda/cuda-repo-cross-aarch64-ubuntu2004-12-1-local_12.1.0-1_all.deb >>  $MYTMP/cuda-validation.txt

setup_log "Results:"
tail $MYTMP/cuda-validation.txt


setup_log "Unpacking..."
sudo dpkg -i /home/gp/dev/cuda/cuda/cuda-repo-cross-aarch64-ubuntu2004-12-1-local_12.1.0-1_all.deb
sudo cp /var/cuda-repo-cross-aarch64-ubuntu2004-12-1-local/cuda-*-keyring.gpg /usr/share/keyrings/



datestr=`date`

setup_log "APT UPDATE on $datestr"
sudo apt-get update

datestr=`date`
setup_log "CUDA INSTALL on $datestr"

sudo apt-get -y install cuda-cross-aarch64
datestr=`date`

setup_log "Done! $datestr"